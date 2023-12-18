import 'package:flutter/material.dart';

class SeperatedText extends StatelessWidget {
  const SeperatedText({
    super.key,
    required this.tOne,
    required this.tTwo,
  });
  final String tOne;
  final String tTwo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
              text: tOne,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        RichText(
          text: TextSpan(
              text: tTwo,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
