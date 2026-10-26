-- Tabla de progreso: una fila por usuario.
create table if not exists public.progreso (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Seguridad a nivel de fila: cada usuario solo ve y modifica su propia fila.
alter table public.progreso enable row level security;

create policy "leer lo propio" on public.progreso
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "insertar lo propio" on public.progreso
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "actualizar lo propio" on public.progreso
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
