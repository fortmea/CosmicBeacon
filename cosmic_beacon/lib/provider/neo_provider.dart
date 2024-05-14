import 'package:cosmic_beacon/data/api/neows.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/models/equatable_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final neoDataProvider = FutureProvider.family<List<AsteroidData>, DateTime?>(
    (ref, DateTime? dateTime) async {
  if (dateTime == null) {
    return [];
  }
  return ref.watch(neoProvider).getNEO(dateTime);
});

final neoDetailedDataProvider =
    FutureProvider.family<AsteroidData, String>((ref, String id) async {
  return ref.watch(neoProvider).getNeoById(id);
});

final multipleNeoDetailedDataProvider = FutureProvider.autoDispose
    .family<List<AsteroidData>, EquatableList>((ref, EquatableList ids) async {
  return ref.watch(neoProvider).getMultipleNeoById(ids);
});
