import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventTypeFilterProvider = StateProvider<String?>((ref) => null);

final eventListProvider = FutureProvider<List<EventModel>>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  final typeFilter = ref.watch(eventTypeFilterProvider);
  return repository.getEvents(eventType: typeFilter);
});
