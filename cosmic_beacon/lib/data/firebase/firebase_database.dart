import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmic_beacon/models/asteroid_data.dart';
import 'package:cosmic_beacon/provider/ai_insight_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final String uid;
  Database({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference generationRequestCollection =
      FirebaseFirestore.instance.collection('generate');
  Future updateUserData(List<String> ids) async {
    return await userCollection.doc(uid).update({
      'bookmarked': ids,
    });
  }

  Future<DocumentSnapshot<Object?>> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  Future<void> addBookmark(String id) async {
    final userDoc = await userCollection.doc(uid).get();
    if (userDoc.exists) {
      final List<dynamic> bookmarks =
          (userDoc.data() as Map<String, dynamic>)['bookmarked'] ?? [];
      if (bookmarks.contains(id)) {
        bookmarks.remove(id);
        await userCollection.doc(uid).update({
          'bookmarked': bookmarks,
        });
      } else {
        bookmarks.add(id);
        await userCollection.doc(uid).update({
          'bookmarked': bookmarks,
        });
      }
    }
  }

  Future deleteUser() async {
    return await userCollection.doc(uid).delete();
  }

  Future createUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final userDoc = await userCollection.doc(uid).get();
      if (!userDoc.exists) {
        return await userCollection.doc(uid).set({
          'bookmarked': [],
        });
      }
    } else {
      print('User is null');
    }
  }

  Future createGenerationRequest(
      InsightLocalizator insightLocalizator, AsteroidData data) async {
    if (data.closeApproachDataList.length > 1) {
      data.closeApproachDataList
          .removeRange(1, data.closeApproachDataList.length - 1);
    }

    return await generationRequestCollection
        .doc('${insightLocalizator.id}_${insightLocalizator.languageCode}')
        .set({
      "data": data.toJson().toString(),
      "lang": insightLocalizator.languageCode,
    });
  }

  Stream generationRequest(InsightLocalizator insightLocalizator) =>
      generationRequestCollection
          .doc('${insightLocalizator.id}_${insightLocalizator.languageCode}')
          .snapshots();
}
