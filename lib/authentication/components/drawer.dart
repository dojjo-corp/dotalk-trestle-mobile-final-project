import 'package:dotalk/authentication/pages/login.dart';
import 'package:dotalk/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const UserAccountsDrawerHeader(
                    accountEmail: Text('null'),
                    accountName: Text('null'),
                  );
                }
                return UserAccountsDrawerHeader(
                  margin: EdgeInsets.zero,
                  accountName: Text(user!.displayName!),
                  accountEmail: Text(user!.email!),
                  currentAccountPicture: CircleAvatar(
                      child: Image.asset('assets/video-calling.png')),
                );
              }),
          Expanded(
            child: SizedBox(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyHomePage()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.home_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Home'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed('/account');
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.person_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Account'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                selectedIndex: 1,
                              )));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.message_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Issues'),
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed('/settings');
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.settings_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Settings'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed('/privacy');
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.privacy_tip_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Privacy'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popAndPushNamed('/aboutUs');
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.info_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('About Us'),
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (route) => false);
                        await FirebaseAuth.instance.signOut();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: const Text('Sign out'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
