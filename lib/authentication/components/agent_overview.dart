// to be used later in determining dashboard to user based on user type

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/components/overview_card.dart';
import 'package:dotalk/global/chat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AgentOverview extends StatefulWidget {
  const AgentOverview({super.key, required this.snapshot});

  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  State<AgentOverview> createState() => _AgentOverviewState();
}

class _AgentOverviewState extends State<AgentOverview> {
  final store = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // working with asynchoronous snapshot from dashboard streambuilder
    final users = widget.snapshot.data!.docs;
    Map<String, Map<String, dynamic>> allUsers = {};
    for (var user in users) {
      allUsers[user.id] = user.data();
    }
    userProvider.setAllUsers(allUsers);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest Issue',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Client Name',
                  style: TextStyle(),
                ),
                const Text(
                  'Category',
                  style: TextStyle(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         const ChatScreen(issueId: '')));
                          showDialog(
                            context: context,
                            builder: ((context) => Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[100],
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      'Dialog appears here',
                                      style: GoogleFonts.trirong(fontSize: 20),
                                    ),
                                  ),
                                )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Text customer'),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(30),
                                    child: const Text('Update Issue Status'),
                                  ),
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text('Update status'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Issues Overview',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          const Column(
            children: [
              OverviewCard(
                category: 'General',
                numberOfIssues: 1,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              SizedBox(height: 10),
              OverviewCard(
                category: 'Account',
                numberOfIssues: 1,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              SizedBox(height: 10),
              OverviewCard(
                category: 'Payment & Billing',
                numberOfIssues: 1,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              SizedBox(height: 10),
              OverviewCard(
                category: 'Network',
                numberOfIssues: 1,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              SizedBox(height: 10),
              OverviewCard(
                category: 'Product Information',
                numberOfIssues: 1,
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              SizedBox(height: 30),
            ],
          )
        ],
      ),
    );
  }
}
