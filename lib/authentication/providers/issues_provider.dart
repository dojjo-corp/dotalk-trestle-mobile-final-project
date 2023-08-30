// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:dotalk/authentication/repository/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IssueProvider extends ChangeNotifier {
  final List<String> _issueCategories = [
    'Account',
    'Payment & Billing',
    'Network',
    'Product Information', 
    'General'
  ];

  List<String> get issueCategories => _issueCategories;
  // METHODS
  Future<void> sendChat({chatText, source}) async {
    // method for sending chats in discussing issues
  }

  String generateIssueId() {
    String issueId = '';
    // todo: generate random number (0 - 10000)
    String randInt = Random().nextInt(10000).toString();

    // todo: preppend 0s to random number till number has five digits (eg. 10 => 00010)
    if (randInt.length < 5) {
      int rem = 5 - randInt.length;
      randInt = ('0' * rem) + randInt;
    }

    // todo: concatenate String 'IS' and random number and return
    issueId = 'IS_$randInt';
    return issueId;
  }

  String createIssue({agentId, category}) {
    String newIssueId = generateIssueId();

    // todo: asign issue fields (agentId, start time, status)

    // create issue doc in firestore
    FireStoreRepo().createIssue(
        category: category,
        issueId: newIssueId,
        agent: agentId,
        client: FirebaseAuth.instance.currentUser?.uid);
    return newIssueId;
  }

  List? getActiveIssues() {
    List? activeIssues = [];

    return activeIssues;
  }

  List? getArchivedIssues() {
    List? archivedIssues = [];

    return archivedIssues;
  }

  // temporal method for sending texts
  Map<String, Map<String, dynamic>> texts = {};
  void sendText({text, issuedId}) {
    texts[issuedId] = {
      'texts': [],
    };
    notifyListeners();
  }
}
