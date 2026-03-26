-- ════════════════════════════════════════════════════════
-- EKYS - STORAGE BUCKET OLUŞTURMA
-- Bu dosyayı Supabase SQL Editor'da çalıştır
-- ════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────
-- Audio Bucket Oluştur (Sesli Özet dosyaları için)
-- ────────────────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public)
VALUES ('audio', 'audio', true)
ON CONFLICT (id) DO NOTHING;

-- ────────────────────────────────────────────────────────
-- Storage RLS Politikaları
-- ────────────────────────────────────────────────────────

-- Herkes audio dosyalarını okuyabilir (public bucket)
CREATE POLICY "audio_public_read"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'audio');

-- Sadece authenticated kullanıcılar yükleyebilir (admin için)
CREATE POLICY "audio_authenticated_insert"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'audio'
    AND auth.role() = 'authenticated'
  );

-- Sadece yükleyen kullanıcı güncelleyebilir
CREATE POLICY "audio_owner_update"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'audio'
    AND auth.uid() = owner
  );

-- Sadece yükleyen kullanıcı silebilir
CREATE POLICY "audio_owner_delete"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'audio'
    AND auth.uid() = owner
  );
