import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotalk/authentication/repository/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/chat_bubble.dart';

class DojjoBot extends StatefulWidget {
  const DojjoBot({super.key});

  @override
  State<DojjoBot> createState() => _DojjoBotState();
}

class _DojjoBotState extends State<DojjoBot> {
  final textController = TextEditingController();
  List tempTexts = [];
  final currentUser = FirebaseAuth.instance.currentUser!;
  final store = FirebaseFirestore.instance;
  final repo = FireStoreRepo();

  String getResponseForRequest(String request) {
    switch (request.toLowerCase()) {
      case 'hey':
        return 'Hello there! How can I help you?';
      case 'how are you?':
        return 'I am fine, thank you. How are you?';
      case 'i\'m fine':
      case 'i\'m good':
      case 'i\'m great':
      case 'amazing':
      case 'awesome':
      case 'by grace':
        return 'Good to know!';
      case 'hi':
      case 'hello':
      case 'how are you':
        return 'Hello! How can I assist you today?';
      case 'product information':
        return 'Sure, I can provide information about our products. What are you interested in?';
      case 'pricing':
        return 'Our pricing varies based on the product. Could you please specify which product you\'re asking about?';
      case 'features':
        return 'Our products come with a range of features. Could you let me know which product you\'re interested in?';
      case 'order status':
        return 'To check your order status, please provide your order number.';
      case 'order tracking':
        return 'You can track your order by entering the order number on our website.';
      case 'shipping time':
        return 'Shipping times depend on your location and the selected shipping method. Do you have an order number?';
      case 'returns':
        return 'For returns, please visit our Returns and Refunds page on our website.';
      case 'exchange':
        return 'Exchanges can be requested within 30 days of purchase. Please provide your order number.';
      case 'refund process':
        return 'Refunds are typically processed within 5-10 business days after receiving the returned item.';
      case 'payment methods':
        return 'We accept credit/debit cards and PayPal as payment methods.';
      case 'contact information':
        return 'You can reach our customer support at support@example.com.';
      case 'hours of operation':
        return 'Our customer support is available Monday to Friday, 9 AM - 6 PM.';
      case 'tech support':
        return 'For technical assistance, please provide more details about the issue you\'re facing.';
      case 'password reset':
        return 'To reset your password, visit our password reset page and follow the instructions.';
      case 'login issues':
        return 'If you\'re having trouble logging in, please ensure you\'re using the correct credentials.';
      case 'thanks':
        return 'You\'re welcome! If you have more questions, feel free to ask.';
      case 'goodbye':
        return 'Goodbye! Have a great day!';
      case 'how do i change my email?':
        return 'You can change your email by going to the account settings page and clicking on the email field.';
      case 'how do i start an issue?':
        return 'Tap on one of the available agents profile icon on the Home screen to start an issue.';
      case 'how many issues can i create?':
        return 'You can create as many issues as you want.';
      case 'how do i change my password?':
        return 'You can change your password by going to the settings page and clicking on the password field.';
      case 'how do i change my phone number?':
        return 'You can change your phone number by going to the settings page and clicking on the phone number field.';
      default:
        return 'Sorry, I don\'t have information about that. Contact our abled agents for more help.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          children: [
            Text('Dojjo'),
            Text(
              'Online',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: const [Icon(Icons.more_vert_rounded)],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('dojjobot')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No texts yet'),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // no errors
          List tempList = snapshot.data!.data()!['texts'];
          List textList = [];
          for (var element in tempList) {
            textList.add(element['user']);
            textList.add(element['bot']);
          }
          
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 55, top: 10),
                child: ListView.separated(
                  itemCount: textList.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: index % 2 == 1
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: ChatBubble(
                        text: textList[index]!,
                        source: index % 2 == 1
                            ? ''
                            : FirebaseAuth.instance.currentUser!.uid,
                      ),
                    );
                  },
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
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file_rounded),
                      ),
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          controller: textController,
                          decoration: const InputDecoration(
                            focusedBorder: InputBorder.none,
                            hintText: 'Message',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (textController.text.isNotEmpty) {
                            // ignore: no_leading_underscores_for_local_identifiers
                            final _data = {
                              'user': textController.text,
                              'bot': getResponseForRequest(textController.text)
                            };
                            // add user text and bot's response to firestore
                            await store
                                .collection('dojjobot')
                                .doc(currentUser.uid)
                                .update({
                              'texts': FieldValue.arrayUnion([_data])
                            });
                            textController.clear();
                          }
                          // ignore: avoid_print
                          print(
                              snapshot.data?.data()?['texts'] as List<dynamic>);
                        },
                        icon: const Icon(Icons.send_rounded),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
