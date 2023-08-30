// ignore_for_file: avoid_unnecessary_containers

import 'package:dotalk/authentication/pages/settings/security.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  // bool _isDark = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'App Settigs',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            // const SizedBox(height: 20),
            // PROFILE HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Image.asset('assets/man.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user!.displayName!,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(user!.email!,
                        style: TextStyle(color: Colors.grey[700]))
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            // SETTING ITEM-LIST
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to item page
                        Navigator.of(context).pushNamed('/account');
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.person_2_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: const Text('Account Information'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to item page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SecuritySettings()));
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.security_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: const Text('Security'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to item page
                        Navigator.of(context).pushNamed('/settings/notifications');
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.notifications_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to item page
                        Navigator.pushNamed(context, '/settings/privacy');
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.privacy_tip_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: const Text('Privacy'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to item page
                        Navigator.pushNamed(context, '/settings/apps');
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Icon(
                          Icons.space_dashboard_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: const Text('Linked Apps'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
