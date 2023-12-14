import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../../core/Utils/app_colors.dart';
import '../../../../core/Utils/app_images.dart';
import '../../../home/views/home_view.dart';
import '../../../splash/widgets/gradient_container.dart';
import '../../choice between registration and login/views/privacy_terms_view.dart';
import '../../choice between registration and login/views/user_agreement_view.dart';
import '../../choice between registration and login/widgets/gradiant_button.dart';
import '../../choice between registration and login/widgets/navigator_text.dart';
import '../views/password_recovery.dart';
import 'custom_text_form_field.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({
    super.key,
  });

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String phoneNum;
  late String password;

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
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                AppImages.waterMarkImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.45,
                  child: Image.asset(AppImages.appPLogo),
                ),
                const SizedBox(
                  height: 40,
                ),
                 Text(
                  "أهلا ضيفنا",
                  style: TextStyle(
                    fontFamily: "Hayah",
                    color: Colors.white,
                    fontSize: 80,
                  ),
                ).tr(args: ["أهلا ضيفنا"]),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFormField(
                            screenWidth: screenWidth,
                            autovalidateMode: autovalidateMode,
                            fieldIcon: const Icon(
                              Icons.contact_phone_outlined,
                            ),
                            fielldRatio: 0.8,
                            hintText: "رقم الهاتف".tr(args: ['رقم الهاتف']),
                            onSaved: (value) {
                              phoneNum = value!;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        screenWidth: screenWidth,
                        autovalidateMode: autovalidateMode,
                        fieldIcon: const Icon(
                          Icons.verified_user_outlined,
                        ),
                        fielldRatio: 0.8,
                        hintText: "كلمة المرور".tr(args: ['كلمة المرور']),
                        onSaved: (value) {
                          password = value!;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GradiantButton(
                          screenWidth: screenWidth,
                          buttonLabel: "تسجيل الدخول".tr(args: ["تسجيل الدخول"]),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, HomeView.id);
                          },
                          buttonRatio: 0.6),
                      const SizedBox(
                        height: 10,
                      ),
                      NavigatorText(
                        content: "لقد نسيت كلمة المرور ؟".tr(args: ['لقد نسيت كلمة المرور ؟']),
                        onTap: () {
                          Navigator.pushNamed(context, PasswordRecoveryView.id);
                        },
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NavigatorText(
                            content: "إتفاقيه المستخدم".tr(args: ['إتفاقيه المستخدم']),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, UserAgreementView.id);
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
                            content: "شروط الخصوصية".tr(args: ['شروط الخصوصية']),
                            onTap: () {
                              Navigator.pushNamed(context, PrivacyTermsView.id);
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
