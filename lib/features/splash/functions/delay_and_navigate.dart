import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/views/home_view.dart';
import '../../auth/choice between registration and login/views/choice_between_registration_and_login_view.dart';

void delayAndNavigate(BuildContext context) {
  Future.delayed(const Duration(seconds: 4)).then((value) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Navigator.pushReplacementNamed(context, HomeView.id);
    } else {
      Navigator.pushReplacementNamed(
          context, ChoiceBetweenRegistrationAndLogin.id);
    }
  });
}
