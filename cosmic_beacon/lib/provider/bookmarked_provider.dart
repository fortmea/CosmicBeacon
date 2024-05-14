import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookmarkedProvider =
    StateNotifierProvider<BookmarkedNotifier, bool>((ref) {
  return BookmarkedNotifier(
      false); // Initial value, change it to whatever you need
});

class BookmarkedNotifier extends StateNotifier<bool> {
  BookmarkedNotifier(bool initialState) : super(initialState);

  void updateBookmarked(bool marked) {
    state = marked;
  }
}
