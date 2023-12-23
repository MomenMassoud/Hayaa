import 'package:flutter/material.dart';
import '../models/badge_model.dart';

class BadgesListItem extends StatelessWidget {
  const BadgesListItem({
    super.key,
    required this.screenWidth,
    required this.badgeModel,
    required this.opacity,
    required this.bgImage,
  });

  final double screenWidth;
  final BadgeModel badgeModel;
  final double opacity;
  final String bgImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[700],
      child: BadgeInfo(
          bgImage: bgImage,
          screenWidth: screenWidth,
          opacity: opacity,
          badgeModel: badgeModel),
    );
  }
}

class BadgeInfo extends StatelessWidget {
  const BadgeInfo({
    super.key,
    required this.screenWidth,
    required this.opacity,
    required this.badgeModel,
    required this.bgImage,
  });

  final double screenWidth;
  final double opacity;
  final BadgeModel badgeModel;
  final String bgImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
            opacity: 0.5,
            child: SizedBox(
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                child: Image(image: AssetImage(bgImage)))),
        Column(
          children: [
            SizedBox(
              width: screenWidth * 0.35,
              height: screenWidth * 0.35,
              child: Opacity(
                  opacity: opacity,
                  child: Image(image: AssetImage(badgeModel.badgeImage))),
            ),
            Text(
              badgeModel.badgeName,
              style: TextStyle(
                  color: Colors.brown[100], fontWeight: FontWeight.w600),
            )
          ],
        ),
      ],
    );
  }
}
