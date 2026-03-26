import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../services/supabase_service.dart';
import '../../../../shared/models/question_model.dart';

class ExamState {
  final bool isLoading;
  final List<QuestionModel> questions; // Rastgele seçilmiş 80 soru
  final int currentIndex;
  final Map<int, int?> selectedAnswers; // Boş bırakılanlar null
  final int remainingSeconds; // Sınav süresi (150 dk = 9000 sn)
  final bool isFinished;
  final String? error;

  ExamState({
    this.isLoading = false,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.remainingSeconds = 9000,
    this.isFinished = false,
    this.error,
  });

  ExamState copyWith({
    bool? isLoading,
    List<QuestionModel>? questions,
    int? currentIndex,
    Map<int, int?>? selectedAnswers,
    int? remainingSeconds,
    bool? isFinished,
    String? error,
    bool clearError = false,
  }) {
    return ExamState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isFinished: isFinished ?? this.isFinished,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ExamNotifier extends StateNotifier<ExamState> {
  final SupabaseService _supabase;
  late final Stream<int> _timerStream;
  bool _isTimerRunning = false;

  ExamNotifier(this._supabase) : super(ExamState());

  Future<void> startExam() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // 1. Rastgele 80 soru çek (Supabase'de RPC veya rastgele sıralama mantığı gerekir)
      // Şimdilik test için limit 80 ile normal çekiyoruz
      final data = await _supabase.client
          .from('questions')
          .select()
          .limit(80); // İdealde order random olmalı

      final questions = data.map((q) => QuestionModel.fromJson(q)).toList();
      
      // State'i hazırla ve sayacı başlat
      state = state.copyWith(
        isLoading: false,
        questions: questions,
        remainingSeconds: 150 * 60, // 150 dakika
        isFinished: false,
        selectedAnswers: {},
        currentIndex: 0,
      );

      _startTimer();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sınav başlatılamadı: $e',
      );
    }
  }

  void _startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;

    _timerStream = Stream.periodic(const Duration(seconds: 1), (x) => 1);
    
    // Aslında dispose edilene kadar çalışır, memory leak olmaması için ref.onDispose'da durdurulmalı
    _timerStream.listen((_) {
      if (!mounted || state.isFinished) return;
      
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        finishExam(); // Süre bitti, sınavı zorla bitir
      }
    });
  }

  void selectAnswer(int optionIndex) {
    if (state.isFinished) return;

    final newAnswers = Map<int, int?>.from(state.selectedAnswers);
    newAnswers[state.currentIndex] = optionIndex;

    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void clearAnswer() {
    if (state.isFinished) return;

    final newAnswers = Map<int, int?>.from(state.selectedAnswers);
    newAnswers[state.currentIndex] = null; // Boş bırak

    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void changeQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  Future<void> finishExam() async {
    if (state.questions.isEmpty || state.isFinished) return;

    state = state.copyWith(isLoading: true, isFinished: true);
    _isTimerRunning = false;

    try {
      int correctCt = 0;
      int wrongCt = 0;
      int emptyCt = 0;
      final Map<String, dynamic> answersJson = {};

      for (int i = 0; i < state.questions.length; i++) {
        final q = state.questions[i];
        final selected = state.selectedAnswers[i];
        answersJson[q.id] = selected;

        if (selected == null) {
          emptyCt++;
        } else if (selected == q.correctIndex) {
          correctCt++;
        } else {
          wrongCt++;
        }
      }

      // EKYS Puanı = Doğru sayısı * 1.25 (80 soru = 100 tam puan üzerinden)
      final score = correctCt * 1.25;
      final examId = const Uuid().v4();

      // Supabase'e kaydet
      final userId = _supabase.currentUser?.id;
      if (userId != null) {
        await _supabase.client.from('user_exam_results').insert({
          'id': examId,
          'user_id': userId,
          'answers': answersJson,
          'score': score,
          'correct_ct': correctCt,
          'wrong_ct': wrongCt,
          'empty_ct': emptyCt,
          'duration_s': (150 * 60) - state.remainingSeconds,
        });
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('Sınav sonucu kaydedilemedi: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}

// Timer'ın düzgün temizlenmesi için autodispose kullanıyoruz
final examProvider = StateNotifierProvider.autoDispose<ExamNotifier, ExamState>((ref) {
  final notifier = ExamNotifier(SupabaseService());
  notifier.startExam();
  return notifier;
});
