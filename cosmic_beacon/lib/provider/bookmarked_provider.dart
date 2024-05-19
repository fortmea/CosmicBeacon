import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookmarkedProvider =
    StateNotifierProvider<BookmarkedNotifier, bool>((ref) {
  return BookmarkedNotifier(false);
});

class BookmarkedNotifier extends StateNotifier<bool> {
  BookmarkedNotifier(super.initialState);

  void updateBookmarked(bool marked) {
    state = marked;
  }
}
