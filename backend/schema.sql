-- Digital Ombuds MVP Database Schema
-- Supabase Postgres tables


-- 1) Institutions table: which organization the ombuds belongs to
create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  created_at timestamp with time zone default now()
);

-- 2) Ombuds users: login accounts for ombuds, tied to an institution
create table if not exists public.ombuds_users (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id) on delete cascade,
  email text unique not null,
  password_hash text not null,
  created_at timestamp with time zone default now()
);

-- 3) Visitors: anonymous visitors tied to an institution
create table if not exists public.visitors (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid references public.institutions(id) on delete cascade,
  role text check (role in ('student', 'staff', 'faculty')) not null,
  alias text not null,
  recovery_key_hash text not null,
  created_at timestamp with time zone default now()
);

-- 4) Cases: each conversation instance
create table if not exists public.cases (
  id uuid primary key default gen_random_uuid(),
  visitor_id uuid references public.visitors(id) on delete cascade,
  status text check (status in ('new', 'active', 'resolved')) default 'new',
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- 5) Messages: individual messages in a case
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  case_id uuid references public.cases(id) on delete cascade,
  sender text check (sender in ('visitor', 'ombuds')) not null,
  body text not null,
  created_at timestamp with time zone default now()
);
-- RLS Policies (Dev mode)

/* Institutions: allow read to any role (dev-only) */
create policy "Allow read institutions to anyone (dev)"
on public.institutions
for select
using (true);
/* Dev policies for early development: DO NOT USE IN PRODUCTION */

/* Visitors: allow all access in dev */
create policy "Dev access visitors"
on public.visitors
for all
using (true)
with check (true);

/* Cases: allow all access in dev */
create policy "Dev access cases"
on public.cases
for all
using (true)
with check (true);

/* Messages: allow all access in dev */
create policy "Dev access messages"
on public.messages
for all
using (true)
with check (true);

/* Ombuds users: allow all access in dev */
create policy "Dev access ombuds_users"
on public.ombuds_users
for all
using (true)
with check (true);
