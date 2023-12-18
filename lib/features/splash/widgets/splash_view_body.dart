import 'package:flutter/material.dart';

import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
import 'circular_gradiant_opacity_container.dart';
import 'gradient_container.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    faddingAnimation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
        GradientContainer(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          colorOne: AppColors.appMainColor,
          colorTwo: AppColors.app2MainColor,
        ),
        SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Opacity(
            opacity: 0.4,
            child: Image.asset(
              AppImages.splashViewImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.35,
              ),
              CircularGradiantOpacityContainer(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                hightRatio: 0.45,
                widthRatio: 0.65,
                colorOne: AppColors.app3MainColor,
                colorTwo: AppColors.app3MainColor,
                colorOneOpacity: 0.5,
                colorTwoOpacity: 0,
                radius: 0.46,
              )
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.55,
              ),
              SizedBox(
                width: screenWidth * 0.55,
                child: Opacity(
                    opacity: animationController.value,
                    child: Image.asset(AppImages.appPLogo)),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.4,
              ),
              CircularGradiantOpacityContainer(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                hightRatio: 0.45,
                widthRatio: 0.65,
                colorOne: Colors.white,
                colorTwo: Colors.white,
                colorOneOpacity: 0.1,
                colorTwoOpacity: 0,
                radius: 0.3,
              )
            ],
          ),
        ),
      ]),
    );
  }

  void faddingAnimation() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    animationController.addListener(() {
      setState(() {});
    });
    animationController.forward();
    animationController.repeat(reverse: true);
  }
}
