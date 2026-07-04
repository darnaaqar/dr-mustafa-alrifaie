-- Dental Clinic App Schema for Supabase (PostgreSQL)

create extension if not exists pgcrypto;

create table doctors (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  title_ar text,
  title_en text,
  about_ar text,
  about_en text,
  experience_years int default 0,
  image_url text,
  phone text,
  email text,
  whatsapp text,
  facebook text,
  instagram text,
  created_at timestamptz default now()
);

create table services (
  id uuid primary key default gen_random_uuid(),
  title_ar text not null,
  title_en text not null,
  short_ar text,
  short_en text,
  details_ar text,
  details_en text,
  icon text,
  image_url text,
  sort_order int default 1,
  active boolean default true
);

create table gallery (
  id uuid primary key default gen_random_uuid(),
  service_id uuid references services(id) on delete set null,
  category text check (category in ('clinic','before_after','technology','team')),
  title_ar text,
  title_en text,
  image_url text not null,
  created_at timestamptz default now()
);

create table appointments (
  id uuid primary key default gen_random_uuid(),
  patient_name text not null,
  phone text not null,
  email text,
  service_id uuid references services(id) on delete restrict,
  appointment_date date not null,
  appointment_time time not null,
  notes text,
  status text default 'pending'
    check (status in ('pending','approved','completed','cancelled')),
  created_at timestamptz default now()
);

create table settings (
  id boolean primary key default true,
  clinic_name_ar text,
  clinic_name_en text,
  address_ar text,
  address_en text,
  phone text,
  whatsapp text,
  email text,
  working_hours_ar text,
  working_hours_en text,
  google_map text,
  logo_url text,
  hero_image_url text,
  constraint single_settings check (id)
);

insert into settings
(id,clinic_name_ar,clinic_name_en)
values (true,'عيادة د. مصطفى الرفاعي','Dr. Mustafa Al-Rifai Dental Clinic')
on conflict (id) do nothing;

alter table doctors enable row level security;
alter table services enable row level security;
alter table gallery enable row level security;
alter table appointments enable row level security;
alter table settings enable row level security;

create policy "Public read doctors" on doctors for select using (true);
create policy "Public read services" on services for select using (true);
create policy "Public read gallery" on gallery for select using (true);
create policy "Public read settings" on settings for select using (true);

create policy "Anyone can create appointment"
on appointments for insert
with check (true);

create policy "Public read appointments disabled"
on appointments for select
using (false);
