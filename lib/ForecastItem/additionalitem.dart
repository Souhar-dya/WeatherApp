import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  const AdditionalInfo(
      {super.key,
      required this.icon1,
      required this.text1,
      required this.text2});
  final IconData icon1;
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon1,
          size: 45,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          text1,
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        Text(
          text2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )
      ],
    );
  }
}
