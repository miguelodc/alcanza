-- Tabla de movimientos de Alcanza: una planilla compartida, sin login.
-- Pegar en Supabase → SQL Editor → New query, y ejecutar con Run.

create table if not exists public.movimientos (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('cobro', 'gasto')),
  importe numeric(14, 2) not null check (importe > 0),
  fecha date not null,
  -- Solo los cobros tienen estado; los gastos lo dejan vacío.
  estado text check (estado in ('previsto', 'confirmado')),
  concepto text not null default '',
  creado bigint not null default (extract(epoch from now()) * 1000)::bigint,
  constraint estado_solo_en_cobros check ((tipo = 'cobro') = (estado is not null))
);

-- Acceso compartido: cualquiera que tenga el enlace de la app puede leer y modificar.
alter table public.movimientos enable row level security;
drop policy if exists "acceso compartido" on public.movimientos;
create policy "acceso compartido" on public.movimientos
  for all to anon using (true) with check (true);

-- Avisa a las pantallas abiertas cuando alguien cambia un movimiento.
do $$
begin
  alter publication supabase_realtime add table public.movimientos;
exception when duplicate_object then null;
end $$;
