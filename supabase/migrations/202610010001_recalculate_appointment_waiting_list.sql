-- Keep each doctor's active waiting lists in sync when appointments are
-- created, completed, cancelled, or moved to a follow-up date.
create or replace function public.recalculate_appointment_waiting_list(
  p_doctor_id uuid,
  p_queue_date date
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_doctor_id is null or p_queue_date is null then
    return;
  end if;

  with ranked_appointments as (
    select
      appointment.id,
      (pg_catalog.row_number() over (
        order by appointment.created_at asc nulls last, appointment.id asc
      ) - 1)::integer as waiting_list
    from public.appointments as appointment
    where appointment.doctor_id = p_doctor_id
      and coalesce(
        appointment.follow_up_date::date,
        appointment.appointment_date::date
      ) = p_queue_date
      and appointment.status in (1, 2)
  )
  update public.appointments as appointment
  set waiting_list = ranked_appointments.waiting_list
  from ranked_appointments
  where appointment.id = ranked_appointments.id
    and appointment.waiting_list is distinct from ranked_appointments.waiting_list;
end;
$$;

revoke all on function public.recalculate_appointment_waiting_list(uuid, date)
  from public, anon, authenticated;

create or replace function public.maintain_appointment_waiting_list()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  old_queue_date date;
  new_queue_date date;
begin
  if tg_op = 'UPDATE' then
    old_queue_date := coalesce(
      old.follow_up_date::date,
      old.appointment_date::date
    );
  end if;

  new_queue_date := coalesce(
    new.follow_up_date::date,
    new.appointment_date::date
  );

  -- Finished and cancelled appointments are no longer queue members.
  if new.status not in (1, 2) then
    update public.appointments
    set waiting_list = null
    where id = new.id
      and waiting_list is not null;
  end if;

  if tg_op = 'INSERT' then
    if new.status in (1, 2) then
      perform public.recalculate_appointment_waiting_list(
        new.doctor_id,
        new_queue_date
      );
    end if;
    return new;
  end if;

  -- Remove the old position if the appointment left that active queue.
  if old.status in (1, 2)
     and (old.doctor_id is distinct from new.doctor_id
       or old_queue_date is distinct from new_queue_date
       or new.status not in (1, 2)) then
    perform public.recalculate_appointment_waiting_list(
      old.doctor_id,
      old_queue_date
    );
  end if;

  -- Assign/recalculate the destination queue for active appointments.
  if new.status in (1, 2)
     and (old.status not in (1, 2)
       or old.doctor_id is distinct from new.doctor_id
       or old_queue_date is distinct from new_queue_date) then
    perform public.recalculate_appointment_waiting_list(
      new.doctor_id,
      new_queue_date
    );
  end if;

  return new;
end;
$$;

revoke all on function public.maintain_appointment_waiting_list()
  from public, anon, authenticated;

drop trigger if exists appointments_maintain_waiting_list
  on public.appointments;

create trigger appointments_maintain_waiting_list
after insert or update of doctor_id, appointment_date, follow_up_date, status
on public.appointments
for each row
execute function public.maintain_appointment_waiting_list();

-- Repair queue positions already stored before this trigger was installed.
update public.appointments
set waiting_list = null
where status not in (1, 2)
  and waiting_list is not null;

with ranked_appointments as (
  select
    appointment.id,
    (pg_catalog.row_number() over (
      partition by appointment.doctor_id,
        coalesce(appointment.follow_up_date::date,
                 appointment.appointment_date::date)
      order by appointment.created_at asc nulls last, appointment.id asc
    ) - 1)::integer as waiting_list
  from public.appointments as appointment
  where appointment.status in (1, 2)
)
update public.appointments as appointment
set waiting_list = ranked_appointments.waiting_list
from ranked_appointments
where appointment.id = ranked_appointments.id
  and appointment.waiting_list is distinct from ranked_appointments.waiting_list;
