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
      itemBuilder: (context, index, realIndex) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(images[index]),
              fit: BoxFit.cover, // Use BoxFit.cover to make the image cover the full width
            ),
          ),
        );
      },
      options: CarouselOptions(
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.linear,
        autoPlay: true,
        aspectRatio: 16 / 5, // Adjust aspectRatio based on your preference
        pageSnapping: true,
        padEnds: true,
          viewportFraction: 1.0
      ),
    );
  }
}
