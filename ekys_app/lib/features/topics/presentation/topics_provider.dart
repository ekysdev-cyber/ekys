import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/supabase_service.dart';
import '../../../../shared/models/topic_model.dart';

class TopicsState {
  final bool isLoading;
  final List<TopicModel> topics;
  final String? error;

  TopicsState({
    this.isLoading = false,
    this.topics = const [],
    this.error,
  });

  TopicsState copyWith({
    bool? isLoading,
    List<TopicModel>? topics,
    String? error,
    bool clearError = false,
  }) {
    return TopicsState(
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class TopicsNotifier extends StateNotifier<TopicsState> {
  final SupabaseService _supabase;

  TopicsNotifier(this._supabase) : super(TopicsState()) {
    loadTopics();
  }

  Future<void> loadTopics() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _supabase.getTopicsWithSubtopics();
      final topics = data.map((json) => TopicModel.fromJson(json)).toList();
      state = state.copyWith(isLoading: false, topics: topics);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Konular yüklenirken hata oluştu: $e',
      );
    }
  }
}

final topicsProvider = StateNotifierProvider<TopicsNotifier, TopicsState>((ref) {
  return TopicsNotifier(SupabaseService());
});
