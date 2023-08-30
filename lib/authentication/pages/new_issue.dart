import 'package:flutter/material.dart';

class CreateIssue extends StatelessWidget {
  const CreateIssue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an issue'),
      ),
      body: const Center(
        child: Text(
          'Create A New Issue Here!',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
