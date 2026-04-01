import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../services/supabase_service.dart';
import '../../../core/errors/failure.dart';

// Auth state
class AuthState {
  final bool isLoading;
  final User? user;
  final Failure? error;

  AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    Failure? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseService _supabase;

  AuthNotifier(this._supabase) : super(AuthState(user: _supabase.currentUser)) {
    // Auth durumu değiştiğinde dinle
    _supabase.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        state = state.copyWith(user: data.session?.user);
      }
    });
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _supabase.signIn(email, password);
      state = state.copyWith(isLoading: false, user: res.user);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthFailure(e.message),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthFailure('Giriş yapılamadı: $e'),
      );
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String fullName) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _supabase.signUp(email, password, fullName);
      state = state.copyWith(isLoading: false, user: res.user);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthFailure(e.message),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthFailure('Kayıt olunamadı: $e'),
      );
      return false;
    }
  }

  Future<bool> guestSignIn() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _supabase.signInAnonymously();
      state = state.copyWith(isLoading: false, user: res.user);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthFailure(e.message),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthFailure('Misafir girişi yapılamadı: $e'),
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _supabase.signOut();
    state = state.copyWith(isLoading: false, user: null);
  }
}

final supabaseServiceProvider = Provider((ref) => SupabaseService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(supabaseServiceProvider));
});
