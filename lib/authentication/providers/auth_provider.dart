// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final repo = AuthRepository();
  // User? currentUser = repo.firebaseAuth.currentUser;
  Future<UserCredential?> login(String email, String password) async {
    try {
      return await repo.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> register({
    required String fName,
    required String lName,
    required String email,
    required String password,
    required String type,
  }) async {
    try {
      return await repo.register(
        email: email,
        password: password,
        type: type,
        fName: fName,
        lName: lName,
      );
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
