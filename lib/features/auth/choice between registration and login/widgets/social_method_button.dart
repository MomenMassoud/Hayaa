import 'package:flutter/material.dart';

class SocialMethodButton extends StatelessWidget {
  const SocialMethodButton({
    super.key,
    required this.screenWidth,
    required this.socialLogo,
    required this.onTap,
    required this.socialName,
  });

  final double screenWidth;
  final String socialLogo;
  final String socialName;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: screenWidth * 0.15,
            child: Image(image: AssetImage(socialLogo)),
          ),
        ),
        Text(
          " Login With $socialName",
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
