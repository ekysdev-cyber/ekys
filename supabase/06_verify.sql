-- ════════════════════════════════════════════════════════
-- EKYS - KONTROL SORGULARI
-- Tüm SQL dosyalarını çalıştırdıktan SONRA
-- bu dosyayla tabloların oluştuğunu kontrol et
-- ════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────
-- 1. TÜM TABLOLARI LİSTELE
-- ────────────────────────────────────────────────────────
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- ────────────────────────────────────────────────────────
-- 2. ENUM TİPLERİNİ KONTROL ET
-- ────────────────────────────────────────────────────────
SELECT t.typname AS enum_name, e.enumlabel AS enum_value
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE t.typname IN ('content_type', 'question_type')
ORDER BY t.typname, e.enumsortorder;

-- ────────────────────────────────────────────────────────
-- 3. ANA KONULARI KONTROL ET
-- ────────────────────────────────────────────────────────
SELECT id, title, icon, order_index
FROM topics
ORDER BY order_index;

-- ────────────────────────────────────────────────────────
-- 4. ALT KONULARI KONTROL ET (ana konu başlığıyla birlikte)
-- ────────────────────────────────────────────────────────
SELECT
  t.title AS ana_konu,
  st.title AS alt_konu,
  st.slug,
  st.order_index
FROM subtopics st
JOIN topics t ON t.id = st.topic_id
ORDER BY t.order_index, st.order_index;

-- ────────────────────────────────────────────────────────
-- 5. RLS POLİTİKALARINI KONTROL ET
-- ────────────────────────────────────────────────────────
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ────────────────────────────────────────────────────────
-- 6. RPC FONKSİYONLARINI KONTROL ET
-- ────────────────────────────────────────────────────────
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_type = 'FUNCTION'
ORDER BY routine_name;

-- ────────────────────────────────────────────────────────
-- 7. STORAGE BUCKET'I KONTROL ET
-- ────────────────────────────────────────────────────────
SELECT id, name, public
FROM storage.buckets
WHERE id = 'audio';

-- ────────────────────────────────────────────────────────
-- 8. INDEX'LERİ KONTROL ET
-- ────────────────────────────────────────────────────────
SELECT
  indexname,
  tablename
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;
