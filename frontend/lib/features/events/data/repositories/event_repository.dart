import '../../../../core/network/api_client.dart';
import '../models/event_model.dart';

class EventRepository {
  final _client = ApiClient.instance;

  Future<List<EventModel>> getEvents({String? eventType}) async {
    try {
      final response = await _client.get(
        '/events/',
        queryParameters: eventType != null ? {'event_type': eventType} : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerForEvent(int id) async {
    await _client.post('/events/$id/register');
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('/events/', data: data);
      if (response.statusCode != 201) {
        throw Exception('Failed to create event');
      }
    } catch (e) {
      rethrow;
    }
  }
}
