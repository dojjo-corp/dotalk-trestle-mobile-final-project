// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/providers/issues_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global/chat.dart';
import '../components/issue_card.dart';
import '../providers/agent_provider.dart';
import '../providers/user_provider.dart';
// import '../providers/agent_provider.dart';

class UserIssues extends StatefulWidget {
  const UserIssues({super.key});

  @override
  State<UserIssues> createState() => _UserIssuesState();
}

class _UserIssuesState extends State<UserIssues>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final store = FirebaseFirestore.instance;

  // modal bottom sheet for new issues
  final issueIdController = TextEditingController();
  final issueCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final agentProvider = Provider.of<AgentProvider>(context);
    final issueProvider = Provider.of<IssueProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('issues').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Card(
                child: Text('No issues created'),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final issueCategories = issueProvider.issueCategories;
          final issues = snapshot.data?.docs;
          List<QueryDocumentSnapshot<Map<String, dynamic>>> activeIssues = [];
          List<QueryDocumentSnapshot<Map<String, dynamic>>> archivedIssues = [];
          for (var issue in issues!) {
            var currentUser = FirebaseAuth.instance.currentUser;
            if (issue.data().values.toList().contains(currentUser!.uid)) {
              if (issue.data()['active']) {
                activeIssues.add(issue);
              } else {
                archivedIssues.add(issue);
              }
            }
          }

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        const Text(
                          'Issues',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                        ),
                        TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'Active'),
                            Tab(text: 'Archived'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        activeIssues.isEmpty
                            ? const Center(
                                child: Text(
                                    'Click on the "+" icon to create an issue'))
                            : ListView.separated(
                                itemCount: activeIssues.length,
                                itemBuilder: (context, index) {
                                  final issue = activeIssues[index];
                                  Map<String, dynamic> issueData = issue.data();
                                  String? lastText = 'No text yet';
                                  DateTime tempTime;
                                  String? lastTime = 'last-time';
                                  if (issueData['texts'].isNotEmpty) {
                                    lastText = issueData['texts'].last['text'];
                                    tempTime = issue
                                        .data()['texts']
                                        .last['time']
                                        .toDate();
                                    lastTime =
                                        '${tempTime.hour}:${tempTime.minute}';
                                  }
                                  // ignore: unrelated_type_equality_checks
                                  Map<String, dynamic> recipient = {};
                                  String recipientId = '';
                                  if (issueData['agent'] == currentUser.uid) {
                                    recipient = userProvider
                                        .allUsers[issueData['client']]!;
                                    recipientId = issueData['client'];
                                  } else {
                                    recipient = userProvider
                                        .allUsers[issueData['agent']]!;
                                    recipientId = issueData['agent'];
                                  }
                                  final recipientName =
                                      '${recipient['first-name']} ${recipient['last-name']}';
                                  final lastTextSource = issueData['texts']
                                              .isNotEmpty &&
                                          issueData['texts'].last['source'] ==
                                              recipientId
                                      ? recipientName
                                      : 'You';
                                  return IssuesCard(
                                    agentName: recipientName,
                                    index: index,
                                    issueId: issue.id,
                                    category: issueData['category'],
                                    lastText: lastText,
                                    lastTextSource: lastTextSource,
                                    lastTime: lastTime,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                              ),
                        archivedIssues.isEmpty
                            ? const Center(child: Text('No archived issues'))
                            : ListView.separated(
                                itemCount: archivedIssues.length,
                                itemBuilder: (context, index) {
                                  final issue = archivedIssues[index];
                                  Map<String, dynamic> data = issue.data();
                                  String? lastText = '';
                                  DateTime tempTime;
                                  String? lastTime = '';
                                  if (data['texts'].isNotEmpty) {
                                    lastText = data['texts'].last['text'];
                                    tempTime =
                                        data['texts'].last['time'].toDate();
                                    lastTime =
                                        '${tempTime.hour}:${tempTime.minute}';
                                  }
                                  final issueAgent =
                                      agentProvider.allAgents[issue['agent']];
                                  final agentName =
                                      '${issueAgent?['first-name']} ${issueAgent?['last-name']}';
                                  String lastTextSource =
                                      data['texts'].isNotEmpty &&
                                              data['texts'].last['source'] ==
                                                  data['agent']
                                          ? agentName
                                          : 'You';
                                  // if (issue.data()['texts'].isEmpty){
                                  //   lastTextSource = '';
                                  // } else if(issue.data()['texts'].last['source'] == )
                                  return IssuesCard(
                                    agentName: agentName,
                                    index: index,
                                    issueId: issue.id,
                                    category: issue['category'],
                                    lastText: lastText,
                                    lastTextSource: lastTextSource,
                                    lastTime: lastTime,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 15),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    showModalBottomSheet(
                        backgroundColor: Colors.blueGrey[100],
                        showDragHandle: true,
                        context: context,
                        builder: (context) {
                          final allAgents =
                              agentProvider.allAgents.values.toList();
                          final agentNames = [];
                          final agentIds =
                              agentProvider.allAgents.keys.toList();
                          for (var agent in allAgents) {
                            agentNames.add(agent['first-name']);
                          }
                          String _selectedAgent = agentNames[0];
                          String _selectedCategory = issueCategories[0];

                          return Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              color: Colors.blueGrey[100],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Choose Your Preferred Agent'),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  value: _selectedAgent,
                                  items: allAgents
                                      .map((Map<String, dynamic> agent) =>
                                          DropdownMenuItem<String>(
                                              value: agent['first-name'],
                                              child: Text(agent['first-name'])))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAgent = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text('Select Category'),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  value: _selectedCategory,
                                  items: issueCategories
                                      .map((String category) =>
                                          DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              issueId:
                                                  issueProvider.createIssue(
                                            agentId: agentIds[agentNames
                                                .indexOf(_selectedAgent)],
                                            category: _selectedCategory,
                                          )),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 60)),
                                    child: const Text('Create Issue'))
                              ],
                            ),
                          );
                        });
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }
}
