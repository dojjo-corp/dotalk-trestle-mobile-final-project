import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/components/chat_bubble.dart';
import 'package:dotalk/authentication/repository/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.issueId});
  final String issueId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _key = GlobalKey<FormState>();
  final textController = TextEditingController();
  final store = FirebaseFirestore.instance;
  final repo = FireStoreRepo();
  final currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> agentDoc = {};

  void getAgentDoc(Map<String, dynamic> issue) {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('issues')
            .doc(widget.issueId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const AlertDialog(
              title: Center(child: CircularProgressIndicator()),
            );
          }

          // error in reading from stream
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: AlertDialog(
                  content: Text('Error: ${snapshot.error}'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('go back'),
                    ),
                  ],
                ),
              ),
            );
          }

          // successfully read from stream
          final issue = snapshot.data!.data() as Map<String, dynamic>;
          final texts = issue['texts'];
          // getAgentDoc(issue);
          final tempSnapshot =
              store.collection('users').doc(issue['agent']).get();
          tempSnapshot.then((value) {
            setState(() {
              agentDoc = value.data()!;
            });
          });

          final appBarUser = issue['agent'] == currentUser.uid
              ? issue['client']
              : issue['agent'];
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(appBarUser)
                            .get(),
                        builder: (context, futureSnapshot) {
                          if (!futureSnapshot.hasData) {
                            return const Text('Connecting...');
                          }

                          final data = futureSnapshot.data!.data()!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  data['first-name'] + ' ' + data['last-name']),
                              Text(
                                data['active'] ? 'Online' : 'Offline',
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          );
                        }),
                    // Thank God for ChatGpt!!!
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle menu item selection
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'option1',
                            child: Text('Option 1'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'option2',
                            child: Text('Option 2'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'option3',
                            child: Text('Option 3'),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ), // flexibleSpace: CountDownTimer(),
            ),
            body: snapshot.hasData && snapshot.data?.data() != null
                ? Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 30, top: 10),
                        child: ListView.separated(
                          itemCount: texts.length,
                          itemBuilder: (context, index) => Align(
                            alignment: texts[index]['source'] == currentUser.uid
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: ChatBubble(
                              text: texts[index]['text']!,
                              source: texts[index]['source']!,
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 2),
                        ),
                      ),

                      // bottom bar for typing messages
                      Positioned(
                        bottom: 0,
                        right: 0,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          color: Colors.grey[400],
                          child: Row(
                            children: [
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.attach_file_rounded),
                                onSelected: (value) {
                                  // Handle menu item selection
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'option1',
                                      child: Text('Option 1'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'option2',
                                      child: Text('Option 2'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'option3',
                                      child: Text('Option 3'),
                                    ),
                                  ];
                                },
                              ),
                              Expanded(
                                child: Form(
                                  key: _key,
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: textController,
                                    decoration: const InputDecoration(
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Message',
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  repo.sendChat(
                                    text: textController.text,
                                    source: currentUser.uid,
                                    issueId: widget.issueId,
                                  );
                                  textController.clear();
                                },
                                icon: const Icon(Icons.send_rounded),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Text('No Texts yet'),
                  ),
          );
        });
  }
}
