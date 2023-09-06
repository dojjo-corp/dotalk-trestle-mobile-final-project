// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/components/client_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/agent_overview.dart';
import '../providers/user_provider.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userProvider = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.82,
          child: Stack(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Failed to load data with error: ${snapshot.error}'),
                      );
                    }

                    final userDocs = snapshot.data!.docs;
                    final Map<String, Map<String, dynamic>> allUsers = {};
                    for (var doc in userDocs) {
                      allUsers[doc.id] = doc.data();
                    }
                    userProvider.setAllUsers(allUsers);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // WELCOME GREETINGS
                            const Text(
                              'Hello, ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              currentUser.displayName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),

                        // AVAILABLE AGENTS
                        Expanded(
                          child:
                              userProvider.allUsers[currentUser.uid]!['type'] ==
                                      'agent'
                                  ? AgentOverview(snapshot: snapshot)
                                  : ClientDashboard(snapshot: snapshot),
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
