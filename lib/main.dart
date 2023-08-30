import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/models/dojjo_bot.dart';
import 'package:dotalk/authentication/pages/about_us.dart';
// import 'package:dotalk/authentication/pages/faq_tab_page.dart';
import 'package:dotalk/authentication/pages/register.dart';
import 'package:dotalk/authentication/pages/settings/notifications.dart';
import 'package:dotalk/authentication/providers/issues_provider.dart';
import 'package:dotalk/global/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/components/drawer.dart';
import 'authentication/pages/account.dart';
import 'authentication/pages/faq/faq_page.dart';
import 'authentication/pages/privacy_page.dart';
import 'authentication/pages/settings/linked_apps.dart';
import 'authentication/pages/settings/privacy.dart';
import 'authentication/pages/settings/security.dart';
import 'firebase_options.dart';
import 'global/chat.dart';
import 'authentication/pages/dashboard.dart';
import 'authentication/pages/issues.dart';
import 'authentication/pages/login.dart';
import 'authentication/pages/settings/settings.dart';
import 'authentication/providers/agent_provider.dart';
import 'authentication/providers/auth_provider.dart';
import 'authentication/providers/theme_provider.dart';
import 'authentication/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AgentProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => IssueProvider()),
      StreamProvider<QuerySnapshot?>(
        create: (_) =>
            FirebaseFirestore.instance.collection('users').snapshots(),
        initialData: null,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context).currentTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData,
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/homepage': (context) => MyHomePage(),
        '/dashboard': (context) => const DashBoard(),
        '/account': (context) => const UserAccount(),
        '/settings': (context) => const AppSettings(),
        '/aboutUs': (context) => const AboutUs(),
        '/privacy': (context) => const MyPrivacyPage(),
        '/settings/notifications': (context) => const NotificationSettings(),
        '/settings/security': (context) => const SecuritySettings(),
        '/settings/privacy': (context) => const PrivacySettings(),
        '/settings/apps': (context) => const LinkedAppsSettings(),
        '/dojjobot': (context) => const DojjoBot(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;
        final routeName = settings.name;
        if (routeName == '/faq') {
          return MaterialPageRoute(
              builder: (context) => FaqPage(route: args['route']));
        } else if (routeName == '/chat') {
          return MaterialPageRoute(
              builder: (context) => ChatScreen(issueId: args['issueId']));
        } else {
          return null;
        }
      },
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
    this.selectedIndex = 0,
  });

  int selectedIndex;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _pages = [
    const DashBoard(),
    const UserIssues(),
    // const FaqTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    void changePageIndex(int index) {
      setState(() {
        widget.selectedIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton.outlined(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserAccount()));
            },
            style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: Colors.white),
          child: GNav(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            mainAxisAlignment: MainAxisAlignment.center,
            selectedIndex: widget.selectedIndex,
            onTabChange: changePageIndex,
            // tabBackgroundColor: Colors.grey[800]!,
            color: Colors.grey[600],
            activeColor: Theme.of(context).primaryColor,
            tabMargin: const EdgeInsets.symmetric(vertical: 10),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home', gap: 8),
              GButton(icon: Icons.dashboard, text: 'Issues', gap: 8),
              // GButton(
              //     icon: Icons.question_answer_rounded, text: 'FAQs', gap: 8),
              // GButton(icon: Icons.person, text: 'Account', gap: 8),
              // GButton(icon: Icons.settings, text: 'Settings', gap: 8),
            ],
          ),
        ),
      ),
      body: _pages[widget.selectedIndex],

      // floatingActionButton: IconButton.filled(onPressed: () {}, icon: const Icon(Icons.add), iconSize: 35),
    );
  }
}
