import 'package:flutter_riverpod/flutter_riverpod.dart';

final containerHeightProvider =
    StateNotifierProvider<ContainerHeightNotifier, double?>((ref) {
  return ContainerHeightNotifier(null);
});

class ContainerHeightNotifier extends StateNotifier<double?> {
  ContainerHeightNotifier(super.initialState);

  void updateHeight(double height) {
    print(height.toString() + "ATUALIZADO ##################");
    state = height;
  }
}
