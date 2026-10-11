-- DG Servizi Tecnologici - sincronizzazione gestionale
-- Eseguire una sola volta nel SQL Editor del proprio progetto Supabase.
create table if not exists public.gestionale_sync (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.gestionale_sync enable row level security;

-- Ogni account può leggere e modificare esclusivamente il proprio record.
drop policy if exists "gestionale_sync_select_own" on public.gestionale_sync;
create policy "gestionale_sync_select_own"
  on public.gestionale_sync for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "gestionale_sync_insert_own" on public.gestionale_sync;
create policy "gestionale_sync_insert_own"
  on public.gestionale_sync for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "gestionale_sync_update_own" on public.gestionale_sync;
create policy "gestionale_sync_update_own"
  on public.gestionale_sync for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

grant select, insert, update on public.gestionale_sync to authenticated;
