import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';

import '../../Games/GuessNumberGame/guessnamber.dart';
import '../../Games/Snake/main_snake.dart';
import '../../Games/Tetris/main_tetris.dart';
import '../../Games/X-O/x_ogame.dart';
import '../../Games/chees_game/chess.dart';
import '../../Games/hangman/hangman.dart';


class GameScreenList extends StatefulWidget{
  _GameScreenList createState()=>_GameScreenList();
}

class _GameScreenList extends State<GameScreenList>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  chatmodel source=chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  void getUser() async{
    Map<String, dynamic>? usersMap2;
    await for(var snapshots in _firestore.collection('user').where('email',isEqualTo: _auth.currentUser?.email).snapshots()){
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        source.email=usersMap2!['email'];
        source.name=usersMap2!['name'];
        source.photo=usersMap2!['photo'];
        source.devicetoken=usersMap2!['devicetoken'];
        source.gender=usersMap2!['gender'];
        source.bio=usersMap2!['bio'];
        source.coin=usersMap2!['coin'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          ListTile(
            title: Text("لعبة الشطرنج"),
            leading: Image.asset("assets/chess.png"),
            subtitle: Text("تكلفة اللعبة 35 عملة"),
            onTap: ()async{
              int usercoin=int.parse(source.coin);
              String id="";
              if(usercoin>=35){
                usercoin=usercoin-35;
                await _firestore.collection('user').where('email',isEqualTo:source.email).get().then((value){
                  id=value.docs[0].id;
                });
                try{
                  final docRef = _firestore.collection("user").doc(id);
                  final updates = <String, dynamic>{
                    "coin": usercoin.toString(),
                  };
                  docRef.update(updates);
                }
                catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>ChessGame(),
                    ));
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text('خطاء'),
                          content: Text("لا تملك عملات كافية للعب هذه اللعبة برجاء الشحن"),
                          icon:ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("اغلاق"),
                          )

                      );
                    }
                );
              }
            },
          ),
          ListTile(
            title: Text("لعبة X O"),
            leading: Image.asset("assets/xo.png"),
            subtitle: Text("تكلفة اللعبة 29 عملة"),
            onTap: ()async{
              String id="";
              int usercoin=int.parse(source.coin);
              if(usercoin>=29){
                usercoin=usercoin-29;
                await _firestore.collection('user').where('email',isEqualTo: source.email).get().then((value){
                  id=value.docs[0].id;
                });
                try{
                  final docRef = _firestore.collection("user").doc(id);
                  final updates = <String, dynamic>{
                    "coin": usercoin.toString(),
                  };
                  docRef.update(updates);
                }
                catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>XOGame(),
                    ));
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text('خطاء'),
                          content: Text("لا تملك عملات كافية للعب هذه اللعبة برجاء الشحن"),
                          icon:ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("اغلاق"),
                          )

                      );
                    }
                );
              }
            },
          ),
          ListTile(
            title: Text("لعبة تخمين الرقم"),
            leading: Image.asset("assets/guess.jpg"),
            subtitle: Text("تكلفة اللعبة 10  عملة"),
            onTap: ()async{
              String id="";
              int usercoin=int.parse(source.coin);
              if(usercoin>=10){
                usercoin=usercoin-10;
                await _firestore.collection('user').where('email',isEqualTo: source.email).get().then((value){
                  id=value.docs[0].id;
                });
                try{
                  final docRef = _firestore.collection("user").doc(id);
                  final updates = <String, dynamic>{
                    "coin": usercoin.toString(),
                  };
                  docRef.update(updates);
                }
                catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>GameScreenGuess(),
                    ));
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text('خطاء'),
                          content: Text("لا تملك عملات كافية للعب هذه اللعبة برجاء الشحن"),
                          icon:ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("اغلاق"),
                          )

                      );
                    }
                );
              }
            },

          ),
          ListTile(
            title: Text("لعبة تخمين الكلمات"),
            leading: Image.asset("assets/hangman.png"),
            subtitle: Text("تكلفة اللعبة 30  عملة"),
            onTap: ()async{
              String id="";
              int usercoin=int.parse(source.coin);
              if(usercoin>=30){
                usercoin=usercoin-30;
                await _firestore.collection('user').where('email',isEqualTo: source.email).get().then((value){
                  id=value.docs[0].id;
                });
                try{
                  final docRef = _firestore.collection("user").doc(id);
                  final updates = <String, dynamic>{
                    "coin": usercoin.toString(),
                  };
                  docRef.update(updates);
                }
                catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>Hangman(),
                    ));
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text('خطاء'),
                          content: Text("لا تملك عملات كافية للعب هذه اللعبة برجاء الشحن"),
                          icon:ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("اغلاق"),
                          )

                      );
                    }
                );
              }
            },
          ),
          ListTile(
            title: Text("لعبةالثعبان"),
            leading: Image.asset("assets/snake_game.jpg"),
            subtitle: Text("تكلفة اللعبة 60  عملة"),
            onTap: ()async{
              String id="";
              int usercoin=int.parse(source.coin);
              if(usercoin>=60){
                usercoin=usercoin-60;
                await _firestore.collection('user').where('email',isEqualTo: source.email).get().then((value){
                  id=value.docs[0].id;
                });
                try{
                  final docRef = _firestore.collection("user").doc(id);
                  final updates = <String, dynamic>{
                    "coin": usercoin.toString(),
                  };
                  docRef.update(updates);
                }
                catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>SnakeMain(),
                    ));
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text('خطاء'),
                          content: Text("لا تملك عملات كافية للعب هذه اللعبة برجاء الشحن"),
                          icon:ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("اغلاق"),
                          )

                      );
                    }
                );
              }
            },
          ),
          ListTile(
            title: Text("لعبة Tetris"),
            leading: Image.asset("assets/tet.png"),
            subtitle: Text("تكلفة اللعبة 60  عملة"),
            onTap: ()async{
              String id="";
              int usercoin=int.parse(source.coin);
              if(usercoin>=60){
                usercoin=usercoin-60;
                await _firestore.collection('user').where('email',isEqualTo: source.email).get().then((value){
                  id=value.docs[0].id;
                });
                try{
                  final docRef = _firestore.collection("user").doc(id);
                  final updates = <String, dynamic>{
                    "coin": usercoin.toString(),
                  };
                  docRef.update(updates);
                }
                catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>MainTetris(),
                    ));
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          title: Text('خطاء'),
                          content: Text("لا تملك عملات كافية للعب هذه اللعبة برجاء الشحن"),
                          icon:ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("اغلاق"),
                          )

                      );
                    }
                );
              }
            },
          ),

        ],
      ),
    );
  }

}