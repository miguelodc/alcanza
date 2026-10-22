-- Paso de planilla compartida a datos por usuario (login con mail y contraseña).
-- Ejecutar una vez en Supabase → SQL Editor → New query → Run, después de schema.sql.

-- Cada movimiento pasa a tener dueño: el usuario que lo carga.
alter table public.movimientos
  add column if not exists user_id uuid default auth.uid() references auth.users (id) on delete cascade;

-- Los movimientos de la planilla compartida no tienen dueño y nadie podría verlos:
-- se borran. Son los datos de ejemplo; cada cuenta los vuelve a cargar con un clic.
delete from public.movimientos where user_id is null;

alter table public.movimientos alter column user_id set not null;
create index if not exists movimientos_user_id_idx on public.movimientos (user_id);

-- Se cierra el acceso abierto: cada usuario con sesión iniciada ve y cambia solo lo suyo.
drop policy if exists "acceso compartido" on public.movimientos;
drop policy if exists "cada uno sus movimientos" on public.movimientos;
create policy "cada uno sus movimientos" on public.movimientos
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
