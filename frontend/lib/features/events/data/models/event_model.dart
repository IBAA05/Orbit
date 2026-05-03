class EventModel {
  final int id;
  final String title;
  final String? location;
  final DateTime eventDate;
  final int capacity;
  final String eventType;
  final int registeredCount;
  final bool isFull;
  final String status;

  EventModel({
    required this.id,
    required this.title,
    this.location,
    required this.eventDate,
    required this.capacity,
    required this.eventType,
    required this.registeredCount,
    required this.isFull,
    required this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      eventDate: DateTime.parse(json['event_date']),
      capacity: json['capacity'] ?? 0,
      eventType: json['event_type'] ?? 'Other',
      registeredCount: json['registered_count'] ?? 0,
      isFull: json['is_full'] ?? false,
      status: json['status'] ?? 'Open',
    );
  }
}
