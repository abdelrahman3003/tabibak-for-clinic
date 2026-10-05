-- A doctor owns clinics; clinic-scoped records point to the selected clinic.
alter table public.appointments
  add column if not exists clinic_id bigint references public.clinic_data(id) on delete cascade;

-- Preserve existing data by assigning legacy appointments to the doctor's first clinic.
update public.appointments appointment
set clinic_id = (
  select id from public.clinic_data
  where doctor_id = appointment.doctor_id
  order by id asc
  limit 1
)
where appointment.clinic_id is null;

create index if not exists appointments_clinic_date_idx
  on public.appointments (clinic_id, appointment_date, status);

alter table public.notifications
  add column if not exists clinic_id bigint references public.clinic_data(id) on delete cascade;


create or replace function public.recalculate_appointment_waiting_list(
  p_doctor_id uuid,
  p_queue_date date,
  p_clinic_id bigint default null
)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if p_doctor_id is null or p_queue_date is null then return; end if;
  with ranked_appointments as (
    select appointment.id,
      (pg_catalog.row_number() over (order by appointment.created_at asc nulls last, appointment.id asc) - 1)::integer as waiting_list
    from public.appointments appointment
    where appointment.doctor_id = p_doctor_id
      and (p_clinic_id is null or appointment.clinic_id = p_clinic_id)
      and coalesce(appointment.follow_up_date::date, appointment.appointment_date::date) = p_queue_date
      and appointment.status in (1, 2)
  )
  update public.appointments appointment
  set waiting_list = ranked_appointments.waiting_list
  from ranked_appointments
  where appointment.id = ranked_appointments.id
    and appointment.waiting_list is distinct from ranked_appointments.waiting_list;
end; $$;

create or replace function public.maintain_appointment_waiting_list()
returns trigger language plpgsql security definer set search_path = '' as $$
declare old_queue_date date; new_queue_date date;
begin
  if tg_op = 'UPDATE' then
    old_queue_date := coalesce(old.follow_up_date::date, old.appointment_date::date);
  end if;
  new_queue_date := coalesce(new.follow_up_date::date, new.appointment_date::date);
  if new.status not in (1, 2) then
    update public.appointments set waiting_list = null where id = new.id and waiting_list is not null;
  end if;
  if tg_op = 'INSERT' then
    if new.status in (1, 2) then
      perform public.recalculate_appointment_waiting_list(new.doctor_id, new_queue_date, new.clinic_id);
    end if;
    return new;
  end if;
  if old.status in (1, 2) and (old.doctor_id is distinct from new.doctor_id
     or old.clinic_id is distinct from new.clinic_id or old_queue_date is distinct from new_queue_date
     or new.status not in (1, 2)) then
    perform public.recalculate_appointment_waiting_list(old.doctor_id, old_queue_date, old.clinic_id);
  end if;
  if new.status in (1, 2) and (old.status not in (1, 2)
     or old.doctor_id is distinct from new.doctor_id or old.clinic_id is distinct from new.clinic_id
     or old_queue_date is distinct from new_queue_date) then
    perform public.recalculate_appointment_waiting_list(new.doctor_id, new_queue_date, new.clinic_id);
  end if;
  return new;
end; $$;

drop trigger if exists appointments_maintain_waiting_list on public.appointments;
create trigger appointments_maintain_waiting_list
after insert or update of doctor_id, clinic_id, appointment_date, follow_up_date, status
on public.appointments for each row execute function public.maintain_appointment_waiting_list();

create or replace function public.capture_appointment_fees()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  consultation_fee double precision;
  follow_up_fee double precision;
  consultation_completed boolean := false;
  follow_up_completed boolean := false;
  charge_date date := pg_catalog.timezone('Africa/Cairo', pg_catalog.statement_timestamp())::date;
begin
  if tg_op = 'INSERT' then
    consultation_completed := new.status = 3 or new.follow_up_date is not null;
  else
    consultation_completed := (new.status = 3 and old.status is distinct from 3)
      or (new.follow_up_date is not null and old.follow_up_date is null);
    follow_up_completed := new.status = 3 and old.status is distinct from 3
      and new.follow_up_date is not null;
  end if;

  if not consultation_completed and not follow_up_completed then return new; end if;

  select clinic.consultation_fee::double precision, clinic.follow_up_fee::double precision
  into consultation_fee, follow_up_fee
  from public.clinic_data clinic
  where clinic.id = new.clinic_id and clinic.doctor_id = new.doctor_id;
  if not found then return new; end if;

  if consultation_completed and new.consultation_fee_charged is null then
    new.consultation_fee_charged := coalesce(consultation_fee, 0);
    new.consultation_fee_charged_at := charge_date;
  end if;
  if follow_up_completed and new.follow_up_fee_charged is null then
    new.follow_up_fee_charged := coalesce(follow_up_fee, 0);
    new.follow_up_fee_charged_at := charge_date;
  end if;
  return new;
end;
$$;
