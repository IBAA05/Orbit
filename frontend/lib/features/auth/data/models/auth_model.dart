/// Matches the backend's TokenResponse schema exactly.
///
/// Backend returns:
/// {
///   "access_token": "eyJ...",
///   "token_type": "bearer",
///   "user_id": 1,
///   "full_name": "Ibaa Lamouri",
///   "is_staff": false
/// }
class AuthTokenModel {
  final String accessToken;
  final String tokenType;
  final int userId;
  final String fullName;
  final bool isStaff;

  const AuthTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.fullName,
    required this.isStaff,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      userId: json['user_id'] as int,
      fullName: json['full_name'] as String,
      isStaff: json['is_staff'] as bool,
    );
  }
}
