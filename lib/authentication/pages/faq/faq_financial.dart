import 'package:flutter/material.dart';

class FaqFinancial extends StatelessWidget {
  const FaqFinancial({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ExpansionTile(
          title: Text('Financial 00'),
          children: [
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
          ],
        ),
        ExpansionTile(
          title: Text('Financial 01'),
          children: [
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
          ],
        ),
        ExpansionTile(
          title: Text('Financial 02'),
          children: [
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
          ],
        ),
        ExpansionTile(
          title: Text('Financial 03'),
          children: [
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            Text('Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
          ],
        ),
      ],
    );
  }
}