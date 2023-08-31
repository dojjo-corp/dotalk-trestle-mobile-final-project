// to be used later in determining dashboard to user based on user type

import 'package:dotalk/authentication/components/overview_card.dart';
import 'package:flutter/material.dart';

class AgentOverview extends StatelessWidget {
  const AgentOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: [
        Text(
          'Issues Overview',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blueGrey[200],
          ),
          child: const Column(children: [
            OverviewCard(
              category: 'General',
              numberOfIssues: 1,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            SizedBox(height: 20),
            OverviewCard(
              category: 'General',
              numberOfIssues: 1,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            SizedBox(height: 20),
            OverviewCard(
              category: 'Payment & Billing',
              numberOfIssues: 1,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            SizedBox(height: 20),
            OverviewCard(
              category: 'Network',
              numberOfIssues: 1,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            SizedBox(height: 20),
            OverviewCard(
              category: 'Product Information',
              numberOfIssues: 1,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purpleAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            SizedBox(height: 30),
          ]),
        )
      ]),
    );
  }
}
