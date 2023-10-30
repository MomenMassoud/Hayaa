import 'package:flutter/material.dart';

import 'game_page.dart';

class HomeScreenSnake extends StatefulWidget{
  _HomeScreenSnake createState()=>_HomeScreenSnake();
}

class _HomeScreenSnake extends State<HomeScreenSnake>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/snake_game.jpg'),

              SizedBox(height: 50.0),

              Text('Welcome to SnakeGameFlutter', style: TextStyle(color: Colors.white, fontSize: 40.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold), textAlign: TextAlign.center),

              SizedBox(height: 50.0),
              IconButton(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GamePage()));
                  },
                  icon: Icon(Icons.play_circle_filled, color: Colors.white, size: 30.0),
              )
            ],
          ),
        )
    );
  }

}