import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndexProvider =
    StateNotifierProvider<SelectedIndexNotifier, int>((ref) {
  return SelectedIndexNotifier();
});

// Define a notifier to manage state changes for the selected date
class SelectedIndexNotifier extends StateNotifier<int> {
  SelectedIndexNotifier() : super(0);

  void updateDate(int index) {
    state = index;
  }
}
