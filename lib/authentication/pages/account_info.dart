import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final langController = TextEditingController();
  Widget btnChild = const Text('Update Profile');

  final currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userDoc = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAGE HEADER
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Profile foto, name & languages',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300]),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('Loading your information...'),
                      );
                    }

                    userDoc = snapshot.data!.data()!;

                    fNameController.text = userDoc['first-name'];
                    lNameController.text = userDoc['last-name'];
                    emailController.text = userDoc['email'];
                    phoneController.text =
                        userDoc['contact'] ?? 'Update contact info...';
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            'First Name',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          subtitle: TextFormField(
                            controller: fNameController,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            'Last Name',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          subtitle: TextFormField(
                            controller: lNameController,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            'First Name',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          subtitle: TextFormField(
                            controller: emailController,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            'Phone number',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          subtitle: TextFormField(
                            controller: phoneController,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60)),
              onPressed: () async {
                final docUpdate = {
                  'first-name': fNameController.text,
                  'last-name': lNameController.text,
                  'email': emailController.text,
                  'contact': phoneController.text,
                };
                setState(() {
                  btnChild = const CircularProgressIndicator(
                    color: Colors.white70,
                  );
                });
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .update(docUpdate);
                if (mounted) {
                  setState(() {
                    btnChild = const Text('Update Profile');
                  });
                }
              },
              child: btnChild,
            ),
          ],
        ),
      ),
    );
  }
}
