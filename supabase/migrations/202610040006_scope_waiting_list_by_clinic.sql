-- Appointment queues belong to clinics. Keep the existing function signature
-- for trigger compatibility, but scope ranking only by clinic and date.
create or replace function public.recalculate_appointment_waiting_list(
  p_doctor_id uuid,
  p_queue_date date,
  p_clinic_id bigint default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_clinic_id is null or p_queue_date is null then return; end if;

  with ranked_appointments as (
    select appointment.id,
      (pg_catalog.row_number() over (
        order by appointment.created_at asc nulls last, appointment.id asc
      ) - 1)::integer as waiting_list
    from public.appointments appointment
    where appointment.clinic_id = p_clinic_id
      and coalesce(appointment.follow_up_date::date, appointment.appointment_date::date) = p_queue_date
      and appointment.status in (1, 2)
  )
  update public.appointments appointment
  set waiting_list = ranked_appointments.waiting_list
  from ranked_appointments
  where appointment.id = ranked_appointments.id
    and appointment.waiting_list is distinct from ranked_appointments.waiting_list;
end;
$$;
