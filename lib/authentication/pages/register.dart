// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final store = FirebaseFirestore.instance;
  bool _obscureText = true;
  bool _obscureConfirm = true;

  String selectedType = 'client';
  final userTypes = ['client', 'agent'];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: true,
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Icon(Icons.waving_hand_rounded, size: 120),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join us',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Enter your credentials to proceed',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                  key: _key,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: fNameController,
                              decoration: InputDecoration(
                                label: const Text('First name'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter first name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: lNameController,
                              decoration: InputDecoration(
                                label: const Text('Last name'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter last name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email address';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Select account type',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.grey[600]!)),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  isExpanded: true,
                                  // elevation: 0,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                  value: selectedType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedType = value!;
                                    });
                                  },
                                  items: userTypes
                                      .map((String type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          ))
                                      .toList()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: passwordController,
                              autocorrect: false,
                              enableSuggestions: false,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                  label: const Text('Password'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: _obscureText
                                        ? const Icon(Icons.visibility, size: 20)
                                        : const Icon(Icons.visibility_off, size: 20),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter password';
                                } else if (value.length < 6) {
                                  return 'not less than 6 characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: passwordConfirmController,
                              autocorrect: false,
                              enableSuggestions: false,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                  label: const Text('Confirm password'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureConfirm = !_obscureConfirm;
                                      });
                                    },
                                    child: _obscureText
                                        ? const Icon(Icons.visibility, size: 20,)
                                        : const Icon(Icons.visibility_off, size: 20),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'field can\'t be empty';
                                }
                                if (value != passwordController.text) {
                                  return 'passwords do not match';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.blueGrey[800],
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (_key.currentState!.validate() &&
                                await authProvider.register(
                                      fName: fNameController.text,
                                      lName: lNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      type: selectedType,
                                    ) !=
                                    null) {
                              // userProvider.setCurrentUser(store.doc('users').collection(selectedType).doc());
                              Navigator.of(context).pushNamed('/homepage');
                            }
                          },
                          child: const Text('Register')),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                text: 'Already having an account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text: 'Login',
                                style: TextStyle(color: Colors.blueGrey[600]))
                          ]),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
