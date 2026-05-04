/// Matches the backend's TokenResponse schema exactly.
class AuthTokenModel {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String fullName;
  final String email;
  final String? studentId;
  final bool isStaff;

  const AuthTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.fullName,
    required this.email,
    this.studentId,
    required this.isStaff,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      userId: json['user_id'] as int,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      studentId: json['student_id'] as String?,
      isStaff: json['is_staff'] as bool,
    );
  }
}
