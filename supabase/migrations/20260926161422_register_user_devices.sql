create table if not exists public.user_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  device_id text not null,
  fcm_token text,
  platform text not null check (platform in ('android', 'ios', 'other')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  unique (user_id, device_id)
);

create index if not exists user_devices_active_user_idx
  on public.user_devices (user_id, last_seen_at desc)
  where is_active;

alter table public.user_devices enable row level security;
revoke all on table public.user_devices from anon, authenticated;
grant select, update on table public.user_devices to service_role;

create or replace function public.register_my_device(
  p_device_id text,
  p_fcm_token text,
  p_platform text
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
  v_active_count bigint;
begin
  if v_user_id is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  if nullif(pg_catalog.btrim(p_device_id), '') is null
     or (p_platform is distinct from 'android'
         and p_platform is distinct from 'ios'
         and p_platform is distinct from 'other') then
    raise exception 'Invalid device registration';
  end if;

  -- Serialize registrations for one account so two simultaneous devices
  -- cannot both pass the two-device limit check.
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::text, 0)
  );

  select pg_catalog.count(*)
  into v_active_count
  from public.user_devices
  where user_id = v_user_id
    and is_active
    and device_id <> p_device_id;

  if v_active_count >= 2 then
    return false;
  end if;

  insert into public.user_devices (user_id, device_id, fcm_token, platform)
  values (v_user_id, p_device_id, p_fcm_token, p_platform)
  on conflict (user_id, device_id) do update
    set fcm_token = excluded.fcm_token,
        platform = excluded.platform,
        is_active = true,
        last_seen_at = pg_catalog.now();

  return true;
end;
$$;

revoke all on function public.register_my_device(text, text, text)
  from public, anon;
grant execute on function public.register_my_device(text, text, text)
  to authenticated;

create or replace function public.unregister_my_device(p_device_id text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  update public.user_devices
  set is_active = false,
      last_seen_at = pg_catalog.now()
  where user_id = v_user_id
    and device_id = p_device_id;
end;
$$;

revoke all on function public.unregister_my_device(text)
  from public, anon;
grant execute on function public.unregister_my_device(text)
  to authenticated;
