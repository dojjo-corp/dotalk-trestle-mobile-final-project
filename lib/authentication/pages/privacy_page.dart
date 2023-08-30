import 'package:flutter/material.dart';

import '../models/privacy_policy.dart';

class MyPrivacyPage extends StatelessWidget {
  const MyPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(const LongTextInHtml().privacyPolicyHtml),
        ),
      ),
    );
  }
}
