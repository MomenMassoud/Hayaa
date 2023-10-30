import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Model/ChatModel.dart';

class CameraView extends StatefulWidget{
  final String path;
  final String pathName;
  chatmodel user;
  CameraView(this.path,this.pathName,this.user);
 _CameraView createState()=>_CameraView();

}

class _CameraView extends State<CameraView>{
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
    // TODO: implement initState
    super.initState();
    getUser();
    now = new DateTime.now();
    setChatRoom();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(onPressed: (){}, icon:Icon(Icons.crop_rotate_sharp,size: 27,)),
            IconButton(onPressed: (){}, icon:Icon(Icons.emoji_emotions_sharp,size: 27,)),
            IconButton(onPressed: (){}, icon:Icon(Icons.title,size: 27,)),
            IconButton(onPressed: (){}, icon:Icon(Icons.edit,size: 27,)),
          ],
        ),
        body: ModalProgressHUD(
          inAsyncCall: _showspinner,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(widget.path),
                      fit: BoxFit.cover,
                    )
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                    child: TextFormField(
                      controller: _controller2,
                      maxLines: 6,
                      minLines: 1,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add_photo_alternate),
                          border: InputBorder.none,
                          hintText: "Add Caption ....1",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 16
                          ),
                          suffixIcon: CircleAvatar(
                            radius: 27,
                            child: IconButton(
                              onPressed: ()async{
                                try{
                                  final path = "chat/photos/${widget.pathName}";
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
                                    'type': 'photo',
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
                                // Navigator.pop(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (builder)=> SelectCameraView(widget.path,widget.pathName,"photo",_controller2.text.toString())));

                              },
                              icon: Icon(Icons.send),
                            ),
                          )
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        )
    );
  }

}