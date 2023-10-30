import 'package:flutter/material.dart';
import 'package:iconnect2/Games/Snake/home_snake.dart';
class SnakeMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnakeGameFlutter',
      debugShowCheckedModeBanner: false,
      home: HomeScreenSnake(),
    );
  }
}