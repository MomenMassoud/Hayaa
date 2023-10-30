import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  chatmodel user;
  final String path;
  String namePath;
  VideoViewPage(this.path,this.namePath,this.user);

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;
  final TextEditingController _controller2 = TextEditingController();
  final _auth =FirebaseAuth.instance;
  final  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  late User SignInUser;
  bool _showspinner=false;
  late DateTime now;
  String chatroomID="";
  chatmodel source=chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  void getUser() async {
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
  void setChatRoom(){
    String id1=source.email;
    String id2=widget.user.email;
    if (id1.toLowerCase().codeUnits[0] >
        id2.toLowerCase().codeUnits[0]) {
      chatroomID = "$id1$id2";
    } else {
      chatroomID = "$id2$id1";
    }
  }
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    getUser();
    now = new DateTime.now();
    setChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
              icon: Icon(
                Icons.crop_rotate,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.emoji_emotions_outlined,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.title,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.edit,
                size: 27,
              ),
              onPressed: () {}),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: TextFormField(
                    controller: _controller2,
                    style: TextStyle(

                      color: Colors.white,
                      fontSize: 17,
                    ),
                    maxLines: 6,
                    minLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Caption....",
                        prefixIcon: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: 27,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        suffixIcon: CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.blue[900],
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 27,
                            ),
                            onPressed: ()async{
                              try{
                                final path = "chat/vedio/${widget.namePath}";
                                final file = File(widget.path);
                                final ref = FirebaseStorage.instance.ref().child(path);
                                final uploadTask = ref.putFile(file);
                                final snapshot = await uploadTask!.whenComplete(() {});
                                final urlDownload = await snapshot.ref.getDownloadURL();
                                print("Download Link : ${urlDownload}");
                                final id = DateTime.now().toString();
                                String idd = "$id-${source.email}";
                                print("Massege Send");
                                await _firestore.collection('chat').doc(idd).set({
                                  'chatroom': chatroomID,
                                  'sender': source.email,
                                  'type': 'vedio',
                                  'time': DateTime.now().toString().substring(10, 16),
                                  'msg': urlDownload,
                                  'seen': "false",
                                });
                                setState(() {
                                  Navigator.pop(context);
                                  _showspinner = false;
                                });
                              }
                              catch(e){
                                print(e);
                              }
                            },
                          )
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.black38,
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
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
    );
  }
}