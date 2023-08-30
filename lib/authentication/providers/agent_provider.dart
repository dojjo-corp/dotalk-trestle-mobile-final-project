// ignore_for_file: prefer_final_fields

// import 'dart:js_interop';

import 'package:flutter/material.dart';

class AgentProvider extends ChangeNotifier {
  Map<String, Map<String, dynamic>> get allAgents => _allAgents;
  Map<String, Map<String, dynamic>> _allAgents = {};

  void setAllAgents(Map<String, Map<String, dynamic>> agentsMap) {
    // to be called in the dashboard widget where all available agents are got from streambuilder
    // eg. {'agentDocumentId': {agentData}}
    _allAgents = agentsMap;

    // notify listeners only after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
