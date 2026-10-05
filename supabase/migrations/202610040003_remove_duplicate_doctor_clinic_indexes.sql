-- Older schema updates left several unique indexes on doctor_id behind.
-- Remove all standalone unique indexes that enforce one clinic per doctor.
do $$
declare
  clinic_index record;
begin
  for clinic_index in
    select index_class.relname as index_name
    from pg_index index_info
    join pg_class table_class on table_class.oid = index_info.indrelid
    join pg_namespace table_schema on table_schema.oid = table_class.relnamespace
    join pg_class index_class on index_class.oid = index_info.indexrelid
    where table_schema.nspname = 'public'
      and table_class.relname = 'clinic_data'
      and index_info.indisunique
      and not index_info.indisprimary
      and index_info.indnkeyatts = 1
      and index_info.indnatts = 1
      and index_info.indexprs is null
      and index_info.indpred is null
      and exists (
        select 1
        from unnest(index_info.indkey) key_attribute(attnum)
        join pg_attribute attribute
          on attribute.attrelid = table_class.oid
         and attribute.attnum = key_attribute.attnum
        where attribute.attname = 'doctor_id'
      )
      and not exists (
        select 1 from pg_constraint constraint_info
        where constraint_info.conindid = index_info.indexrelid
      )
  loop
    execute format('drop index public.%I', clinic_index.index_name);
  end loop;
end;
$$;
