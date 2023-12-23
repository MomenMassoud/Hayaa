import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/Utils/app_colors.dart';

class OwnMassege extends StatelessWidget{
  String msg;
  String date;
  String id;
  bool group;
  String seen;
  OwnMassege(this.msg,this.date,this.id,this.group,this.seen, {super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    void deleteMSG()async{
      try{
        if(group==true){
          final docRef = _firestore.collection("MassegeGroup").doc(id);
          final updates = <String, dynamic>{
            "Msg": "This MSG deleted!",
          };
          docRef.update(updates);
          print("Delete MSG From Chat Group");
        }
        else{
          final docRef = _firestore.collection("chat").doc(id);
          final updates = <String, dynamic>{
            "msg": "This MSG deleted!",
          };
          docRef.update(updates);
          print("Delete MSG From Chat One to One");
        }
      }
      catch(e){
        return showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: const Text('Error'),
                  content: Text(e.toString()),
                  icon:ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Ignore"),
                  )

              );
            }
        );
      }
    }
    void deleteMSGFromYou()async{
      try{
        if(group==true){
          _firestore.collection('MassegeGroup').doc(id).collection('users').where('email',isEqualTo: _auth.currentUser!.email).get().then((value) {
            Map<String,dynamic>?usersMap2;
            final ids=value.docs[0].id;
            final docRef = _firestore.collection('MassegeGroup').doc(id).collection('users').doc(ids);
            final updates = <String,dynamic>{
              "delete":"true"
            };
            docRef.update(updates);
          });
        }
        else{
          final docRef = _firestore.collection("chat").doc(id);
          final updates = <String, dynamic>{
            "delete1": "true",
          };
          docRef.update(updates);
          print("Delete MSG From Chat One to One");
        }
      }
      catch(e){
        return showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: const Text('Error'),
                  content: Text(e.toString()),
                  icon:ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Ignore"),
                  )

              );
            }
        );
      }
    }
    void myAlert(){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: const Text('Please choose'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: ()async{

                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(width: 3, color: Colors.black),
                          ),
                        ),
                        enableFeedback: true,
                        alignment: Alignment.center
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.copy),
                        Text("Copied MSG"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      deleteMSG();
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(width: 3, color: Colors.black),
                          ),
                        ),
                        enableFeedback: true,
                        alignment: Alignment.center
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.delete),
                        Text("Delete MSG Form Every One"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      deleteMSGFromYou();
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(width: 3, color: Colors.black),
                          ),
                        ),
                        enableFeedback: true,
                        alignment: Alignment.center
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.delete),
                        Text("Delete MSG Form you"),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ()async{
                      try{
                        _firestore.collection('star').doc().set({
                          'owner':_auth.currentUser?.email,
                          'msg':msg,
                          'type':'msg',
                          'time':date,
                          'sender':_auth.currentUser?.email,
                        });
                        Navigator.pop(context);
                      }
                      catch(e){
                        print(e);
                      }
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(width: 3, color: Colors.black),
                          ),
                        ),
                        enableFeedback: true,
                        alignment: Alignment.center
                    ),
                    child: const Text("Add To Star Massege"),
                  )
                ],
              ),
            );
          }
      );
    }
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(12),
              gradient: LinearGradient(
                colors: [AppColors.app3MainColor, AppColors.appMainColor],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 80,
                    top: 9,
                    bottom: 20,
                  ),
                  child: InkWell(
                    onLongPress: () {
                      myAlert();
                    },
                    child: Text(
                      msg,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.done_all_rounded,
                        color: seen == "false" ? Colors.grey : Colors.blue,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}