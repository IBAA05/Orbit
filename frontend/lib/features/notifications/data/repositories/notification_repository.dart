import 'package:orbit/core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final _client = ApiClient.instance;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _client.get('/notifications/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> markAllAsRead() async {
    await _client.post('/notifications/mark-all-read');
  }
}
