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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "جينيس",
                      style: TextStyle(
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: 18),
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "الفعاليات",
                      style: TextStyle(
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: 18),
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "العائلة",
                      style: TextStyle(
                          fontFamily: 'Questv1',
                          color: Colors.white,
                          fontSize: 18),
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
