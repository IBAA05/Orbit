import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Central HTTP client for the Orbit app.
///
/// - Targets http://10.0.2.2:8000 for Android Emulator.
/// - Automatically attaches the JWT Bearer token on every request.
class ApiClient {
  // ─── For USB Connection (Physical Device) ──────────────────────────────────
  // 1. Run: adb reverse tcp:8000 tcp:8000
  // 2. Use: http://localhost:8000
  static const String baseUrl = 'http://localhost:8000';

  static const _storage = FlutterSecureStorage();

  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // ─── LOGGING ─────────────────────────────────────────────────────────────
    // This will print all requests/errors in your Flutter console
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Attach the token to every request automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
