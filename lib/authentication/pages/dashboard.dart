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
    Widget dojjobotBtnChild = const Icon(
      Icons.adb_rounded,
      color: Colors.white,
      semanticLabel: "Chat with Dojjo!",
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child:
                    Text('Failed to load data with error: ${snapshot.error}'),
              );
            }

            final userDocs = snapshot.data!.docs;
            final Map<String, Map<String, dynamic>> allUsers = {};
            for (var doc in userDocs) {
              allUsers[doc.id] = doc.data();
            }
            userProvider.setAllUsers(allUsers);

            return Stack(
              children: [
                ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            // WELCOME GREETINGS
                            const Text(
                              'Hello, ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              userProvider.allUsers[currentUser.uid]?['first-name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),

                        // AVAILABLE AGENTS
                        Flexible(
                          fit: FlexFit.loose,
                          child:
                              userProvider.allUsers[currentUser.uid]!['type'] ==
                                      'agent'
                                  ? AgentOverview(snapshot: snapshot)
                                  : ClientDashboard(snapshot: snapshot),
                        ),
                      ],
                    ),
                  ],
                ),
                userProvider.allUsers[currentUser.uid]!['type'] == 'client'
                    ? Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          onPressed: () async {
                            setState(() {
                              dojjobotBtnChild =
                                  const CircularProgressIndicator();
                            });
                            await FirebaseFirestore.instance
                                .collection('dojjobot')
                                .doc(currentUser.uid)
                                .set({'texts': []}, SetOptions(merge: true));

                            if (mounted) {
                              Navigator.of(context).pushNamed('/dojjobot');
                            }
                          },
                          child: dojjobotBtnChild,
                        ),
                      )
                    : const Center()
              ],
            );
          }),
    );
  }
}
