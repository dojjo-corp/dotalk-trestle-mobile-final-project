// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class RoundProfile extends StatelessWidget {
  const RoundProfile({
    super.key,
    required this.agentName,
  });
  final String agentName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Icon(
            color: Theme.of(context).primaryColor,
            Icons.person,
            size: 40,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          agentName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
