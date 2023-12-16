import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
class OwnAudio extends StatefulWidget{
  String urll;String time;String type;String img;
  bool group;String id;
  OwnAudio(this.urll,this.time,this.type,this.img,this.group,this.id);
  _OwnAudio createState()=>_OwnAudio();
}

class _OwnAudio extends State<OwnAudio>{
  final FirebaseFirestore _firebaseStorage=FirebaseFirestore.instance;
  bool _isplaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final _audioPlayer = AudioPlayer();
  late final duration;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        _isplaying=event==PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration=event;
      });
    });
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        _position=event;
      });
    });
  }
  void deleteMSG()async{
    try{
      if(widget.group==true){
        final docRef = _firebaseStorage.collection("MassegeGroup").doc(widget.id);
        final updates = <String, dynamic>{
          "Msg": "This MSG deleted!",
          "type":"msg"
        };
        docRef.update(updates);
        print("Delete MSG From Chat Group");
      }
      else{
        final docRef = _firebaseStorage.collection("chat").doc(widget.id);
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
    return InkWell(
      onLongPress: (){
        myAlert();
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Card(
              color: Color(0xffdcf8c6),
              margin: EdgeInsets.all(3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage:CachedNetworkImageProvider(widget.img),
                    radius: 20,
                  ),
                  InkWell(
                      onTap: ()async{
                        if(_isplaying){
                          await _audioPlayer.pause();
                        }
                        else{
                          await _audioPlayer.play(UrlSource(widget.urll));
                        }
                      },
                      child: _isplaying?Icon(Icons.pause):Icon(Icons.play_arrow)
                  ),
                  Slider(
                      min: 0,
                      inactiveColor: Colors.blueGrey,
                      activeColor: Colors.blue,
                      max: _duration.inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      onChanged: (value)async{
                        final pp = Duration(seconds: value.toInt());
                        await _audioPlayer.seek(pp);
                        await _audioPlayer.resume();
                        if(_duration==Duration.zero){
                          setState(() {
                            _position=Duration.zero;
                          });
                        }
                      }),
                  Text("${formatTime(_position)}/${formatTime(_duration-_position)}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatTime(Duration position) {
    String twoDigit(int n)=>n.toString().padLeft(2,'0');
    final hour = twoDigit(position.inHours);
    final minitus=twoDigit(position.inMinutes.remainder(60));
    final secound=twoDigit(position.inSeconds.remainder(60));
    return [
      if(position.inHours>0)hour,minitus,secound
    ].join(":");
  }

}