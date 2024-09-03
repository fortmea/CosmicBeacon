import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmic_beacon/models/insight.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsightLocalizator {
  final String languageCode;
  final String id;

  InsightLocalizator(this.languageCode, this.id);
}

final generatedInsightProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot, InsightLocalizator>((ref, params) {
  return FirebaseFirestore.instance
      .collection('generate')
      .doc('${params.id}_${params.languageCode}')
      .snapshots();
});

class InsightNotifier extends StateNotifier<Insight> {
  InsightNotifier(super.initialState);

  void updateInsight(Insight insight) {
    state = insight;
  }
}
