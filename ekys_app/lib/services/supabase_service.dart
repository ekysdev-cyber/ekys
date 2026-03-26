import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase bağlantılarını yöneten Singleton sınıfı
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // ────────────────────────────────────────────────────────
  // AUTHENTICATION
  // ────────────────────────────────────────────────────────

  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> signUp(String email, String password, String name) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ────────────────────────────────────────────────────────
  // TOPICS (KONULAR)
  // ────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getTopicsWithSubtopics() async {
    return await client
        .from('topics')
        .select('*, subtopics(*)')
        .order('order_index');
  }

  // ────────────────────────────────────────────────────────
  // CONTENT (İÇERİK)
  // ────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getContentItems(String subtopicId) async {
    return await client
        .from('content_items')
        .select()
        .eq('subtopic_id', subtopicId)
        .order('order_index');
  }

  Future<void> markContentAsCompleted(String contentItemId) async {
    if (!isAuthenticated) return;
    await client.from('user_progress').upsert({
      'user_id': currentUser!.id,
      'content_item_id': contentItemId,
    });
  }

  // ────────────────────────────────────────────────────────
  // QUESTIONS (SORULAR)
  // ────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getQuestions(String subtopicId, {int limit = 10}) async {
    return await client
        .from('questions')
        .select()
        .eq('subtopic_id', subtopicId)
        .limit(limit);
  }

  Future<void> saveQuizResult(String subtopicId, Map<String, dynamic> answers, double score) async {
    if (!isAuthenticated) return;
    await client.from('user_quiz_results').insert({
      'user_id': currentUser!.id,
      'subtopic_id': subtopicId,
      'answers': answers,
      'score': score,
    });
  }
}
