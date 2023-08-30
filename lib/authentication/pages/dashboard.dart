// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/providers/agent_provider.dart';
import 'package:dotalk/authentication/providers/issues_provider.dart';
import 'package:dotalk/global/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/round_profile.dart';
import '../providers/user_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final agentProvider = Provider.of<AgentProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final issueProvider = Provider.of<IssueProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser!;
    final chosenAgentController = TextEditingController();

    final servicesImg = [
      'assets/advisor.png',
      'assets/financial-advisor.png',
      'assets/video-calling.png'
    ];
    final servicesName = [
      'Advisor',
      'Financial Advisor',
      'Video Calling',
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.82,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // WELCOME GREETINGS
                      const Text(
                        'Hello, ',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Text(
                        currentUser.displayName!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )
                    ],
                  ),

                  // AVAILABLE AGENTS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Talk to one of our capable agents now!',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 110,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: Text('No data at all!'));
                              }

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }

                              final docs = snapshot.data!.docs;
                              List<Map<String, dynamic>> agents = [];
                              List<String> agentIds = [];

                              // get all available agents
                              for (var element in docs) {
                                final data = element.data();
                                if (data['type'] == 'agent' &&
                                    data['active'] == true) {
                                  agents.add(data);
                                  agentIds.add(element.id);
                                }
                              }

                              // get map of all agents for provider use
                              if (mounted) {
                                Map<String, Map<String, dynamic>> allAgents =
                                    {};
                                Map<String, Map<String, dynamic>> allUsers = {};
                                for (var doc in docs) {
                                  final data = doc.data();
                                  if (data['type'] == 'agent') {
                                    allAgents[doc.id] = data;
                                  }
                                  allUsers[doc.id] = data;
                                }
                                agentProvider.setAllAgents(allAgents);
                                userProvider.setAllUsers(allUsers);
                              }
                              if (agents.isEmpty) {
                                return const Center(
                                    child: Column(
                                  children: [
                                    Text('No available agent now.'),
                                    Text(
                                      'But Dojjo is ever ready to help!',
                                      style: TextStyle(height: 2),
                                    ),
                                  ],
                                ));
                              }

                              // get issue categories
                              final issueCategories =
                                  issueProvider.issueCategories;
                              String _selectedCategory = issueCategories[0];
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 10,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: agents.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    chosenAgentController.text =
                                        '${agents[index]['first-name']} ${agents[index]['last-name']}';
                                    showModalBottomSheet(
                                      showDragHandle: true,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            height: 300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Agent Chosen: '),
                                                const SizedBox(height: 20),
                                                TextField(
                                                  readOnly: true,
                                                  controller:
                                                      chosenAgentController,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                  ),
                                                  value: _selectedCategory,
                                                  items: issueCategories
                                                      .map((String category) =>
                                                          DropdownMenuItem<
                                                                  String>(
                                                              value: category,
                                                              child: Text(
                                                                  category)))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedCategory =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 20),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              const Size(
                                                                  double
                                                                      .infinity,
                                                                  60),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          foregroundColor:
                                                              Colors.white),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                                issueId:
                                                                    issueProvider
                                                                        .createIssue(
                                                          agentId: agentIds[index],
                                                          category: _selectedCategory
                                                        )),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                      'Create Issue'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      useSafeArea: true,
                                    );
                                  },
                                  child: RoundProfile(
                                      agentName: agents[index]['first-name']),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Other Services',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(12)),
                      width: MediaQuery.of(context).size.width - 20,
                      child: ListView.separated(
                        // scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blueGrey[400],
                                image: DecorationImage(
                                    image: AssetImage(servicesImg[index]),
                                    fit: BoxFit.fitHeight)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.info_rounded,
                                      color: Colors.white),
                                  Text(
                                    servicesName[index],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('dojjobot')
                            .doc(currentUser.uid)
                            .set({'texts': []}, SetOptions(merge: true));
                        if (mounted) {
                          Navigator.of(context).pushNamed('/dojjobot');
                        }
                      },
                      child: const Text(
                        'Chat with Dojjo!',
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
