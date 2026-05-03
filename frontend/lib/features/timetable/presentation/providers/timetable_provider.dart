import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/timetable_model.dart';
import '../../data/repositories/timetable_repository.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository();
});

// The currently selected day in the UI (Mon, Tue, etc.)
final selectedDayProvider = StateProvider<String>((ref) => 'Mon');

// Fetches the schedule filtered by the selected day
final scheduleListProvider = FutureProvider<List<TimetableEntryModel>>((ref) async {
  final repository = ref.watch(timetableRepositoryProvider);
  final selectedDay = ref.watch(selectedDayProvider);
  return repository.getSchedule(day: selectedDay);
});
