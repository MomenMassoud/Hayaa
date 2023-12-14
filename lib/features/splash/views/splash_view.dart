import 'package:flutter/material.dart';

import '../functions/delay_and_navigate.dart';
import '../widgets/splash_view_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const id = 'splashview';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    delayAndNavigate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashViewBody();
  }

}
