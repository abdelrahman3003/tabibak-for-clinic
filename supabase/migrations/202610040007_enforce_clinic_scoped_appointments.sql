-- Every appointment must belong to a real clinic owned by its doctor.
alter table public.clinic_data
  add constraint clinic_data_id_doctor_id_key unique (id, doctor_id);

alter table public.appointments
  alter column clinic_id set not null;

alter table public.appointments
  add constraint appointments_clinic_doctor_fkey
  foreign key (clinic_id, doctor_id)
  references public.clinic_data (id, doctor_id)
  on delete cascade;

-- Explicit clinic-aware insert path for clients that create appointments via RPC.
create or replace function public.add_appointment_with_waiting_list(
  p_appointment_date date,
  p_doctor_id uuid,
  p_clinic_id bigint,
  p_user_id uuid,
  p_status integer,
  p_phone text,
  p_name text,
  p_description text,
  p_shift_morning_id integer,
  p_shift_evening_id integer,
  p_appointment_type integer
)
returns setof public.appointments
language plpgsql
security definer
set search_path = ''
as $$
declare
  next_waiting_list integer;
begin
  if not exists (
    select 1 from public.clinic_data clinic
    where clinic.id = p_clinic_id and clinic.doctor_id = p_doctor_id
  ) then
    raise exception 'Clinic does not belong to doctor';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_clinic_id::text || ':' || p_appointment_date::text, 0)
  );

  select coalesce(max(appointment.waiting_list), 0) + 1
    into next_waiting_list
    from public.appointments appointment
   where appointment.clinic_id = p_clinic_id
     and appointment.appointment_date = p_appointment_date
     and appointment.status in (1, 2);

  return query
  insert into public.appointments (
    appointment_date,
    doctor_id,
    clinic_id,
    user_id,
    status,
    phone,
    name,
    description,
    appointment_morning_shift_id,
    appointment_evening_shift_id,
    appointment_type,
    waiting_list
  ) values (
    p_appointment_date,
    p_doctor_id,
    p_clinic_id,
    p_user_id,
    p_status,
    p_phone,
    p_name,
    p_description,
    p_shift_morning_id,
    p_shift_evening_id,
    p_appointment_type,
    next_waiting_list
  )
  returning *;
end;
$$;

-- Keep the old RPC signature for single-clinic doctors. For multi-clinic
-- doctors, require the caller to use the clinic-aware overload above.
create or replace function public.add_appointment_with_waiting_list(
  p_appointment_date date,
  p_doctor_id uuid,
  p_user_id uuid,
  p_status integer,
  p_phone text,
  p_name text,
  p_description text,
  p_shift_morning_id integer,
  p_shift_evening_id integer,
  p_appointment_type integer
)
returns setof public.appointments
language plpgsql
security definer
set search_path = ''
as $$
declare
  clinic_count integer;
  only_clinic_id bigint;
begin
  select count(*)::integer, min(clinic.id)
    into clinic_count, only_clinic_id
    from public.clinic_data clinic
   where clinic.doctor_id = p_doctor_id;

  if clinic_count <> 1 then
    raise exception 'Clinic ID is required when a doctor has multiple clinics';
  end if;

  return query
  select * from public.add_appointment_with_waiting_list(
    p_appointment_date,
    p_doctor_id,
    only_clinic_id,
    p_user_id,
    p_status,
    p_phone,
    p_name,
    p_description,
    p_shift_morning_id,
    p_shift_evening_id,
    p_appointment_type
  );
end;
$$;

-- Legacy queue RPCs without a clinic argument must not combine multiple clinics.
create or replace function public.recalculate_appointment_waiting_list(
  p_doctor_id uuid,
  p_queue_date date
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  clinic_count integer;
  only_clinic_id bigint;
begin
  select count(*)::integer, min(clinic.id)
    into clinic_count, only_clinic_id
    from public.clinic_data clinic
   where clinic.doctor_id = p_doctor_id;
  if clinic_count <> 1 then return; end if;
  perform public.recalculate_appointment_waiting_list(
    p_doctor_id, p_queue_date, only_clinic_id
  );
end;
$$;

create or replace function public.advance_queue_and_get_next(
  p_doctor_id uuid,
  p_appointment_date date,
  p_clinic_id bigint
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  next_appointment_id bigint;
  next_user_id uuid;
  total_active integer;
begin
  if not exists (
    select 1 from public.clinic_data clinic
    where clinic.id = p_clinic_id and clinic.doctor_id = p_doctor_id
  ) then
    return pg_catalog.jsonb_build_object(
      'success', false, 'error', 'Clinic does not belong to doctor'
    );
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_clinic_id::text || ':' || p_appointment_date::text, 0)
  );

  with queue as (
    select appointment.id, appointment.user_id,
      (pg_catalog.row_number() over (
        order by coalesce(appointment.waiting_list, 999999),
          appointment.created_at, appointment.id
      ) - 1)::integer as new_position
    from public.appointments appointment
    where appointment.clinic_id = p_clinic_id
      and appointment.appointment_date = p_appointment_date
      and appointment.status in (1, 2)
  )
  update public.appointments appointment
  set waiting_list = queue.new_position
  from queue
  where appointment.id = queue.id;
  get diagnostics total_active = row_count;

  select appointment.id, appointment.user_id
    into next_appointment_id, next_user_id
  from public.appointments appointment
  where appointment.clinic_id = p_clinic_id
    and appointment.appointment_date = p_appointment_date
    and appointment.status in (1, 2)
    and appointment.waiting_list = 0
  limit 1;

  return pg_catalog.jsonb_build_object(
    'success', true,
    'clinic_id', p_clinic_id,
    'total_active', total_active,
    'next_appointment_id', next_appointment_id,
    'next_user_id', next_user_id
  );
end;
$$;

-- Old signature is safe only when the doctor has one clinic.
create or replace function public.advance_queue_and_get_next(
  p_doctor_id uuid,
  p_appointment_date date
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  clinic_count integer;
  only_clinic_id bigint;
begin
  select count(*)::integer, min(clinic.id)
    into clinic_count, only_clinic_id
    from public.clinic_data clinic
   where clinic.doctor_id = p_doctor_id;
  if clinic_count <> 1 then
    return pg_catalog.jsonb_build_object(
      'success', false,
      'error', 'Clinic ID is required when a doctor has multiple clinics'
    );
  end if;
  return public.advance_queue_and_get_next(
    p_doctor_id, p_appointment_date, only_clinic_id
  );
end;
$$;

create or replace function public.get_appointment_queue_by_id(
  p_appointment_id integer
)
returns jsonb
language sql
stable
set search_path = ''
as $$
with target as (
  select appointment.id, appointment.clinic_id, appointment.appointment_date
  from public.appointments appointment
  where appointment.id = p_appointment_id
), numbered as (
  select appointment.id as appointment_id,
    pg_catalog.row_number() over (
      partition by appointment.clinic_id, appointment.appointment_date
      order by appointment.created_at
    )::integer as queue
  from public.appointments appointment
  join target on target.clinic_id = appointment.clinic_id
    and target.appointment_date = appointment.appointment_date
)
select pg_catalog.to_jsonb(numbered)
from numbered
where numbered.appointment_id = p_appointment_id;
$$;

create or replace function public.postpone_appointment(
  p_appointment_id bigint,
  p_positions integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_clinic_id bigint;
  v_appointment_date date;
  v_appointment_status bigint;
  v_appointment_user_id uuid;
  v_total_active integer;
  v_current_position integer;
  v_new_position integer;
  v_updated_position integer;
  next_appointment_id bigint;
  next_user_id uuid;
begin
  if p_positions is null or p_positions < 1 or p_positions > 3 then
    return pg_catalog.jsonb_build_object(
      'success', false, 'error', 'Positions must be between 1 and 3'
    );
  end if;

  select appointment.clinic_id, appointment.appointment_date,
      appointment.status, appointment.user_id
    into v_clinic_id, v_appointment_date, v_appointment_status, v_appointment_user_id
    from public.appointments appointment
   where appointment.id = p_appointment_id;

  if not found then
    return pg_catalog.jsonb_build_object('success', false, 'error', 'Appointment not found');
  end if;
  if v_appointment_status not in (1, 2) then
    return pg_catalog.jsonb_build_object(
      'success', false, 'error', 'Only active appointments can be postponed'
    );
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_clinic_id::text || ':' || v_appointment_date::text, 0)
  );

  create temp table temp_active_queue on commit drop as
  select appointment.id, appointment.user_id,
    (pg_catalog.row_number() over (
      order by coalesce(appointment.waiting_list, 999999),
        appointment.created_at, appointment.id
    ) - 1)::integer as current_position
  from public.appointments appointment
  where appointment.clinic_id = v_clinic_id
    and appointment.appointment_date = v_appointment_date
    and appointment.status in (1, 2);

  select count(*)::integer into v_total_active from temp_active_queue;
  select temp_active_queue.current_position into v_current_position
  from temp_active_queue where id = p_appointment_id;
  if v_current_position is null then
    return pg_catalog.jsonb_build_object(
      'success', false, 'error', 'Appointment is not in the active queue'
    );
  end if;

  v_new_position := least(v_current_position + p_positions, v_total_active - 1);
  update public.appointments appointment
  set waiting_list = case
    when queue.id = p_appointment_id then v_new_position
    when queue.current_position > v_current_position
      and queue.current_position <= v_new_position then queue.current_position - 1
    else queue.current_position
  end
  from temp_active_queue queue
  where appointment.id = queue.id
    and appointment.clinic_id = v_clinic_id;

  select appointment.waiting_list into v_updated_position
  from public.appointments appointment
  where appointment.id = p_appointment_id
    and appointment.clinic_id = v_clinic_id;
  select appointment.id, appointment.user_id
    into next_appointment_id, next_user_id
  from public.appointments appointment
  where appointment.clinic_id = v_clinic_id
    and appointment.appointment_date = v_appointment_date
    and appointment.status in (1, 2)
    and appointment.waiting_list = 0
  limit 1;

  return pg_catalog.jsonb_build_object(
    'success', true,
    'appointment_id', p_appointment_id,
    'clinic_id', v_clinic_id,
    'user_id', v_appointment_user_id,
    'appointment_date', v_appointment_date,
    'old_position', v_current_position,
    'new_position', v_updated_position,
    'moved_by', v_new_position - v_current_position,
    'total_in_queue', v_total_active,
    'next_appointment_id', next_appointment_id,
    'next_user_id', next_user_id
  );
end;
$$;
