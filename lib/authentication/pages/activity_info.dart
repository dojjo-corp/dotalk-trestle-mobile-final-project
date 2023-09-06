import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({super.key});

  @override
  State<MyActivity> createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {
  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Information',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const Text(
              'What you\'ve been up to here',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(
                      child: Text('Seems you\'ve not yet started making use of this awesome invention...'),
                    );
                  }

                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('issues')
                          .snapshots(),
                      builder: (context, issueSnapshot) {
                        if (!issueSnapshot.hasData) {
                          return const Center(
                            child: Text('Nothing yet...'),
                          );
                        }

                        if (issueSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final allIssuesDocs = issueSnapshot.data!.docs;
                        List activeIssues = [];
                        List archivedIssues = [];
                        for (var doc in allIssuesDocs) {
                          final data = doc.data();
                          if (data.values.toList().contains(currentUser.uid)) {
                            if (data['active']) {
                              activeIssues.add(data);
                            } else {
                              archivedIssues.add(data);
                            }
                          }
                        }

                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                height: 200,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        width: 200,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xff6190E8),
                                                Color(0xffA7BFE8)
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.blue[300],
                                              ),
                                              height: 50,
                                              width: 50,
                                              child: const Icon(
                                                Icons.task_alt_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Text(
                                              'Active Issues',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const Divider(
                                                endIndent: 15, indent: 15),
                                            Text(
                                              '${activeIssues.length}',
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 30),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        width: 200,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xff6190E8),
                                                Color(0xffA7BFE8)
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.blue[300],
                                              ),
                                              height: 50,
                                              width: 50,
                                              child: const Icon(
                                                Icons.save_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Text(
                                              'Archived Issues',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const Divider(
                                                endIndent: 15, indent: 15),
                                            Text(
                                              '${archivedIssues.length}',
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 30),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                width: MediaQuery.of(context).size.width - 40,
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff6190E8),
                                        Color(0xffA7BFE8)
                                      ]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.blue[300],
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: const Icon(
                                        Icons.view_list_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'Total Issues',
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const Divider(endIndent: 15, indent: 15),
                                    Text(
                                      '${activeIssues.length + archivedIssues.length}',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 30),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
