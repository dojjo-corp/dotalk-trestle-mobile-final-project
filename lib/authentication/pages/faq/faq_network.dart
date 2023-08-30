import 'package:flutter/material.dart';

class FaqNetwork extends StatelessWidget {
  const FaqNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Card(
          child: ExpansionTile(
            title: Text('General 00'),
            children: [
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text('General 01'),
            children: [
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text('General 02'),
            children: [
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            title: Text('General 03'),
            children: [
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
              Text(
                  'Esse ullamco veniam duis dolor non incididunt duis elit magna.'),
            ],
          ),
        ),
      ],
    );
  }
}