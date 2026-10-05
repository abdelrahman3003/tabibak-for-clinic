-- Older appointments had no clinic_id. Assign them to the doctor's original
-- clinic (the lowest clinic ID), matching the single-clinic data model.
update public.appointments appointment
set clinic_id = (
  select clinic.id
  from public.clinic_data clinic
  where clinic.doctor_id = appointment.doctor_id
  order by clinic.id
  limit 1
)
where appointment.clinic_id is null
  and exists (
    select 1
    from public.clinic_data clinic
    where clinic.doctor_id = appointment.doctor_id
  );
