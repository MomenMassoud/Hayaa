import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import 'gradient_rounded_container.dart';

class SubScreensSection extends StatelessWidget {
  const SubScreensSection({
    super.key,
    required this.screenHight,
    required this.screenWidth,
  });

  final double screenHight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientRoundedContainer(
                  screenHeight: screenHight * 0.08,
                  screenWidth: screenWidth * 0.3,
                  colorOne: Colors.indigo,
                  colorTwo: Colors.green),
              Row(
                children: [
                  SizedBox(
                      width: screenWidth * 0.1,
                      child: const Image(image: AssetImage(AppImages.trophy))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "جينيس",
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: screenHight * 0.017),
                    ).tr(args: ['جينيس']),
                  )
                ],
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientRoundedContainer(
                  screenHeight: screenHight * 0.08,
                  screenWidth: screenWidth * 0.3,
                  colorOne: Colors.orange,
                  colorTwo: Colors.deepOrange),
              Row(
                children: [
                  SizedBox(
                      width: screenWidth * 0.1,
                      child:
                      const Image(image: AssetImage(AppImages.megaPhone))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "الفعاليات",
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: screenHight * 0.018),
                    ).tr(args: ['الفعاليات']),
                  )
                ],
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              GradientRoundedContainer(
                  screenHeight: screenHight * 0.08,
                  screenWidth: screenWidth * 0.3,
                  colorOne: Colors.purple,
                  colorTwo: Colors.pink),
              Row(
                children: [
                  SizedBox(
                      width: screenWidth * 0.1,
                      child: const Image(image: AssetImage(AppImages.badge))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "العائلة",
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: screenHight * 0.018),
                    ).tr(args: ['العائلة']),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
