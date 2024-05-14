import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String uid;
  Database({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
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

  Future createUser() async {
    final userDoc = await userCollection.doc(uid).get();
    if (!userDoc.exists) {
      return await userCollection.doc(uid).set({
        'bookmarked': [],
      });
    }
  }
}
