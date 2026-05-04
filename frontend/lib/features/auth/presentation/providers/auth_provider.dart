import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/repositories/auth_repository.dart';

// ─── Repository provider ──────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

// ─── Auth State ───────────────────────────────────────────────────────────────

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? fullName;
  final String? email;
  final String? studentId;
  final bool isStaff;

  const AuthState({
    required this.status,
    this.fullName,
    this.email,
    this.studentId,
    this.isStaff = false,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

// ─── Auth Notifier ────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  static const _storage = FlutterSecureStorage();

  AuthNotifier(this._repo)
      : super(const AuthState(status: AuthStatus.loading)) {
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    final isLoggedIn = await _repo.isLoggedIn();
    if (isLoggedIn) {
      final fullName = await _storage.read(key: 'full_name');
      final email = await _storage.read(key: 'email');
      final studentId = await _storage.read(key: 'student_id');
      final isStaff = (await _storage.read(key: 'is_staff')) == 'true';
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: fullName,
        email: email,
        studentId: studentId,
        isStaff: isStaff,
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  void setAuthenticated({
    required String fullName,
    required String email,
    String? studentId,
    required bool isStaff,
  }) {
    state = AuthState(
      status: AuthStatus.authenticated,
      fullName: fullName,
      email: email,
      studentId: studentId,
      isStaff: isStaff,
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

// ─── Global Auth Provider ─────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
