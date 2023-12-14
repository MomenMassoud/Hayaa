import 'package:flutter/material.dart';
import 'package:hayaa_main/features/auth/choice%20between%20registration%20and%20login/widgets/social_method_button.dart';
import 'package:hayaa_main/features/home/views/home_view.dart';
import '../../../../core/Utils/app_colors.dart';
import '../../../../core/Utils/app_images.dart';
import '../../../splash/widgets/circular_gradiant_opacity_container.dart';
import '../../../splash/widgets/gradient_container.dart';
import '../../login/views/login_view.dart';
import '../../sinup/view/signup_view.dart';
import '../../sinup/widget/auth_service_google.dart';
import '../views/privacy_terms_view.dart';
import '../views/user_agreement_view.dart';
import 'gradiant_button.dart';
import 'package:easy_localization/easy_localization.dart';

import 'navigator_text.dart';

class ChoiceBetweenRegistrationAndLoginBody extends StatelessWidget {
  const ChoiceBetweenRegistrationAndLoginBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GradientContainer(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            colorOne: AppColors.appPrimaryColors800,
            colorTwo: AppColors.appPrimaryColors400,
          ),
          CircularGradiantOpacityContainer(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            hightRatio: 0.5,
            widthRatio: 1,
            colorOne: Colors.white,
            colorTwo: Colors.white,
            colorOneOpacity: 0.22,
            colorTwoOpacity: 0,
            radius: 0.5,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GradiantButton(
                  buttonRatio: 0.8,
                  onPressed: () {

                    Navigator.pushReplacementNamed(
                        context, LoginView.id);
                  },
                  screenWidth: screenWidth,
                  buttonLabel: "تسجيل الدخول".tr(args: ["تسجيل الدخول"]),
                ),
                const SizedBox(
                  height: 30,
                ),
                GradiantButton(
                  buttonRatio: 0.8,
                  onPressed: () {
                    Navigator.pushNamed(context, SignupView.id);
                  },
                  screenWidth: screenWidth,
                  buttonLabel: "تسجيل".tr(args: ["تسجيل"]),
                ),
                const SizedBox(
                  height: 30,
                ),
                 Text(
                  "التسجيل بأستخدام",
                  style: TextStyle(
                    fontFamily: "Questv1",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ).tr(args: ["التسجيل بأستخدام"]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialMethodButton(
                        screenWidth: screenWidth,
                        socialLogo: AppImages.googlePLogo,
                        onTap: () async{
                          await AuthServiceGoogle().signInWithGoogle();
                          Navigator.pushNamed(context, HomeView.id);
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    SocialMethodButton(
                        screenWidth: screenWidth,
                        socialLogo: AppImages.fbLogo,
                        onTap: () {}),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NavigatorText(
                      content: "إتفاقيه المستخدم".tr(args: ["إتفاقيه المستخدم"]),
                      onTap: () {
                        Navigator.pushNamed(context, UserAgreementView.id);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "|",
                      style: TextStyle(
                        fontFamily: "Questv1",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NavigatorText(
                      content: "شروط الخصوصية".tr(args: ["شروط الخصوصية"]),
                      onTap: () {
                        Navigator.pushNamed(context, PrivacyTermsView.id);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
