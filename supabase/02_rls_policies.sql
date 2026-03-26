-- ════════════════════════════════════════════════════════
-- EKYS - ROW LEVEL SECURITY (RLS) POLİTİKALARI
-- 01_create_tables.sql çalıştıktan SONRA bu dosyayı çalıştır
-- ════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────
-- RLS AKTİFLEŞTİRME
-- ────────────────────────────────────────────────────────
ALTER TABLE topics          ENABLE ROW LEVEL SECURITY;
ALTER TABLE subtopics       ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_items   ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams           ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_questions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress       ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_exam_results   ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quiz_results   ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_streaks        ENABLE ROW LEVEL SECURITY;

-- ────────────────────────────────────────────────────────
-- İÇERİK TABLOLARI — Herkese Açık Okuma
-- (Giriş yapmış veya yapmamış herkes okuyabilir)
-- ────────────────────────────────────────────────────────
CREATE POLICY "topics_public_read"
  ON topics FOR SELECT
  USING (true);

CREATE POLICY "subtopics_public_read"
  ON subtopics FOR SELECT
  USING (true);

CREATE POLICY "content_items_public_read"
  ON content_items FOR SELECT
  USING (true);

CREATE POLICY "questions_public_read"
  ON questions FOR SELECT
  USING (true);

CREATE POLICY "exams_public_read"
  ON exams FOR SELECT
  USING (true);

CREATE POLICY "exam_questions_public_read"
  ON exam_questions FOR SELECT
  USING (true);

-- ────────────────────────────────────────────────────────
-- KULLANICI TABLOLARI — Sadece Kendi Verisini Görsün
-- ────────────────────────────────────────────────────────

-- user_progress: kullanıcı kendi ilerlemesini okur/yazar
CREATE POLICY "user_progress_select_own"
  ON user_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "user_progress_insert_own"
  ON user_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_progress_update_own"
  ON user_progress FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_progress_delete_own"
  ON user_progress FOR DELETE
  USING (auth.uid() = user_id);

-- user_exam_results: kullanıcı kendi sınav sonuçlarını okur/yazar
CREATE POLICY "user_exam_results_select_own"
  ON user_exam_results FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "user_exam_results_insert_own"
  ON user_exam_results FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_exam_results_update_own"
  ON user_exam_results FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_exam_results_delete_own"
  ON user_exam_results FOR DELETE
  USING (auth.uid() = user_id);

-- user_quiz_results: kullanıcı kendi quiz sonuçlarını okur/yazar
CREATE POLICY "user_quiz_results_select_own"
  ON user_quiz_results FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "user_quiz_results_insert_own"
  ON user_quiz_results FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_quiz_results_update_own"
  ON user_quiz_results FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_quiz_results_delete_own"
  ON user_quiz_results FOR DELETE
  USING (auth.uid() = user_id);

-- user_streaks: kullanıcı kendi streak verisini okur/yazar
CREATE POLICY "user_streaks_select_own"
  ON user_streaks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "user_streaks_insert_own"
  ON user_streaks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_streaks_update_own"
  ON user_streaks FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_streaks_delete_own"
  ON user_streaks FOR DELETE
  USING (auth.uid() = user_id);
