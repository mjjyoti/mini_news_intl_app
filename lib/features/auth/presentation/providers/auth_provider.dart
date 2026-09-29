import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/providers.dart';
import '../../domain/entities/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    final repo = _ref.read(authRepositoryProvider);
    final isLoggedIn = await repo.isLoggedIn();
    if (isLoggedIn) {
      final email = await repo.getStoredEmail() ?? '';
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: User(email: email, isLoggedIn: true),
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final result = await _ref
        .read(authRepositoryProvider)
        .login(email, password);

    if (result.failure != null) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: result.failure!.message,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        errorMessage: null,
      );
    }
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
