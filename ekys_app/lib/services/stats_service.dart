import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';

class StatsService {
  final SupabaseService _supabase;

  StatsService(this._supabase);

  // 1. Dashboard Genel İstatistikleri
  Future<Map<String, dynamic>> getUserDashboardStats() async {
    final client = _supabase.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Kullanıcı girişi yapılmamış');

    // Verileri sırayla çekelim (Tip uyuşmazlığını önlemek için Future.wait yerine ayrı separate await)
    final streakData = await client.from('user_streaks').select().eq('user_id', userId).maybeSingle() ?? {};
    final progressData = await client.from('user_progress').select('content_item_id').eq('user_id', userId);
    final totalCount = await client.from('content_items').count(CountOption.exact);
    final quizData = await client.from('user_quiz_results').select('score').eq('user_id', userId);
    final examData = await client.from('user_exam_results').select('score').eq('user_id', userId);

    final completedCount = progressData.length;
    final progressPercent = totalCount > 0 ? (completedCount / totalCount) * 100 : 0.0;

    double quizAvg = 0;
    if (quizData.isNotEmpty) {
      final totalScore = quizData.fold<double>(0, (sum, item) => sum + (item['score'] as num).toDouble());
      quizAvg = totalScore / quizData.length;
    }

    double examAvg = 0;
    if (examData.isNotEmpty) {
      final totalScore = examData.fold<double>(0, (sum, item) => sum + (item['score'] as num).toDouble());
      examAvg = totalScore / examData.length;
    }

    return {
      'current_streak': streakData['current_streak'] ?? 0,
      'longest_streak': streakData['longest_streak'] ?? 0,
      'last_study_date': streakData['last_study_date'],
      'completed_items': completedCount,
      'total_items': totalCount,
      'progress_percent': progressPercent,
      'quiz_count': quizData.length,
      'quiz_avg_score': quizAvg,
      'exam_count': examData.length,
      'exam_avg_score': examAvg,
    };
  }

  // 2. Son Çalışılan Konular
  Future<List<Map<String, dynamic>>> getRecentStudies({int limit = 5}) async {
    final client = _supabase.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) return [];

    // Son tamamlanan içeriklerin subtopic_id'lerini bul
    final progressList = await client
        .from('user_progress')
        .select('completed_at, content_items(subtopic_id)')
        .eq('user_id', userId)
        .order('completed_at', ascending: false);

    if (progressList.isEmpty) return [];

    // Benzersiz subtopic'leri topla (sadece ilk defa karşılaştıklarımızı al)
    final List<Map<String, dynamic>> uniqueRecent = [];
    final Set<String> seenSubtopics = {};

    for (var p in progressList) {
      final subtopicId = p['content_items']['subtopic_id'] as String;
      if (!seenSubtopics.contains(subtopicId)) {
        seenSubtopics.add(subtopicId);
        uniqueRecent.add({
          'subtopic_id': subtopicId,
          'last_studied_at': p['completed_at'],
        });
        if (uniqueRecent.length >= limit) break;
      }
    }

    if (uniqueRecent.isEmpty) return [];

    // Bu subtopic'lerin detaylarını çek
    final subtopicIds = uniqueRecent.map((e) => e['subtopic_id']).toList();
    final subtopicsData = await client
        .from('subtopics')
        .select('id, title, slug, topics(title, icon)')
        .inFilter('id', subtopicIds);

    // Verileri birleştir
    for (var i = 0; i < uniqueRecent.length; i++) {
      final sub = subtopicsData.firstWhere((s) => s['id'] == uniqueRecent[i]['subtopic_id'], orElse: () => {});
      if (sub.isNotEmpty) {
        uniqueRecent[i]['subtopic_title'] = sub['title'];
        uniqueRecent[i]['slug'] = sub['slug'];
        uniqueRecent[i]['topic_title'] = sub['topics']['title'];
        uniqueRecent[i]['icon'] = sub['topics']['icon'];
      }
    }

    return uniqueRecent;
  }
}

final statsServiceProvider = Provider((ref) => StatsService(SupabaseService()));
