# EKYS Mobil Uygulama — Yapay Zeka Ajan Planı

> **Hedef:** EKYS 2026 sınavına hazırlanan okul yöneticisi adayları için Flutter + Supabase tabanlı, AI destekli kapsamlı mobil öğrenme platformu geliştir.
> **Mimari:** Clean Architecture · Riverpod · go_router · Offline-first
> **Stil:** Modüler, insan müdahalesini minimize eden, production-ready kod

---

## 1. PROJE YAPISI

```
ekys_app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_sizes.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart          # Material 3
│   │   ├── router/
│   │   │   └── app_router.dart         # go_router tüm rotalar
│   │   ├── errors/
│   │   │   ├── failure.dart
│   │   │   └── exceptions.dart
│   │   └── utils/
│   │       ├── extensions.dart
│   │       └── helpers.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── supabase_auth_repository.dart
│   │   │   ├── domain/
│   │   │   │   ├── auth_repository.dart   # abstract
│   │   │   │   └── user_entity.dart
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart
│   │   │       ├── register_screen.dart
│   │   │       └── auth_provider.dart     # Riverpod
│   │   ├── topics/
│   │   │   ├── data/
│   │   │   │   └── topics_repository.dart
│   │   │   ├── domain/
│   │   │   │   ├── topic_entity.dart
│   │   │   │   └── subtopic_entity.dart
│   │   │   └── presentation/
│   │   │       ├── topics_list_screen.dart
│   │   │       ├── subtopics_screen.dart
│   │   │       └── topics_provider.dart
│   │   ├── study/
│   │   │   ├── data/
│   │   │   │   └── content_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── content_item_entity.dart
│   │   │   └── presentation/
│   │   │       ├── summary_screen.dart    # flutter_markdown
│   │   │       ├── flashcard_screen.dart  # flip_card + PageView
│   │   │       ├── audio_screen.dart      # just_audio
│   │   │       └── study_provider.dart
│   │   ├── quiz/
│   │   │   ├── data/
│   │   │   │   └── questions_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── question_entity.dart
│   │   │   └── presentation/
│   │   │       ├── quiz_screen.dart
│   │   │       ├── quiz_result_screen.dart
│   │   │       └── quiz_provider.dart
│   │   ├── exam/
│   │   │   └── presentation/
│   │   │       ├── exam_screen.dart       # zamanlayıcılı
│   │   │       ├── exam_result_screen.dart
│   │   │       └── exam_provider.dart
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       ├── dashboard_screen.dart
│   │   │       └── dashboard_provider.dart
│   │   └── stats/
│   │       └── presentation/
│   │           ├── stats_screen.dart      # fl_chart
│   │           └── stats_provider.dart
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── ekys_button.dart
│   │   │   ├── ekys_card.dart
│   │   │   ├── loading_skeleton.dart      # shimmer
│   │   │   └── progress_bar.dart
│   │   ├── models/
│   │   │   ├── question_model.dart        # Freezed + JSON
│   │   │   ├── topic_model.dart
│   │   │   ├── content_item_model.dart
│   │   │   └── exam_result_model.dart
│   │   └── providers/
│   │       └── supabase_provider.dart
│   └── services/
│       ├── supabase_service.dart
│       ├── audio_service.dart
│       └── analytics_service.dart
├── pubspec.yaml
└── .env                                   # Supabase credentials
```

---

## 2. EKRAN HARİTASI (Navigation)

```
Splash → Onboarding → Auth (Login / Register / OTP)
                           ↓
                     Ana Sayfa (Bottom Nav: 4 tab)
                     ├── [1] Dashboard
                     │     ├── Günlük hedef & streak widget
                     │     ├── Son çalışılan konular
                     │     └── Zayıf konu önerileri
                     ├── [2] Çalış
                     │     ├── Konu Listesi
                     │     │     └── Alt Konu Listesi
                     │     │           ├── Özet Okuma (Markdown)
                     │     │           ├── Sesli Özet (Audio Player)
                     │     │           └── Bilgi Kartları (Swipe)
                     │     └── Arama
                     ├── [3] Test & Deneme
                     │     ├── Konu Testi → Soru → Sonuç
                     │     └── Deneme Sınavı (zamanlı) → Analiz
                     └── [4] Profil & İstatistikler
                           ├── Performans Grafikleri
                           ├── Çalışma Geçmişi
                           └── Ayarlar
```

---

## 3. SUPABASE VERİTABANI ŞEMASI

Aşağıdaki SQL'i Supabase SQL Editor'da sırasıyla çalıştır:

```sql
-- ════════════════════════════════════════════════════════
-- KONU AĞACI
-- ════════════════════════════════════════════════════════
CREATE TABLE topics (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id    UUID REFERENCES topics(id),
  title        TEXT NOT NULL,
  description  TEXT,
  icon         TEXT,
  order_index  INT DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE subtopics (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id     UUID REFERENCES topics(id) ON DELETE CASCADE,
  title        TEXT NOT NULL,
  slug         TEXT UNIQUE NOT NULL,
  order_index  INT DEFAULT 0,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ════════════════════════════════════════════════════════
-- İÇERİK ÖĞELERİ
-- ════════════════════════════════════════════════════════
CREATE TYPE content_type AS ENUM ('summary', 'flashcard', 'audio_note');

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

-- ════════════════════════════════════════════════════════
-- SORULAR
-- ════════════════════════════════════════════════════════
CREATE TYPE question_type AS ENUM ('multiple_choice', 'true_false');

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

-- ════════════════════════════════════════════════════════
-- SINAVLAR
-- ════════════════════════════════════════════════════════
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

-- ════════════════════════════════════════════════════════
-- KULLANICI VERİSİ
-- ════════════════════════════════════════════════════════
CREATE TABLE user_progress (
  user_id         UUID REFERENCES auth.users(id),
  content_item_id UUID REFERENCES content_items(id),
  completed_at    TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, content_item_id)
);

CREATE TABLE user_exam_results (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES auth.users(id),
  exam_id     UUID REFERENCES exams(id),
  answers     JSONB NOT NULL,
  score       NUMERIC(5,2),
  correct_ct  INT,
  wrong_ct    INT,
  empty_ct    INT,
  duration_s  INT,
  taken_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_quiz_results (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID REFERENCES auth.users(id),
  subtopic_id  UUID REFERENCES subtopics(id),
  answers      JSONB NOT NULL,
  score        NUMERIC(5,2),
  taken_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_streaks (
  user_id          UUID PRIMARY KEY REFERENCES auth.users(id),
  current_streak   INT DEFAULT 0,
  longest_streak   INT DEFAULT 0,
  last_study_date  DATE
);

-- ════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY
-- ════════════════════════════════════════════════════════
ALTER TABLE topics         ENABLE ROW LEVEL SECURITY;
ALTER TABLE subtopics      ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_items  ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams          ENABLE ROW LEVEL SECURITY;
ALTER TABLE exam_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress  ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_exam_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_streaks   ENABLE ROW LEVEL SECURITY;

-- Herkese açık okuma (içerik tabloları)
CREATE POLICY "Public read" ON topics         FOR SELECT USING (true);
CREATE POLICY "Public read" ON subtopics      FOR SELECT USING (true);
CREATE POLICY "Public read" ON content_items  FOR SELECT USING (true);
CREATE POLICY "Public read" ON questions      FOR SELECT USING (true);
CREATE POLICY "Public read" ON exams          FOR SELECT USING (true);
CREATE POLICY "Public read" ON exam_questions FOR SELECT USING (true);

-- Kullanıcı sadece kendi verisini görür
CREATE POLICY "Own data" ON user_progress     FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own data" ON user_exam_results FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own data" ON user_quiz_results FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own data" ON user_streaks      FOR ALL USING (auth.uid() = user_id);
```

### Supabase Storage

```
Bucket adı  : audio
Erişim tipi : Public
Klasör yapısı: audio/[subtopic_slug].mp3
```

---

## 4. pubspec.yaml

```yaml
name: ekys_app
description: EKYS 2026 Hazırlık Uygulaması
publish_to: none
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"
  flutter: ">=3.22.0"

dependencies:
  flutter:
    sdk: flutter

  # Backend
  supabase_flutter: ^2.5.0

  # State & Routing
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.0.0

  # UI
  flutter_markdown: ^0.7.3
  flip_card: ^0.7.0
  just_audio: ^0.9.39
  audio_session: ^0.1.21
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  percent_indicator: ^4.2.3
  fl_chart: ^0.68.0

  # Local Cache
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.3

  # Utils
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  dartz: ^0.10.1
  connectivity_plus: ^6.0.3
  flutter_dotenv: ^5.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.10
  riverpod_generator: ^2.4.0
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  isar_generator: ^3.1.0+1
  flutter_lints: ^4.0.0
```

---

## 5. TEMEL KOD YAPILARI

### 5.1 main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: EkysApp()));
}

class EkysApp extends ConsumerWidget {
  const EkysApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'EKYS 2026',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
```

### 5.2 Supabase Servisi

```dart
// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Konuları çek (subtopics dahil)
  static Future<List<Map<String, dynamic>>> getTopics() async {
    return await client
        .from('topics')
        .select('*, subtopics(*)')
        .order('order_index');
  }

  // İçerik öğelerini çek
  static Future<List<Map<String, dynamic>>> getContentItems(
    String subtopicId,
    String type,
  ) async {
    return await client
        .from('content_items')
        .select()
        .eq('subtopic_id', subtopicId)
        .eq('type', type)
        .order('order_index');
  }

  // Test sorularını çek (karışık)
  static Future<List<Map<String, dynamic>>> getQuestions(
    String subtopicId, {
    int limit = 20,
  }) async {
    return await client
        .from('questions')
        .select()
        .eq('subtopic_id', subtopicId)
        .limit(limit);
  }

  // Deneme sınavı sorularını çek
  static Future<List<Map<String, dynamic>>> getExamQuestions(
    String examId,
  ) async {
    return await client
        .from('exam_questions')
        .select('questions(*)')
        .eq('exam_id', examId)
        .order('order_index');
  }

  // Quiz sonucu kaydet
  static Future<void> saveQuizResult({
    required String subtopicId,
    required Map<String, int?> answers,
    required double score,
  }) async {
    await client.from('user_quiz_results').insert({
      'user_id': client.auth.currentUser!.id,
      'subtopic_id': subtopicId,
      'answers': answers,
      'score': score,
    });
  }

  // Deneme sonucu kaydet
  static Future<void> saveExamResult({
    required String examId,
    required Map<String, int?> answers,
    required double score,
    required int correct,
    required int wrong,
    required int empty,
    required int durationSeconds,
  }) async {
    await client.from('user_exam_results').insert({
      'user_id': client.auth.currentUser!.id,
      'exam_id': examId,
      'answers': answers,
      'score': score,
      'correct_ct': correct,
      'wrong_ct': wrong,
      'empty_ct': empty,
      'duration_s': durationSeconds,
    });
  }

  // İçerik tamamlandı işaretle
  static Future<void> markContentComplete(String contentItemId) async {
    await client.from('user_progress').upsert({
      'user_id': client.auth.currentUser!.id,
      'content_item_id': contentItemId,
    });
  }

  // Kullanıcı istatistiklerini çek
  static Future<Map<String, dynamic>?> getUserStats() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return null;

    final streak = await client
        .from('user_streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return streak;
  }
}
```

### 5.3 Temel Model (Freezed)

```dart
// lib/shared/models/question_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    required String subtopicId,
    required String questionText,
    required List<OptionModel> options,
    required int correctIndex,
    String? explanation,
    @Default(1) int difficulty,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class OptionModel with _$OptionModel {
  const factory OptionModel({
    required String label,
    required String text,
  }) = _OptionModel;

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);
}
```

### 5.4 Quiz Provider (Riverpod)

```dart
// lib/features/quiz/presentation/quiz_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'quiz_provider.g.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState.loading() = _Loading;
  const factory QuizState.active({
    required List<QuestionModel> questions,
    required int currentIndex,
    required Map<String, int?> answers,
  }) = QuizStateActive;
  const factory QuizState.finished({
    required List<QuestionModel> questions,
    required Map<String, int?> answers,
    required double score,
  }) = _Finished;
  const factory QuizState.error(String message) = _Error;
}

@riverpod
class QuizNotifier extends _$QuizNotifier {
  late List<QuestionModel> _questions;
  final Map<String, int?> _answers = {};
  int _current = 0;

  @override
  QuizState build(String subtopicId) {
    _loadQuestions(subtopicId);
    return const QuizState.loading();
  }

  Future<void> _loadQuestions(String subtopicId) async {
    try {
      final raw = await SupabaseService.getQuestions(subtopicId);
      _questions = raw.map(QuestionModel.fromJson).toList();
      for (final q in _questions) {
        _answers[q.id] = null;
      }
      state = QuizState.active(
        questions: _questions,
        currentIndex: 0,
        answers: Map.from(_answers),
      );
    } catch (e) {
      state = QuizState.error(e.toString());
    }
  }

  void answer(String questionId, int index) {
    _answers[questionId] = index;
    state = (state as QuizStateActive).copyWith(answers: Map.from(_answers));
  }

  void next() {
    if (_current < _questions.length - 1) {
      _current++;
      state = (state as QuizStateActive).copyWith(currentIndex: _current);
    } else {
      finish();
    }
  }

  void previous() {
    if (_current > 0) {
      _current--;
      state = (state as QuizStateActive).copyWith(currentIndex: _current);
    }
  }

  void finish() {
    int correct = 0;
    for (final q in _questions) {
      if (_answers[q.id] == q.correctIndex) correct++;
    }
    final score = (_questions.isEmpty) ? 0.0 : (correct / _questions.length) * 100;
    state = QuizState.finished(
      questions: _questions,
      answers: Map.from(_answers),
      score: score,
    );
    SupabaseService.saveQuizResult(
      subtopicId: _questions.first.subtopicId,
      answers: _answers,
      score: score,
    );
  }
}
```

---

## 6. İÇERİK JSON FORMATI (Supabase için standart)

Her alt konu için üretilen JSON bu formata uymalıdır:

```json
{
  "subtopic_slug": "tymm_vizyon_felsefe",
  "subtopic_title": "TYMM — Vizyon, Felsefe ve Bütünsel Eğitim Yaklaşımı",
  "summary": {
    "title": "TYMM Vizyon ve Felsefe — Özet",
    "body_md": "## Temel Kavramlar\n\n**Bütüncül Eğitim**: ..."
  },
  "audio_url": "https://[proje].supabase.co/storage/v1/object/public/audio/tymm_vizyon_felsefe.mp3",
  "flashcards": [
    {
      "front_text": "TYMM'nin nihai öğrenci profili nedir?",
      "body_md": "Yetkin ve Erdemli İnsan",
      "difficulty": 1,
      "order_index": 0
    }
  ],
  "questions": [
    {
      "question_text": "TYMM'nin yetiştirmeyi hedeflediği profil hangisidir?",
      "options": [
        {"label": "A", "text": "Rekabetçi insan"},
        {"label": "B", "text": "Akademik insan"},
        {"label": "C", "text": "Yetkin ve erdemli insan"},
        {"label": "D", "text": "Küresel insan"}
      ],
      "correct_index": 2,
      "explanation": "TYMM'nin nihai hedefi yetkin ve erdemli bireyler yetiştirmektir.",
      "difficulty": 1
    }
  ]
}
```

---

## 7. PYTHON İMPORTER SCRİPT

```python
# content_pipeline/import_content.py
# Kullanım: python import_content.py data/tymm_vizyon.json
import json
import os
import sys
import glob
from supabase import create_client

SUPABASE_URL = os.environ['SUPABASE_URL']
SUPABASE_KEY = os.environ['SUPABASE_SERVICE_KEY']  # service_role key!
sb = create_client(SUPABASE_URL, SUPABASE_KEY)


def get_or_create_subtopic(slug: str, title: str) -> str:
    res = sb.table('subtopics').select('id').eq('slug', slug).execute()
    if res.data:
        return res.data[0]['id']
    raise ValueError(f"Subtopic bulunamadı: {slug}. Önce topics/subtopics seed verisini yükle.")


def import_file(path: str):
    with open(path, encoding='utf-8') as f:
        raw = f.read()

    # Tırnak hatalarını düzelt (Gemini bazen inner quote bırakır)
    import re
    def fix_inner_quotes(text):
        lines = text.split('\n')
        fixed = []
        for line in lines:
            m = re.match(r'^(\s*"[^"]+"\s*:\s*)"(.*)"(,?)$', line)
            if m:
                val = m.group(2).replace('\\"', '__ESC__').replace('"', "'").replace('__ESC__', '\\"')
                fixed.append(f'{m.group(1)}"{val}"{m.group(3)}')
            else:
                fixed.append(line)
        return '\n'.join(fixed)

    data = json.loads(fix_inner_quotes(raw))
    slug = data['subtopic_slug']
    subtopic_id = get_or_create_subtopic(slug, data['subtopic_title'])

    # Özet
    summary = data.get('summary', {})
    sb.table('content_items').upsert({
        'subtopic_id': subtopic_id,
        'type': 'summary',
        'title': summary.get('title', data['subtopic_title']),
        'body_md': summary.get('body_md', ''),
        'audio_url': data.get('audio_url'),
        'order_index': 0,
    }).execute()
    print(f"  ✓ Özet yüklendi")

    # Flashcard'lar
    for i, fc in enumerate(data.get('flashcards', [])):
        sb.table('content_items').upsert({
            'subtopic_id': subtopic_id,
            'type': 'flashcard',
            'title': fc['front_text'][:80],
            'front_text': fc['front_text'],
            'body_md': fc['body_md'],
            'difficulty': fc.get('difficulty', 1),
            'order_index': fc.get('order_index', i),
        }).execute()
    print(f"  ✓ {len(data.get('flashcards', []))} flashcard yüklendi")

    # Sorular
    for q in data.get('questions', []):
        sb.table('questions').upsert({
            'subtopic_id': subtopic_id,
            'question_text': q['question_text'],
            'options': q['options'],
            'correct_index': q['correct_index'],
            'explanation': q.get('explanation', ''),
            'difficulty': q.get('difficulty', 1),
        }).execute()
    print(f"  ✓ {len(data.get('questions', []))} soru yüklendi")

    print(f"✅ Tamamlandı: {slug}\n")


if __name__ == '__main__':
    if len(sys.argv) > 1:
        # Tek dosya
        import_file(sys.argv[1])
    else:
        # data/ klasöründeki tüm JSON'ları yükle
        files = sorted(glob.glob('data/*.json'))
        if not files:
            print("Hata: data/ klasöründe JSON dosyası bulunamadı.")
            sys.exit(1)
        print(f"{len(files)} dosya bulundu, yükleniyor...\n")
        for file in files:
            print(f"→ {file}")
            try:
                import_file(file)
            except Exception as e:
                print(f"  ✗ HATA: {e}\n")
```

### Kullanım

```bash
# Ortam değişkenlerini ayarla
export SUPABASE_URL="https://xxxxx.supabase.co"
export SUPABASE_SERVICE_KEY="eyJhbGc..."   # service_role key (Settings > API)

# Tek dosya yükle
python import_content.py data/tymm_vizyon.json

# Tüm data/ klasörünü yükle
python import_content.py
```

---

## 8. SEED DATA — Konu Ağacı

Supabase'e ilk çalıştırmada bu SQL ile konu ağacını oluştur:

```sql
-- Ana Konular
INSERT INTO topics (title, icon, order_index) VALUES
  ('Türkiye Yüzyılı Maarif Modeli', '📚', 1),
  ('Mevzuat', '⚖️', 2),
  ('Genel Kültür', '🌍', 3),
  ('Eğitim Bilimleri', '🎓', 4),
  ('İnkılap Tarihi ve Atatürkçülük', '🏛️', 5);

-- Alt Konular (topics tablosundan id'leri çek, buraya yaz)
-- Örnek (topic_id'leri gerçek UUID ile değiştir):

-- TYMM Alt Konuları
INSERT INTO subtopics (topic_id, title, slug, order_index) VALUES
  ('[TYMM_TOPIC_ID]', 'TYMM — Vizyon, Felsefe ve Bütünsel Eğitim Yaklaşımı', 'tymm_vizyon_felsefe', 1),
  ('[TYMM_TOPIC_ID]', 'TYMM — Erdem-Değer-Eylem Çerçevesi (10 Kök Değer)', 'tymm_ede_kok_deger', 2),
  ('[TYMM_TOPIC_ID]', 'TYMM — Beceriler Çerçevesi ve Öğrenme Alanları', 'tymm_beceriler_cercevesi', 3),
  ('[TYMM_TOPIC_ID]', 'TYMM — Ölçme-Değerlendirme ve Öğretim Süreci', 'tymm_olcme_ogretim', 4),

-- Mevzuat Alt Konuları
  ('[MEVZUAT_TOPIC_ID]', '1739 Sayılı Millî Eğitim Temel Kanunu', 'kanun_1739_metk', 1),
  ('[MEVZUAT_TOPIC_ID]', '657 Sayılı Devlet Memurları Kanunu', 'kanun_657_dmk', 2),
  ('[MEVZUAT_TOPIC_ID]', '7528 Sayılı Öğretmenlik Meslek Kanunu', 'kanun_7528_omk', 3),
  ('[MEVZUAT_TOPIC_ID]', '1 Sayılı CB Kararnamesi — MEB Teşkilat', 'kanun_1_cb_kararname', 4),
  ('[MEVZUAT_TOPIC_ID]', '222 Sayılı İlköğretim Kanunu + Anayasa', 'kanun_222_anayasa', 5),
  ('[MEVZUAT_TOPIC_ID]', '4483 Memur Yargılanması + 3071 Dilekçe', 'kanun_4483_3071', 6),
  ('[MEVZUAT_TOPIC_ID]', '4688 Sendikalar + 5018 Kamu Mali', 'kanun_4688_5018', 7),
  ('[MEVZUAT_TOPIC_ID]', 'MEB Yönetici Seçme ve Okul Yönetmelikleri', 'meb_yonetmelikler', 8),

-- Genel Kültür Alt Konuları
  ('[GK_TOPIC_ID]', 'Türk-İslam Tarihi ve Osmanlı Eğitim Mirası', 'gk_turk_islam_osmanli', 1),
  ('[GK_TOPIC_ID]', 'Türkiye Coğrafyası — Ekonomi, Nüfus, Afetler', 'gk_turkiye_cografyasi', 2),
  ('[GK_TOPIC_ID]', 'Vatandaşlık Bilgisi ve Devlet Organları', 'gk_vatandaslik_devlet', 3),
  ('[GK_TOPIC_ID]', 'Güncel Olaylar ve MEB Politikaları', 'gk_guncel_meb', 4),

-- Eğitim Bilimleri Alt Konuları
  ('[EGITIM_TOPIC_ID]', 'Eğitim Yönetimi Kuramları — Klasikten Moderne', 'eb_yonetim_kuramlari', 1),
  ('[EGITIM_TOPIC_ID]', 'Liderlik Stilleri ve Örgütsel Davranış', 'eb_liderlik_orgutsel', 2),
  ('[EGITIM_TOPIC_ID]', 'Okul Güvenliği, Kriz Yönetimi ve Etik', 'eb_guvenlik_etik', 3),
  ('[EGITIM_TOPIC_ID]', 'Pedagojik Uygulamalar — Psikoloji ve Ölçme', 'eb_pedagoji_olcme', 4),

-- İnkılap Tarihi Alt Konuları
  ('[INKILAP_TOPIC_ID]', 'Milli Mücadele Dönemi ve Kurtuluş Savaşı', 'it_milli_mucadele', 1),
  ('[INKILAP_TOPIC_ID]', 'Atatürk İlkeleri ve Eğitime Yansımaları', 'it_ataturk_ilkeleri', 2),
  ('[INKILAP_TOPIC_ID]', 'Eğitim İnkılapları — Tevhid-i Tedrisat'tan Üniversite Reformuna', 'it_egitim_inkılaplari', 3),
  ('[INKILAP_TOPIC_ID]', 'Türk Dış Politikası ve Cumhuriyet Dönemi', 'it_dis_politika', 4);
```

---

## 9. GELİŞTİRME FAZLARI

### Faz 1 — Temel MVP (4–5 Hafta)

**Hafta 1–2: Altyapı**
- [ ] Supabase projesi oluştur → SQL şemayı çalıştır → RLS politikaları uygula
- [ ] Storage'da `audio` bucket oluştur (public)
- [ ] Flutter projesi oluştur: `flutter create ekys_app`
- [ ] `pubspec.yaml` bağımlılıklarını ekle
- [ ] Klasör yapısını kur (yukarıdaki yapıya göre)
- [ ] `app_router.dart` — tüm rotaları tanımla
- [ ] `app_theme.dart` — Material 3 renk şeması
- [ ] Supabase initialize (`main.dart`)
- [ ] Auth ekranları: Login, Register, OTP doğrulama

**Hafta 3: Konu & Çalışma Modülü**
- [ ] `topics_repository.dart` — Supabase'den konu çekme
- [ ] `TopicsListScreen` — Ana konu listesi
- [ ] `SubtopicsScreen` — Alt konu listesi
- [ ] `SummaryScreen` — Markdown özet (flutter_markdown)
- [ ] `FlashcardScreen` — Swipe kartlar (flip_card + PageView)
- [ ] `AudioScreen` — Ses özeti çalar (just_audio)

**Hafta 4: Quiz & Deneme**
- [ ] `QuizScreen` — Çoktan seçmeli test arayüzü
- [ ] `QuizResultScreen` — Sonuç + açıklamalar
- [ ] `ExamScreen` — Zamanlayıcılı deneme sınavı (CountdownTimer)
- [ ] `ExamResultScreen` — Detaylı analiz

**Hafta 5: Dashboard & Test**
- [ ] `DashboardScreen` — Streak, günlük hedef, son çalışılanlar
- [ ] Seed data yükle (topics + subtopics SQL)
- [ ] İlk 3 alt konu için JSON içerik import et
- [ ] TestFlight / Play Store Internal Test dağıtımı

### Faz 2 — Zenginleştirme (3–4 Hafta)
- [ ] Offline mod — Isar DB ile içerik cache
- [ ] İstatistik ekranları (fl_chart ile grafikler)
- [ ] Spaced repetition algoritması (SM-2)
- [ ] Günlük bildirimler (flutter_local_notifications)
- [ ] Arama fonksiyonu
- [ ] Tüm 24 konu içeriğini tamamla

### Faz 3 — AI Özellikleri (3–4 Hafta)
- [ ] Supabase Edge Function → Claude API entegrasyonu
- [ ] In-app AI asistan
- [ ] Otomatik soru üretici (zayıf konular için)
- [ ] Kişisel çalışma planı

### Faz 4 — Yayın (2 Hafta)
- [ ] App Store & Google Play hazırlıkları
- [ ] Performans optimizasyonu
- [ ] Gizlilik politikası & kullanım şartları
- [ ] Freemium model aktivasyonu

---

## 10. KRİTİK KURALLAR (Ajana Özel)

### Kod Yazarken
- Her feature kendi klasöründe: `data/` · `domain/` · `presentation/` katmanları
- Supabase sorguları **sadece repository sınıflarında** — UI'dan direkt çağrı yok
- Her model **Freezed** ile oluşturulur, JSON serialization otomatik üretilir
- String sabitler `app_strings.dart`'ta — kod içinde sabit string yok
- Renkler `app_colors.dart`'tan çekilir
- Error handling: `Either<Failure, Success>` dönüş tipi
- Supabase RLS **her zaman aktif**, hiçbir zaman devre dışı bırakılmaz

### İçerik Pipeline
- Her JSON dosyası Supabase'e yüklenmeden önce **jsonlint.com** ile doğrulanır
- `audio_url` alanı ses dosyası yüklenince güncellenir, yoksa `null` kalır
- `subtopic_slug` küçük harf, Türkçe karakter yok, boşluk yerine alt çizgi
- Minimum: **20 soru + 8 flashcard + 1 özet** / alt konu

### Supabase Kurulum Sırası
1. Supabase projesi oluştur (app.supabase.com)
2. SQL Editor'da Bölüm 3'teki şemayı çalıştır
3. Storage'da `audio` bucket oluştur (public read)
4. Authentication'da Email + Google OAuth aktif et
5. `.env` dosyasına `SUPABASE_URL` ve `SUPABASE_ANON_KEY` ekle
6. Python importer için `SUPABASE_SERVICE_KEY` al (Settings → API)
7. Bölüm 8'deki seed SQL ile konu ağacını yükle
8. İlk JSON içerikleri importer ile yükle, uygulamada test et

---

## 11. .env Şablonu

```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> `.env` dosyasını **asla** git'e commit etme. `.gitignore`'a ekle.

---

*Bu döküman Antigravity AI ajanına verilmek üzere hazırlanmıştır.*
*Versiyon: 1.0 · EKYS 2026 · Flutter + Supabase*
