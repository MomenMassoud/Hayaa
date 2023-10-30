import 'package:flutter/material.dart';
import '../../Custom_Wedgit/my_button.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  static const String ScreenRoute = 'main_screen';
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange, // Set the background color to blue
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage("assets/logo2.jpg"),
                ),
                Text(
                  'Bibgo',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontFamily: "Signatra",
                  ),
                )
              ],
            ),
            MyButton(
              color: Colors.blue[900]!,
              title: 'ابداء',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.ScreenRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
