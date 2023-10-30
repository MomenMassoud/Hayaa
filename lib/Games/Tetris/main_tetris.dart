import 'package:flutter/material.dart';
import 'package:iconnect2/Games/Tetris/tetris.dart';


class MainTetris extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(brightness: Brightness.dark).copyWith(
      scaffoldBackgroundColor: Colors.black,
      dividerColor: const Color(0xFF2F2F2F),
      dividerTheme: const DividerThemeData(thickness: 10),
      textTheme: const TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home: const Tetris(),
  );
}