import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider.autoDispose((ref) async* {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final currentUser = auth.currentUser;
  if (currentUser == null) {
    yield null;
    return;
  }

  await for (final userDoc
      in firestore.collection('users').doc(currentUser.uid).snapshots()) {
    if (!userDoc.exists) {
      yield null;
      continue;
    }

    final userData = userDoc.data() ?? {};
    yield userData;
  }
});
