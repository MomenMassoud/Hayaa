import 'package:flutter/material.dart';

class CircularGradiantOpacityContainer extends StatelessWidget {
  const CircularGradiantOpacityContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.hightRatio,
    required this.widthRatio,
    required this.colorOne,
    required this.colorTwo,
    required this.colorOneOpacity,
    required this.colorTwoOpacity,
    required this.radius,
  });

  final double screenHeight;
  final double screenWidth;
  final double hightRatio;
  final double widthRatio;

  final Color colorOne;
  final Color colorTwo;

  final double colorOneOpacity;
  final double colorTwoOpacity;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * hightRatio,
      width: screenWidth * widthRatio,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colorOne.withOpacity(colorOneOpacity),
            colorTwo.withOpacity(colorTwoOpacity)
          ],
          stops: const [0.0, 1.0],
          center: Alignment.center,
          radius: radius,
          tileMode: TileMode.decal,
        ),
      ),
    );
  }
}
