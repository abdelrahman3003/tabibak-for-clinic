-- Remove every single-column UNIQUE constraint that limits doctors to one clinic.
do $$
declare
  clinic_constraint record;
begin
  for clinic_constraint in
    select constraint_info.conname as constraint_name
    from pg_constraint constraint_info
    join pg_attribute attribute
      on attribute.attrelid = constraint_info.conrelid
     and attribute.attnum = constraint_info.conkey[1]
    where constraint_info.conrelid = 'public.clinic_data'::regclass
      and constraint_info.contype = 'u'
      and cardinality(constraint_info.conkey) = 1
      and attribute.attname = 'doctor_id'
  loop
    execute format(
      'alter table public.clinic_data drop constraint %I',
      clinic_constraint.constraint_name
    );
  end loop;
end;
$$;
