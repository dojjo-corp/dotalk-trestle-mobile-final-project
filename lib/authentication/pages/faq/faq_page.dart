import 'package:flutter/material.dart';

import 'faq_financial.dart';
import 'faq_general.dart';
import 'faq_network.dart';
import 'faq_personal_acount.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key, required this.route});
  final String route;

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final Map<String, Widget> _widgetsToShow = {
    'general':  const FaqGeneral(),
    'personal': const FaqPersonal(),
    'network': const FaqNetwork(),
    'financial': const FaqFinancial(),
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:25.0),
        child: _widgetsToShow[widget.route],
      ),
    );
  }
}
