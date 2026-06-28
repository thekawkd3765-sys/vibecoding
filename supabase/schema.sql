-- Run this in the Supabase SQL Editor after enabling the Email provider in Supabase Auth.

create table if not exists public.habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  name text not null check (char_length(name) between 1 and 40),
  completed jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_habits_updated_at on public.habits;
create trigger set_habits_updated_at
before update on public.habits
for each row
execute function public.set_updated_at();

alter table public.habits enable row level security;

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.habits to authenticated;

drop policy if exists "Habits are selectable by owner" on public.habits;
drop policy if exists "Habits are insertable by owner" on public.habits;
drop policy if exists "Habits are updatable by owner" on public.habits;
drop policy if exists "Habits are deletable by owner" on public.habits;

create policy "Habits are selectable by owner"
on public.habits
for select
to authenticated
using (auth.uid() = user_id);

create policy "Habits are insertable by owner"
on public.habits
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Habits are updatable by owner"
on public.habits
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "Habits are deletable by owner"
on public.habits
for delete
to authenticated
using (auth.uid() = user_id);