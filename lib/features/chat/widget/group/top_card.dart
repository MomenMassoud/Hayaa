import 'package:flutter/material.dart';

import '../../model/group_rand_card.dart';
class TopCard extends StatelessWidget {
  const TopCard({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.cardModel,
  });

  final double screenHeight;
  final double screenWidth;
  final GroupRandCard cardModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Card(
          color: Colors.black.withOpacity(0),
          borderOnForeground: false,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(cardModel.cardImge), fit: BoxFit.fill)),
            height: screenHeight * 0.2,
            width: screenWidth * 0.28,
          ),
        ),
        Positioned(
          top: -40,
          child: Container(
            height: screenWidth * 0.25,
            width: screenWidth * 0.25,
            // color: Colors.yellow,
            decoration: BoxDecoration(
              border: Border.all(color: cardModel.strokColor, width: 3),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(cardModel.userImge),
              ),
            ),
          ),
        ),
        Positioned(
          top: 75,
          child: Text(cardModel.rating,
              style: TextStyle(
                color: cardModel.ratingColor ?? Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
        ),
        Positioned(
          top: 110,
          child: Text(cardModel.userName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }
}