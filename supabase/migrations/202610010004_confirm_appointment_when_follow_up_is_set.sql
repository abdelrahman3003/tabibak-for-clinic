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
  -- A newly scheduled or rescheduled follow-up returns the appointment to
  -- confirmed. Completing that follow-up later changes status 2 -> 3.
  if tg_op = 'INSERT' then
    if new.follow_up_date is not null then
      new.status := 2;
    end if;
  elsif new.follow_up_date is not null
        and old.follow_up_date is distinct from new.follow_up_date then
    new.status := 2;
  end if;

  if tg_op = 'INSERT' then
    consultation_completed := new.status = 3 or new.follow_up_date is not null;
  else
    consultation_completed :=
      (new.status = 3 and old.status is distinct from 3)
      or (new.follow_up_date is not null and old.follow_up_date is null);
    follow_up_completed :=
      old.status = 2
      and new.status = 3
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
