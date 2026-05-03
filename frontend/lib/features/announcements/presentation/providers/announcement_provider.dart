import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/announcement_model.dart';
import '../../data/repositories/announcement_repository.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepository();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final announcementListProvider = FutureProvider<List<AnnouncementModel>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repository.getAnnouncements(category: category);
});
