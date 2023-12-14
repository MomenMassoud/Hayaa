import 'package:flutter/material.dart';

class SocialMethodButton extends StatelessWidget {
  const SocialMethodButton({
    super.key,
    required this.screenWidth,
    required this.socialLogo,
    required this.onTap,
  });

  final double screenWidth;
  final String socialLogo;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: screenWidth * 0.15,
        child: Image(image: AssetImage(socialLogo)),
      ),
    );
  }
}
