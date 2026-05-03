import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feed_post_model.dart';
import '../../data/repositories/feed_repository.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository();
});

final feedListProvider = FutureProvider<List<FeedPostModel>>((ref) async {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.getFeed();
});
