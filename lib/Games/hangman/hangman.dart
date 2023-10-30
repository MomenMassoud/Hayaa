import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iconnect2/Games/hangman/ui/colors.dart';
import 'package:iconnect2/Games/hangman/ui/widget/figure_image.dart';
import 'package:iconnect2/Games/hangman/ui/widget/letter.dart';
import 'package:iconnect2/Games/hangman/utils/game.dart';

class Hangman extends StatefulWidget{
  _Hangman createState()=>_Hangman();
}

class _Hangman extends State<Hangman>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInpu();
    int ran=Random(). nextInt(secretwords.length);
    setState(() {
      word=secretwords[ran].toUpperCase();
    });
  }
  //choosing the game word
  String word = "Flutter".toUpperCase();
  List<String> secretwords=[
    "Flutter",
    "Web",
    "Egypt",
    "Sonic",
    "SpiderMan",
    "SuperMan",
    "Cairo",
    "Samsung",
    "Iphone",
    "Windows"
  ];
  List<Widget> inp=[];
  void setInpu(){
    setState(() {
      inp=word
          .split('')
          .map((e) => letter(e.toUpperCase(),
          !Game.selectedChar.contains(e.toUpperCase())))
          .toList();
    });
  }
  //Create a list that contains the Alphabet, or you can just copy and paste it
  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text("Hangman"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                //let's make the figure widget
                //let's add the images to the asset folder
                //Okey now we will create a Game class
                //Now the figure will be built according to the number of tries
                figureImage(Game.tries >= 0, "assets/hang.png"),
                figureImage(Game.tries >= 1, "assets/head.png"),
                figureImage(Game.tries >= 2, "assets/body.png"),
                figureImage(Game.tries >= 3, "assets/ra.png"),
                figureImage(Game.tries >= 4, "assets/la.png"),
                figureImage(Game.tries >= 5, "assets/rl.png"),
                figureImage(Game.tries >= 6, "assets/ll.png"),
              ],
            ),
          ),

          //Now we will build the Hidden word widget
          //now let's go back to the Game class and add
          // a new variable to store the selected character
          /* and check if it's on the word */
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:word
                  .split('')
                  .map((e) => letter(e.toUpperCase(),
                  !Game.selectedChar.contains(e.toUpperCase())))
                  .toList()
          ),
          ElevatedButton(
              onPressed: (){
                setState(() {
                  List<Widget> inp=[];
                  int ran=Random(). nextInt(secretwords.length);
                  word=secretwords[ran].toUpperCase();
                  Game.selectedChar.clear();
                  Game.tries=0;
                });
              },
              child: Text("Play Again")),

          //Now let's build the Game keyboard
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: alphabets.map((e) {
                return RawMaterialButton(
                  onPressed: Game.selectedChar.contains(e)
                      ? null // we first check that we didn't selected the button before
                      : () {
                    setInpu();
                    setState(() {
                      Game.selectedChar.add(e);
                      print(Game.selectedChar);
                      if (!word.split('').contains(e.toUpperCase())) {
                        Game.tries++;
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: Game.selectedChar.contains(e)
                      ? Colors.black87
                      : Colors.blue,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}