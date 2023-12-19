import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';

import '../../model/group_rand_card.dart';
class TopCard extends StatelessWidget {
  const TopCard({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.cardModel,
    required this.coin,
    required this.coinPic,
  });

  final double screenHeight;
  final String coin;
  final bool coinPic;
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
                image:CachedNetworkImageProvider(cardModel.userImge),
              ),
            ),
          ),
        ),
        Positioned(
          top: 91,
          child: Text(cardModel.rating,
              style: TextStyle(
                color: cardModel.ratingColor ?? Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
        ),
        Positioned(
          top: 200,
          child: Column(
            children: [
              Text(cardModel.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(coin,
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(width: 10,),
                  CircleAvatar(
                    backgroundImage: coinPic?AssetImage(AppImages.gold_coin):AssetImage(AppImages.daimond),
                    radius: 10,

                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}