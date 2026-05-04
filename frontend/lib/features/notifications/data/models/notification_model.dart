class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String iconType;
  final bool isRead;
  final String? deepLinkRoute;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.iconType,
    required this.isRead,
    this.deepLinkRoute,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      iconType: json['icon_type'] ?? 'info',
      isRead: json['is_read'] ?? false,
      deepLinkRoute: json['deep_link_route'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
