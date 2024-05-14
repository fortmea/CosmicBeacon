import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmic_beacon/data/firebase/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider.autoDispose<DocumentSnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
});