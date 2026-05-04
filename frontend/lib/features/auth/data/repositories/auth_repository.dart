import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/api_client.dart';
import '../models/auth_model.dart';

/// Handles all authentication API calls and persists the session token.
class AuthRepository {
  final _dio = ApiClient.instance;
  static const _storage = FlutterSecureStorage();

  // ─── Login ──────────────────────────────────────────────────────────────────

  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = AuthTokenModel.fromJson(response.data);
      await _saveSession(token);
      return token;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  // ─── Register ────────────────────────────────────────────────────────────────

  Future<AuthTokenModel> register({
    required String fullName,
    required String email,
    required String studentId,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'full_name': fullName,
          'email': email,
          'student_id': studentId,
          'password': password,
        },
      );
      final token = AuthTokenModel.fromJson(response.data);
      await _saveSession(token);
      return token;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  // ─── Biometric Login ─────────────────────────────────────────────────────────

  Future<AuthTokenModel> biometricLogin({
    required String email,
    required String biometricToken,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/biometric-login',
        data: {
          'email': email,
          'biometric_token': biometricToken,
        },
      );
      final token = AuthTokenModel.fromJson(response.data);
      await _saveSession(token);
      return token;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  // ─── Logout ──────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // Even if the server call fails, we still clear local session
    } finally {
      await _storage.deleteAll();
    }
  }

  // ─── Session helpers ──────────────────────────────────────────────────────────

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveSession(AuthTokenModel token) async {
    await _storage.write(key: 'access_token', value: token.accessToken);
    await _storage.write(key: 'user_id', value: token.userId.toString());
    await _storage.write(key: 'full_name', value: token.fullName);
    await _storage.write(key: 'email', value: token.email);
    if (token.studentId != null) {
      await _storage.write(key: 'student_id', value: token.studentId);
    }
    await _storage.write(key: 'is_staff', value: token.isStaff.toString());
  }

  // ─── Error parsing ────────────────────────────────────────────────────────────

  String _parseError(DioException e) {
    if (e.response != null) {
      final detail = e.response?.data['detail'];
      if (detail != null) return detail.toString();
      return 'Server error (${e.response?.statusCode})';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Is the server running?';
    }
    return 'No connection. Check your network.';
  }
}
