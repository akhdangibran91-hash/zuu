-- ============================================================
-- ZUUMARKET — Skema Database Supabase
-- Jalankan seluruh file ini di Supabase Dashboard > SQL Editor
-- ============================================================

-- Tabel listing akun yang dijual
create table if not exists accounts (
  id bigint primary key,
  avatar text,
  username text,
  description text,
  price numeric,
  password text,
  sold boolean default false,
  "dateAdded" bigint,
  "sellerRating" numeric,
  "reviewCount" integer,
  trend text,
  sentiment text
);

-- Riwayat transaksi/pembelian
create table if not exists purchase_history (
  id bigint primary key,
  avatar text,
  username text,
  description text,
  price numeric,
  password text,
  sold boolean,
  "dateAdded" bigint,
  "sellerRating" numeric,
  "reviewCount" integer,
  trend text,
  sentiment text,
  date text,
  "escrowStatus" text default 'held'
);

-- Ulasan/review penjual
create table if not exists seller_reviews (
  id bigint primary key,
  "user" text,
  rating integer,
  comment text,
  date text,
  images jsonb default '[]'::jsonb
);

-- Akun pengguna (pembeli/penjual)
create table if not exists users (
  id bigint primary key,
  username text unique,
  password text,
  role text,
  "createdAt" bigint
);

-- Log aktivitas untuk dashboard admin
create table if not exists usage_log (
  id bigint generated always as identity primary key,
  username text,
  role text,
  action text,
  timestamp bigint
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Supabase mengaktifkan RLS secara default (menolak semua akses).
-- Baris di bawah ini membuka akses baca/tulis via anon key agar
-- aplikasi bisa langsung berjalan. Ini SETARA dengan localStorage
-- dari sisi keamanan (siapa pun yang tahu URL project bisa baca/
-- tulis data). Untuk produksi sungguhan, ganti dengan Supabase Auth
-- + policy yang membatasi akses per user (lihat catatan di bawah).
-- ============================================================

alter table accounts enable row level security;
alter table purchase_history enable row level security;
alter table seller_reviews enable row level security;
alter table users enable row level security;
alter table usage_log enable row level security;

create policy "public read accounts" on accounts for select using (true);
create policy "public write accounts" on accounts for all using (true) with check (true);

create policy "public read history" on purchase_history for select using (true);
create policy "public write history" on purchase_history for all using (true) with check (true);

create policy "public read reviews" on seller_reviews for select using (true);
create policy "public write reviews" on seller_reviews for all using (true) with check (true);

create policy "public read users" on users for select using (true);
create policy "public write users" on users for all using (true) with check (true);

create policy "public read usage_log" on usage_log for select using (true);
create policy "public write usage_log" on usage_log for all using (true) with check (true);

-- ============================================================
-- LANGKAH SELANJUTNYA UNTUK KEAMANAN PRODUKSI (opsional, tidak
-- wajib untuk membuat aplikasi ini berjalan):
-- 1. Ganti sistem login manual di kode dengan Supabase Auth
--    (supabaseClient.auth.signUp / signInWithPassword) agar
--    password di-hash otomatis dan tidak pernah tersimpan mentah.
-- 2. Ubah policy di atas agar "write" hanya boleh oleh pemilik
--    baris (auth.uid() = owner_id), bukan terbuka untuk semua.
-- ============================================================
