class FeedPostModel {
  final int id;
  final String tag;
  final String title;
  final String body;
  final String? imageUrl;
  final String authorLabel;
  final int seenCount;
  final bool isPinned;
  final String timeAgo;
  final DateTime createdAt;

  FeedPostModel({
    required this.id,
    required this.tag,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.authorLabel,
    required this.seenCount,
    required this.isPinned,
    required this.timeAgo,
    required this.createdAt,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      id: json['id'],
      tag: json['tag'],
      title: json['title'],
      body: json['body'],
      imageUrl: json['image_url'],
      authorLabel: json['author_label'] ?? 'Student Council',
      seenCount: json['seen_count'] ?? 0,
      isPinned: json['is_pinned'] ?? false,
      timeAgo: json['time_ago'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag': tag,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'author_label': authorLabel,
      'seen_count': seenCount,
      'is_pinned': isPinned,
      'time_ago': timeAgo,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
