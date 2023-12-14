import 'package:flutter/material.dart';

class GradientRoundedContainer extends StatelessWidget {
  const GradientRoundedContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.colorOne,
    required this.colorTwo,
  });

  final double screenHeight;
  final double screenWidth;

  final Color colorOne;
  final Color colorTwo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          colors: [colorOne, colorTwo],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
