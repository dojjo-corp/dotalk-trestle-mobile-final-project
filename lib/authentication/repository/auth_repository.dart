// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/repository/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final firebaseAuth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  final repo = FireStoreRepo();

  Stream onAuthStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  Future<UserCredential> login(String email, String password) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> register({
    required String fName,
    required String lName,
    required String email,
    required String password,
    required String type,
  }) async {
    try {
      final newUser = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // create user document in firestore
      final tempUser = newUser.user;
      
      await repo.createUserDoc(
          uid: tempUser?.uid,
          fName: fName,
          lName: lName,
          email: email,
          contact: tempUser?.phoneNumber,
          type: type);
      // final Map<String, dynamic> userData = {
      //   'first-name': fName,
      //   'last-name': lName,
      //   'email': email,
      //   'phone-number': tempUser.phoneNumber,
      //   'type': type,
      //   'issue-ids': [],
      // };
      await tempUser?.updateDisplayName(fName);
      await tempUser?.updatePhotoURL('assets/');

      // path to account document = users/{client/agent}/userDoc
      // await store.collection('users').doc(tempUser?.uid).set(userData);

      return newUser;
    } catch (e) {
      rethrow;
    }
  }
}
