class AnnouncementModel {
  final int id;
  final String title;
  final String body;
  final String category;
  final String targetAudience;
  final bool isPublished;
  final int authorId;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.targetAudience,
    required this.isPublished,
    required this.authorId,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      category: json['category'],
      targetAudience: json['target_audience'],
      isPublished: json['is_published'] ?? true,
      authorId: json['author_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
