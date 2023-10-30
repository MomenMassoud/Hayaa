import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Custom_Wedgit/view_vedio.dart';
import 'package:video_player/video_player.dart';


class OwnVedioCard extends StatefulWidget{
  String url;
  String time;
  String type;
  bool group;
  String id;
  OwnVedioCard(this.url, this.time, this.type,this.group,this.id);
  _OwnVedioCard createState()=>_OwnVedioCard();
}

class _OwnVedioCard extends State<OwnVedioCard>{
  late VideoPlayerController _controller;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void deleteMSG()async{
    try{
      if(widget.group==true){
        final docRef = _firestore.collection("MassegeGroup").doc(widget.id);
        final updates = <String, dynamic>{
          "Msg": "This MSG deleted!",
          "type":"msg"
        };
        docRef.update(updates);
        print("Delete MSG From Chat Group");
      }
      else{
        final docRef = _firestore.collection("chat").doc(widget.id);
        final updates = <String, dynamic>{
          "msg": "This MSG deleted!",
          "type":"msg"
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
                title: Text('Error'),
                content: Text(e.toString()),
                icon:ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Ignore"),
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
            title: Text('Please choose'),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        deleteMSG();
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          Text("Delete MSG"),
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
    VideoPlayerController _controller= VideoPlayerController.network(widget.url)..initialize().then((_) {
      setState(() {});
    });
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height/2.3,
          width: MediaQuery.of(context).size.width/1.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green[300]
          ),
          child: Card(
            margin: EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Stack(
              fit:StackFit.expand,
              children: [
                AspectRatio(
                    aspectRatio:_controller.value.aspectRatio,
                    child: VideoPlayer(_controller)
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onLongPress: (){
                      myAlert();
                    },
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewVideo(widget.url,)));
                    },
                    child: CircleAvatar(
                      radius: 33,
                      backgroundColor: Colors.black38,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
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