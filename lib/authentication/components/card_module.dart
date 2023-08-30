import 'package:flutter/material.dart';

import '../pages/faq/faq_page.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.icon,
    required this.heading,
    required this.intro,
    required this.backgroudColor,
    required this.faqWidget,
  });
  final Icon icon;
  final String heading;
  final String intro;
  final Color? backgroudColor;
  final String faqWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ignore: avoid_print
        print('card clicked');
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FaqPage(route: faqWidget)));
      },
      child: Container(
        constraints: const BoxConstraints.tightFor(width: 150),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: backgroudColor),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(
              heading,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              intro,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                overflow: TextOverflow.fade,
              ),
              maxLines: 3,
              softWrap: true,
            )
          ],
        ),
      ),
    );
  }
}
