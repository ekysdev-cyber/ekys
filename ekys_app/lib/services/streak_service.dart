import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/supabase_service.dart';

class StreakService {
  final SupabaseService _supabase;

  StreakService(this._supabase);

  /// Kullanıcı bir aktivite yaptığında çalışır (streak günceller)
  Future<Map<String, dynamic>> updateStreak() async {
    final client = _supabase.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Kullanıcı girişi yapılmamış');

    try {
      // 1. Mevcut veriyi al
      final record = await client
          .from('user_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      final todayStr = DateTime.now().toIso8601String().split('T')[0];
      
      // Kayıt yoksa oluştur
      if (record == null) {
        await client.from('user_streaks').insert({
          'user_id': userId,
          'current_streak': 1,
          'longest_streak': 1,
          'last_study_date': todayStr,
        });
        return {'current_streak': 1, 'longest_streak': 1, 'is_new_day': true};
      }

      int currentStreak = record['current_streak'] as int? ?? 0;
      int longestStreak = record['longest_streak'] as int? ?? 0;
      final String? lastStudyStr = record['last_study_date'] as String?;

      // Zaten bugün güncellediysek işlem yapma
      if (lastStudyStr == todayStr) {
        return {
          'current_streak': currentStreak,
          'longest_streak': longestStreak,
          'is_new_day': false,
        };
      }

      // Tarih farkını hesapla
      final today = DateTime.parse(todayStr);
      final lastStudy = lastStudyStr != null ? DateTime.parse(lastStudyStr) : null;

      if (lastStudy != null) {
        final diff = today.difference(lastStudy).inDays;
        if (diff == 1) {
          // Dün çalışmış, streak devam
          currentStreak++;
        } else if (diff > 1) {
          // Gün atlamış, streak kırıldı
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }

      // Rekor kırıldı mı?
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }

      // Veritabanını güncelle
      await client.from('user_streaks').update({
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_study_date': todayStr,
      }).eq('user_id', userId);

      return {
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'is_new_day': true,
      };
    } catch (e) {
      // Hata durumunda fail olmasın, session falan kopmuş olabilir
      print('Streak update error: $e');
      return {'current_streak': 0, 'longest_streak': 0, 'is_new_day': false};
    }
  }
}

final streakServiceProvider = Provider((ref) => StreakService(SupabaseService()));
