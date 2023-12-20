import 'package:cached_network_image/cached_network_image.dart';
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
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: images.length,
        itemBuilder:(context, index, realIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0,left: 8.0),
            child: Container(
              height: 100,
              width: 700,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(images[index]),
                  fit: BoxFit.cover
                )
              ),
            ),
          );
        },
        options: CarouselOptions(
            autoPlayAnimationDuration: Duration(seconds: 1),
            autoPlayCurve: Curves.linear,
            autoPlay: true
        ),
    );
  }
}

