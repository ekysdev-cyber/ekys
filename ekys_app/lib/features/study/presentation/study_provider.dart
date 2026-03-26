import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/supabase_service.dart';
import '../../../../shared/models/content_item_model.dart';
import '../../../../services/streak_service.dart';

class StudyState {
  final bool isLoading;
  final List<ContentItemModel> contents;
  final String? error;

  StudyState({
    this.isLoading = false,
    this.contents = const [],
    this.error,
  });

  StudyState copyWith({
    bool? isLoading,
    List<ContentItemModel>? contents,
    String? error,
    bool clearError = false,
  }) {
    return StudyState(
      isLoading: isLoading ?? this.isLoading,
      contents: contents ?? this.contents,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class StudyNotifier extends StateNotifier<StudyState> {
  final SupabaseService _supabase;
  final StreakService _streakService;

  StudyNotifier(this._supabase, this._streakService) : super(StudyState());

  Future<void> loadContents(String subtopicId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _supabase.getContentItems(subtopicId);
      final items = data.map((json) => ContentItemModel.fromJson(json)).toList();
      state = state.copyWith(isLoading: false, contents: items);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'İçerikler yüklenirken hata oluştu: $e',
      );
    }
  }

  Future<void> markAsCompleted(String contentId) async {
    try {
      await _supabase.markContentAsCompleted(contentId);
      await _streakService.updateStreak(); // Çalışma yapıldığı için streak güncelle
    } catch (e) {
      print('İlerleme kaydedilemedi: $e');
    }
  }
}

final studyProvider = StateNotifierProvider.family<StudyNotifier, StudyState, String>((ref, subtopicId) {
  final notifier = StudyNotifier(
    SupabaseService(),
    ref.read(streakServiceProvider),
  );
  notifier.loadContents(subtopicId);
  return notifier;
});
