import '../../../../core/network/api_client.dart';
import '../models/feed_post_model.dart';

class FeedRepository {
  final _client = ApiClient.instance;

  Future<List<FeedPostModel>> getFeed({int skip = 0, int limit = 20}) async {
    try {
      final response = await _client.get(
        '/feed/',
        queryParameters: {'skip': skip, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FeedPostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load feed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedPostModel> getPost(int id) async {
    try {
      final response = await _client.get('/feed/$id');

      if (response.statusCode == 200) {
        return FeedPostModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      rethrow;
    }
  }
}
