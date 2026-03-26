-- ════════════════════════════════════════════════════════
-- EKYS - SEED DATA (Konu Ağacı)
-- 01 ve 02 dosyaları çalıştıktan SONRA bu dosyayı çalıştır
-- ════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────
-- ANA KONULAR
-- ────────────────────────────────────────────────────────
INSERT INTO topics (title, icon, order_index) VALUES
  ('Türkiye Yüzyılı Maarif Modeli', '📚', 1),
  ('Mevzuat', '⚖️', 2),
  ('Genel Kültür', '🌍', 3),
  ('Eğitim Bilimleri', '🎓', 4),
  ('İnkılap Tarihi ve Atatürkçülük', '🏛️', 5);

-- ────────────────────────────────────────────────────────
-- ALT KONULAR
-- (topic_id'ler INSERT edilen ana konulardan dinamik çekiliyor)
-- ────────────────────────────────────────────────────────

-- TYMM Alt Konuları
INSERT INTO subtopics (topic_id, title, slug, order_index)
SELECT t.id, s.title, s.slug, s.order_index
FROM topics t
CROSS JOIN (VALUES
  ('TYMM — Vizyon, Felsefe ve Bütünsel Eğitim Yaklaşımı', 'tymm_vizyon_felsefe', 1),
  ('TYMM — Erdem-Değer-Eylem Çerçevesi (10 Kök Değer)', 'tymm_ede_kok_deger', 2),
  ('TYMM — Beceriler Çerçevesi ve Öğrenme Alanları', 'tymm_beceriler_cercevesi', 3),
  ('TYMM — Ölçme-Değerlendirme ve Öğretim Süreci', 'tymm_olcme_ogretim', 4)
) AS s(title, slug, order_index)
WHERE t.title = 'Türkiye Yüzyılı Maarif Modeli';

-- Mevzuat Alt Konuları
INSERT INTO subtopics (topic_id, title, slug, order_index)
SELECT t.id, s.title, s.slug, s.order_index
FROM topics t
CROSS JOIN (VALUES
  ('1739 Sayılı Millî Eğitim Temel Kanunu', 'kanun_1739_metk', 1),
  ('657 Sayılı Devlet Memurları Kanunu', 'kanun_657_dmk', 2),
  ('7528 Sayılı Öğretmenlik Meslek Kanunu', 'kanun_7528_omk', 3),
  ('1 Sayılı CB Kararnamesi — MEB Teşkilat', 'kanun_1_cb_kararname', 4),
  ('222 Sayılı İlköğretim Kanunu + Anayasa', 'kanun_222_anayasa', 5),
  ('4483 Memur Yargılanması + 3071 Dilekçe', 'kanun_4483_3071', 6),
  ('4688 Sendikalar + 5018 Kamu Mali', 'kanun_4688_5018', 7),
  ('MEB Yönetici Seçme ve Okul Yönetmelikleri', 'meb_yonetmelikler', 8)
) AS s(title, slug, order_index)
WHERE t.title = 'Mevzuat';

-- Genel Kültür Alt Konuları
INSERT INTO subtopics (topic_id, title, slug, order_index)
SELECT t.id, s.title, s.slug, s.order_index
FROM topics t
CROSS JOIN (VALUES
  ('Türk-İslam Tarihi ve Osmanlı Eğitim Mirası', 'gk_turk_islam_osmanli', 1),
  ('Türkiye Coğrafyası — Ekonomi, Nüfus, Afetler', 'gk_turkiye_cografyasi', 2),
  ('Vatandaşlık Bilgisi ve Devlet Organları', 'gk_vatandaslik_devlet', 3),
  ('Güncel Olaylar ve MEB Politikaları', 'gk_guncel_meb', 4)
) AS s(title, slug, order_index)
WHERE t.title = 'Genel Kültür';

-- Eğitim Bilimleri Alt Konuları
INSERT INTO subtopics (topic_id, title, slug, order_index)
SELECT t.id, s.title, s.slug, s.order_index
FROM topics t
CROSS JOIN (VALUES
  ('Eğitim Yönetimi Kuramları — Klasikten Moderne', 'eb_yonetim_kuramlari', 1),
  ('Liderlik Stilleri ve Örgütsel Davranış', 'eb_liderlik_orgutsel', 2),
  ('Okul Güvenliği, Kriz Yönetimi ve Etik', 'eb_guvenlik_etik', 3),
  ('Pedagojik Uygulamalar — Psikoloji ve Ölçme', 'eb_pedagoji_olcme', 4)
) AS s(title, slug, order_index)
WHERE t.title = 'Eğitim Bilimleri';

-- İnkılap Tarihi Alt Konuları
INSERT INTO subtopics (topic_id, title, slug, order_index)
SELECT t.id, s.title, s.slug, s.order_index
FROM topics t
CROSS JOIN (VALUES
  ('Milli Mücadele Dönemi ve Kurtuluş Savaşı', 'it_milli_mucadele', 1),
  ('Atatürk İlkeleri ve Eğitime Yansımaları', 'it_ataturk_ilkeleri', 2),
  ('Eğitim İnkılapları — Tevhid-i Tedrisattan Üniversite Reformuna', 'it_egitim_inkılaplari', 3),
  ('Türk Dış Politikası ve Cumhuriyet Dönemi', 'it_dis_politika', 4)
) AS s(title, slug, order_index)
WHERE t.title = 'İnkılap Tarihi ve Atatürkçülük';
