import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, Map<String, dynamic>> _allUsers = {};
  Map<String, Map<String, dynamic>> get allUsers => _allUsers;

  void setAllUsers(Map<String, Map<String, dynamic>> allUsers) {
    _allUsers = allUsers;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }
}
