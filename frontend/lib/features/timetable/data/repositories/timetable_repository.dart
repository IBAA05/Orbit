import '../../../../core/network/api_client.dart';
import '../models/timetable_model.dart';

class TimetableRepository {
  final _client = ApiClient.instance;

  Future<List<TimetableEntryModel>> getSchedule({String? day}) async {
    try {
      final response = await _client.get(
        '/timetable/',
        queryParameters: day != null ? {'day': day} : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TimetableEntryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      rethrow;
    }
  }
}
