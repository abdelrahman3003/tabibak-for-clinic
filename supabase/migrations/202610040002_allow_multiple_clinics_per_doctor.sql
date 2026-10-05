-- A doctor can own more than one clinic; clinic_data.id remains the row key.
alter table public.clinic_data
  drop constraint if exists clinic_data_doctor_id_key;
