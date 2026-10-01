alter table public.appointments
  add column if not exists consultation_fee_charged double precision,
  add column if not exists consultation_fee_charged_at date,
  add column if not exists follow_up_fee_charged double precision,
  add column if not exists follow_up_fee_charged_at date;

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
  charge_date date := pg_catalog.timezone(
    'Africa/Cairo',
    pg_catalog.statement_timestamp()
  )::date;
begin
  if tg_op = 'INSERT' then
    consultation_completed := new.status = 3 or new.follow_up_date is not null;
  else
    consultation_completed :=
      (new.status = 3 and old.status is distinct from 3)
      or (new.follow_up_date is not null and old.follow_up_date is null);
    follow_up_completed :=
      new.status = 3
      and old.status is distinct from 3
      and new.follow_up_date is not null;
  end if;

  if not consultation_completed and not follow_up_completed then
    return new;
  end if;

  select clinic.consultation_fee::double precision,
         clinic.follow_up_fee::double precision
  into consultation_fee, follow_up_fee
  from public.clinic_data as clinic
  where clinic.doctor_id = new.doctor_id
  order by clinic.id asc
  limit 1;

  if not found then
    return new;
  end if;

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

revoke all on function public.capture_appointment_fees()
  from public, anon, authenticated;

drop trigger if exists appointments_capture_fees on public.appointments;

create trigger appointments_capture_fees
before insert or update of status, follow_up_date
on public.appointments
for each row
execute function public.capture_appointment_fees();

-- Record consultation charges for visits already completed or already given
-- a follow-up date. Do not infer historical follow-up completions: the old
-- schema did not distinguish those from a completed initial consultation.
update public.appointments as appointment
set consultation_fee_charged = coalesce((
      select clinic.consultation_fee
      from public.clinic_data as clinic
      where clinic.doctor_id = appointment.doctor_id
      order by clinic.id asc
      limit 1
    ), 0)::double precision,
    consultation_fee_charged_at = appointment.appointment_date
where (appointment.status = 3 or appointment.follow_up_date is not null)
  and appointment.consultation_fee_charged is null
  and exists (
    select 1
    from public.clinic_data as clinic
    where clinic.doctor_id = appointment.doctor_id
  );
