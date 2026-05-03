import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/repositories/auth_repository.dart';

// ─── Repository provider ──────────────────────────────────────────────────────
// Any screen or provider can use: ref.read(authRepositoryProvider)
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

// ─── Auth State ───────────────────────────────────────────────────────────────

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? fullName;
  final bool isStaff;

  const AuthState({
    required this.status,
    this.fullName,
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

  /// Called on app start — if we already have a token, restore the session.
  Future<void> _checkExistingSession() async {
    final isLoggedIn = await _repo.isLoggedIn();
    if (isLoggedIn) {
      final fullName = await _storage.read(key: 'full_name');
      final isStaff = (await _storage.read(key: 'is_staff')) == 'true';
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: fullName,
        isStaff: isStaff,
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Call this after a successful login/register from the UI.
  void setAuthenticated({required String fullName, required bool isStaff}) {
    state = AuthState(
      status: AuthStatus.authenticated,
      fullName: fullName,
      isStaff: isStaff,
    );
  }

  /// Call this on logout.
  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

// ─── Global Auth Provider ─────────────────────────────────────────────────────
// Watch this in the splash screen to decide where to redirect.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
