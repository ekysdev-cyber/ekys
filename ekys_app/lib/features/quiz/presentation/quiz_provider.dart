import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/supabase_service.dart';
import '../../../../services/stats_service.dart';
import '../../../../shared/models/question_model.dart';

class QuizState {
  final bool isLoading;
  final List<QuestionModel> questions;
  final int currentIndex;
  final Map<int, int> selectedAnswers; // Soru index'i -> Seçilen şık index'i
  final bool isFinished;
  final String? error;

  QuizState({
    this.isLoading = false,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.isFinished = false,
    this.error,
  });

  QuizState copyWith({
    bool? isLoading,
    List<QuestionModel>? questions,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    bool? isFinished,
    String? error,
    bool clearError = false,
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isFinished: isFinished ?? this.isFinished,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final SupabaseService _supabase;
  final String subtopicId;

  QuizNotifier(this._supabase, this.subtopicId) : super(QuizState());

  Future<void> loadQuestions() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _supabase.getQuestions(subtopicId, limit: 10);
      final questions = data.map((q) => QuestionModel.fromJson(q)).toList();
      state = state.copyWith(isLoading: false, questions: questions);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sorular yüklenemedi: $e',
      );
    }
  }

  void selectAnswer(int optionIndex) {
    if (state.isFinished) return;

    final newAnswers = Map<int, int>.from(state.selectedAnswers);
    newAnswers[state.currentIndex] = optionIndex;

    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  Future<void> finishQuiz() async {
    if (state.questions.isEmpty) return;

    state = state.copyWith(isLoading: true, isFinished: true);
    try {
      // 1. Puan hesapla
      int correctCount = 0;
      final Map<String, dynamic> answersJson = {};

      for (int i = 0; i < state.questions.length; i++) {
        final q = state.questions[i];
        final selected = state.selectedAnswers[i];
        answersJson[q.id] = selected;

        if (selected == q.correctIndex) {
          correctCount++;
        }
      }

      final score = (correctCount / state.questions.length) * 100;

      // 2. Supabase'e kaydet
      await _supabase.saveQuizResult(subtopicId, answersJson, score);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('Sınav sonucu kaydedilemedi: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}

final quizProvider = StateNotifierProvider.family<QuizNotifier, QuizState, String>((ref, subtopicId) {
  final notifier = QuizNotifier(SupabaseService(), subtopicId);
  notifier.loadQuestions();
  return notifier;
});
