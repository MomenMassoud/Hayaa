import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReplyCard extends StatefulWidget{
  String msg;
  String date;
  bool group;
  String sinder;
  String id;
  ReplyCard(this.msg,this.date,this.group,this.sinder,this.id, {super.key});
  @override
  _ReplyCard createState()=>_ReplyCard();

}
class _ReplyCard extends State<ReplyCard>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void deleteMSG()async{
    try{
      if(widget.group==true){
        final docRef = _firestore.collection("MassegeGroup").doc(widget.id);
        final updates = <String, dynamic>{
          "Msg": "This MSG deleted!",
        };
        docRef.update(updates);
        print("Delete MSG From Chat Group");
      }
      else{
        final docRef = _firestore.collection("chat").doc(widget.id);
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
      if(widget.group==true){
        // final docRef = _firestore.collection("MassegeGroup").doc(id);
        // final updates = <String, dynamic>{
        //   "Msg": "This MSG deleted!",
        // };
        // docRef.update(updates);
        // print("Delete MSG From Chat Group");
      }
      else{
        final docRef = _firestore.collection("chat").doc(widget.id);
        final updates = <String, dynamic>{
          "delete2": "true",
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
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: ()async {},
                      child: const Row(
                        children: [
                          Icon(Icons.copy),
                          Text("Copied MSG"),
                        ],
                      )
                  ),
                  ElevatedButton(
                      onPressed: (){
                        deleteMSG();
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.delete),
                          Text("Delete MSG Form Every One"),
                        ],
                      )
                  ),
                  ElevatedButton(
                      onPressed: (){
                        deleteMSGFromYou();
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.delete),
                          Text("Delete MSG Form you"),
                        ],
                      )
                  )
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width-45,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(30),
                  bottomEnd: Radius.circular(30),
                  bottomStart: Radius.circular(30)
              ),
              color: Colors.grey.shade200
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
                      widget.msg,
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
                        color:  Colors.grey ,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.date,
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