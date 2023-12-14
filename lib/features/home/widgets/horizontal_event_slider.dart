import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HorizontalEventSlider extends StatelessWidget {
  const HorizontalEventSlider({
    super.key,
    required this.screenHight,
    required this.screenWidth,
    required this.images,
  });

  final double screenHight;
  final double screenWidth;
  final List images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: screenHight * 0.2,
        width: screenWidth,
        child: CarouselSlider(
          // images: images,
          // indicatorBgPadding: 0,
          // dotColor: Colors.blueGrey,
          // dotBgColor: Colors.black.withOpacity(0),
          // animationCurve: Curves.linear,
          // dotSize: 6,
          // dotSpacing: 10,
          // dotIncreaseSize: 1.5,
          // dotVerticalPadding: 20,
          options: CarouselOptions(),
          items: images.map((item){
            return Builder(
              builder: (BuildContext context) {
                return item;
              },
            );
          }).toList(),
        ));
  }
}
