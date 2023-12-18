import 'package:flutter/material.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({
    super.key,
    required this.screenWidth,
    this.onTap,
  });

  final double screenWidth;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenWidth * 0.3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        ),
        child: Center(
          child: Icon(
            Icons.add_a_photo_outlined,
            size: screenWidth * 0.1,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
