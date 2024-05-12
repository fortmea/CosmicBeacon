import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider to manage the selected date
final selectedDateProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime?>((ref) {
  return SelectedDateNotifier();
});

// Define a notifier to manage state changes for the selected date
class SelectedDateNotifier extends StateNotifier<DateTime?> {
  SelectedDateNotifier() : super(null);

  void updateDate(DateTime? newDate) {
    state = newDate;
  }
}
