-- ════════════════════════════════════════════════════════
-- EKYS - TABLO OLUŞTURMA
-- Bu dosyayı Supabase SQL Editor'da ilk olarak çalıştır
-- ════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────
-- ENUM TİPLERİ
-- ────────────────────────────────────────────────────────
CREATE TYPE content_type AS ENUM ('summary', 'flashcard', 'audio_note');
CREATE TYPE question_type AS ENUM ('multiple_choice', 'true_false');

-- ────────────────────────────────────────────────────────
-- KONU AĞACI
-- ────────────────────────────────────────────────────────
CREATE TABLE topics (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id    UUID REFERENCES topics(id),
  title        TEXT NOT NULL,
  description  TEXT,
  icon         TEXT,
  order_index  INT DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_topics_parent ON topics(parent_id);
CREATE INDEX idx_topics_order ON topics(order_index);

CREATE TABLE subtopics (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id     UUID REFERENCES topics(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  slug         TEXT UNIQUE NOT NULL,
  order_index  INT DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_subtopics_topic ON subtopics(topic_id);
CREATE INDEX idx_subtopics_slug ON subtopics(slug);
CREATE INDEX idx_subtopics_order ON subtopics(order_index);

-- ────────────────────────────────────────────────────────
-- İÇERİK ÖĞELERİ
-- ────────────────────────────────────────────────────────
CREATE TABLE content_items (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subtopic_id  UUID REFERENCES subtopics(id) ON DELETE CASCADE,
  type         content_type NOT NULL,
  title        TEXT NOT NULL,
  body_md      TEXT,
  front_text   TEXT,
  audio_url    TEXT,
  duration_sec INT,
  difficulty   SMALLINT CHECK (difficulty BETWEEN 1 AND 3),
  order_index  INT DEFAULT 0,
  tags         TEXT[],
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_content_subtopic ON content_items(subtopic_id);
CREATE INDEX idx_content_type ON content_items(type);
CREATE INDEX idx_content_order ON content_items(order_index);

-- ────────────────────────────────────────────────────────
-- SORULAR
-- ────────────────────────────────────────────────────────
CREATE TABLE questions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subtopic_id    UUID REFERENCES subtopics(id),
  question_type  question_type DEFAULT 'multiple_choice',
  question_text  TEXT NOT NULL,
  options        JSONB NOT NULL,
  correct_index  SMALLINT NOT NULL,
  explanation    TEXT,
  difficulty     SMALLINT CHECK (difficulty BETWEEN 1 AND 3),
  source         TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_questions_subtopic ON questions(subtopic_id);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);

-- ────────────────────────────────────────────────────────
-- SINAVLAR
-- ────────────────────────────────────────────────────────
CREATE TABLE exams (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title         TEXT NOT NULL,
  description   TEXT,
  duration_min  INT NOT NULL DEFAULT 120,
  is_full_exam  BOOLEAN DEFAULT FALSE,
  topic_ids     UUID[],
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE exam_questions (
  exam_id      UUID REFERENCES exams(id) ON DELETE CASCADE,
  question_id  UUID REFERENCES questions(id) ON DELETE CASCADE,
  order_index  INT DEFAULT 0,
  PRIMARY KEY (exam_id, question_id)
);

CREATE INDEX idx_exam_questions_exam ON exam_questions(exam_id);

-- ────────────────────────────────────────────────────────
-- KULLANICI VERİSİ
-- ────────────────────────────────────────────────────────
CREATE TABLE user_progress (
  user_id         UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  content_item_id UUID REFERENCES content_items(id) ON DELETE CASCADE,
  completed_at    TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, content_item_id)
);

CREATE INDEX idx_progress_user ON user_progress(user_id);

CREATE TABLE user_exam_results (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  exam_id     UUID REFERENCES exams(id) ON DELETE CASCADE,
  answers     JSONB NOT NULL,
  score       NUMERIC(5,2),
  correct_ct  INT,
  wrong_ct    INT,
  empty_ct    INT,
  duration_s  INT,
  taken_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_exam_results_user ON user_exam_results(user_id);
CREATE INDEX idx_exam_results_exam ON user_exam_results(exam_id);

CREATE TABLE user_quiz_results (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  subtopic_id  UUID REFERENCES subtopics(id) ON DELETE CASCADE,
  answers      JSONB NOT NULL,
  score        NUMERIC(5,2),
  taken_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_quiz_results_user ON user_quiz_results(user_id);
CREATE INDEX idx_quiz_results_subtopic ON user_quiz_results(subtopic_id);

CREATE TABLE user_streaks (
  user_id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  current_streak   INT DEFAULT 0,
  longest_streak   INT DEFAULT 0,
  last_study_date  DATE
);
