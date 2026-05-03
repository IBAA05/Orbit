class TimetableEntryModel {
  final int id;
  final int userId;
  final String subject;
  final String? instructor;
  final String? location;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String colorHex;
  final String? semester;

  TimetableEntryModel({
    required this.id,
    required this.userId,
    required this.subject,
    this.instructor,
    this.location,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.colorHex,
    this.semester,
  });

  factory TimetableEntryModel.fromJson(Map<String, dynamic> json) {
    return TimetableEntryModel(
      id: json['id'],
      userId: json['user_id'],
      subject: json['subject'],
      instructor: json['instructor'],
      location: json['location'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      colorHex: json['color_hex'] ?? '#0D6E53',
      semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subject': subject,
      'instructor': instructor,
      'location': location,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'color_hex': colorHex,
      'semester': semester,
    };
  }
}
