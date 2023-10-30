import 'package:flutter/material.dart';
import 'package:iconnect2/Custom_Wedgit/view_vedio.dart';
import 'package:video_player/video_player.dart';

class ReplayVedioCard extends StatefulWidget{
  String url;
  String time;
  String type;
  ReplayVedioCard(this.url, this.time, this.type);
  _OwnVedioCard createState()=>_OwnVedioCard();
}

class _OwnVedioCard extends State<ReplayVedioCard>{
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    VideoPlayerController _controller= VideoPlayerController.network(widget.url)..initialize().then((_) {
      setState(() {});
    });
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height/2.3,
          width: MediaQuery.of(context).size.width/1.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey
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