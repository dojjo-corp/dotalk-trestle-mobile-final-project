import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    super.key,
    required this.category,
    required this.numberOfIssues,
    required this.gradient,
  });

  final Gradient gradient;
  final String category;
  final int numberOfIssues;

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          
        ],
      ),
    );
  }
}
