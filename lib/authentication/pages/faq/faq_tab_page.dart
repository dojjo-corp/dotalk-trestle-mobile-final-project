import 'package:flutter/material.dart';

import '../../components/card_module.dart';

class FaqTabPage extends StatefulWidget {
  const FaqTabPage({super.key});

  @override
  State<FaqTabPage> createState() => _FaqTabPageState();
}

class _FaqTabPageState extends State<FaqTabPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        children: const [
          Text('Frequently Asked Questions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              )),
          SizedBox(height: 20),
          Row(
            children: [
              MyCard(
                icon: Icon(Icons.groups_2_rounded),
                heading: 'General',
                intro:
                    'Voluptate ad tempor minim ex ex aliquip voluptate sit minim reprehenderit occaecat id.',
                backgroudColor: Color(0x0ffa339b),
                faqWidget: 'general',
              ),
              SizedBox(width: 20),
              MyCard(
                icon: Icon(Icons.network_cell_rounded),
                heading: 'Network',
                intro:
                    'Voluptate ad tempor minim ex ex aliquip voluptate sit minim reprehenderit occaecat id.',
                backgroudColor: Color.fromARGB(255, 250, 233, 218),
                faqWidget: 'network',
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              MyCard(
                icon: Icon(Icons.person),
                heading: 'Personal',
                intro:
                    'Voluptate ad tempor minim ex ex aliquip voluptate sit minim reprehenderit occaecat id.',
                backgroudColor: Color(0xFFE1DCD9),
                faqWidget: 'personal',
              ),
              SizedBox(width: 20),
              MyCard(
                icon: Icon(Icons.currency_exchange),
                heading: 'Financial',
                intro:
                    'Voluptate ad tempor minim ex ex aliquip voluptate sit minim reprehenderit occaecat id.',
                backgroudColor: Color.fromARGB(255, 231, 231, 198),
                faqWidget: 'financial',
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              MyCard(
                icon: Icon(Icons.person),
                heading: 'Personal',
                intro:
                    'Voluptate ad tempor minim ex ex aliquip voluptate sit minim reprehenderit occaecat id.',
                backgroudColor: Color(0xFFE1DCD9),
                faqWidget: 'personal',
              ),
              SizedBox(width: 20),
              MyCard(
                icon: Icon(Icons.currency_exchange),
                heading: 'Financial',
                intro:
                    'Voluptate ad tempor minim ex ex aliquip voluptate sit minim reprehenderit occaecat id.',
                backgroudColor: Color.fromARGB(255, 231, 231, 198),
                faqWidget: 'financial',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
