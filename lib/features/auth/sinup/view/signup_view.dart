import 'package:flutter/material.dart';
import '../widget/signup_view_body.dart';

class SignupView extends StatefulWidget{
  const SignupView({super.key});
  static const id = 'SignupView';
  _SignupView createState()=>_SignupView();
}

class _SignupView extends State<SignupView>{
  @override
  Widget build(BuildContext context) {
    return SignupViewBody();
  }

}