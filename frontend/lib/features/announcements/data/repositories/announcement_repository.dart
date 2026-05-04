import '../../../../core/network/api_client.dart';
import '../models/announcement_model.dart';

class AnnouncementRepository {
  final _client = ApiClient.instance;

  Future<List<AnnouncementModel>> getAnnouncements({String? category}) async {
    try {
      final response = await _client.get(
        '/announcements/',
        queryParameters: category != null ? {'category': category} : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load announcements');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(int id) async {
    await _client.post('/announcements/$id/read');
  }

  Future<void> createAnnouncement(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('/announcements/', data: data);
      if (response.statusCode != 201) {
        throw Exception('Failed to create announcement');
      }
    } catch (e) {
      rethrow;
    }
  }
}
