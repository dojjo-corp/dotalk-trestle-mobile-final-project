import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreRepo {
  final user = FirebaseAuth.instance.currentUser;
  final store = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> createUserDoc({
    required String? uid,
    required String? fName,
    required String? lName,
    required String? email,
    required String? contact,
    required String? type,
  }) async {
    final data = {
      'first-name': fName,
      'last-name': lName,
      'email': email,
      'contact': contact,
      'issues': [],
      'type': type,
      'date-joined': Timestamp.now(),
      'active': true,
    };

    await store.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> createIssue({issueId, agent, client, category}) async {
    try {
      await store.collection('issues').doc(issueId).set({
        'agent': agent,
        'client': client,
        'time-created': Timestamp.now(),
        'texts': [],
        'active': true,
        // add category
        'category': category
      });

      // update user's issue property on firestore document
      final userDoc = await store.collection('users').doc(user?.uid).get();
      final issues = userDoc.data()?['issues'];
      issues.add(issueId);
      await store.collection('users').doc(user?.uid).update({'issues': issues});
    } on FirebaseException catch (e) {
      log(e.code);
    }
  }

  Future<void> sendChat({text, source, issueId}) async {
    try {
      // fetch current texts from firestore doc
      final textSnapshot = await store.collection('issues').doc(issueId).get();

      // add sent text to list
      Map<String, dynamic> textModelObject = {
        'text': text,
        'source': source,
        'time': DateTime.now()
      };
      final texts = textSnapshot.data()!['texts'];
      texts.add(textModelObject);

      // update firestore with new text
      await store
          .collection('issues')
          .doc(issueId)
          .update({'texts': FieldValue.arrayUnion([textModelObject])});
    } on FirebaseException catch (e) {
      log(e.code);
    }
  }

  Future<void> textDojjo({required String text, required String? uid}) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      // fetch current texts from firestore doc
      final textSnapshot = await store.collection('dojjobot').doc(uid).get();

      Map<String, dynamic> textModelObject = {'text': text};
      // add sent text to list
      final texts = textSnapshot.data()!['prompts'];
      texts.add(textModelObject);

      // update firestore with new text
      await store
          .collection('issues')
          .doc(uid)
          .set({'prompts': texts}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      log(e.code);
    }
  }
}
