import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import '../../AudioCall_VideoCall/live_room.dart';
import '../../Model/massege_model.dart';
import '../../meeting/screens/common/join_screen.dart';
import '../../meeting/screens/conference-call/conference_meeting_screen.dart';
import '../../meeting/utils/api.dart';
import '../../meeting/utils/toast.dart';

class VoiceRoom extends StatefulWidget{
  _VoiceRoom createState()=>_VoiceRoom();
}

class _VoiceRoom extends State<VoiceRoom>{
  String meet="";
  String _token="";
  CameraController? cameraController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  chatmodel user=chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    meet=_auth.currentUser!.email.toString();
    initCameraPreview();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await fetchToken(context);
      setState(() => _token = token);
    });
    getUser();
  }
  void initCameraPreview() {
    // Get available cameras
    availableCameras().then((availableCameras) {
      // stores selected camera id
      int selectedCameraId = availableCameras.length > 1 ? 1 : 0;

      cameraController = CameraController(
        availableCameras[selectedCameraId],
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      log("Starting Camera");
      cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }).catchError((err) {
      log("Error: $err");
    });
  }
  void getUser() async{
    Map<String, dynamic>? usersMap2;
    await for(var snapshots in _firestore.collection('user').where('email',isEqualTo: _auth.currentUser?.email).snapshots()){
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        user.email=usersMap2!['email'];
        user.name=usersMap2!['name'];
        user.photo=usersMap2!['photo'];
        user.devicetoken=usersMap2!['devicetoken'];
        user.gender=usersMap2!['gender'];
        user.bio=usersMap2!['bio'];
        user.coin=usersMap2!['coin'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('meeting').snapshots(),
          builder: (context,snapshot){
            List<MessageModel> massegeWidget = [];
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              final massegeText = massege.get('id');
              final massegetype = massege.get('email');
              MessageModel messageModel = MessageModel("message", "type", "time");
              messageModel.message=massegeText;
              messageModel.type=massegetype;
              massegeWidget.add(messageModel);
            }
            return massegeWidget.length>0?GridView.builder(
                itemCount: massegeWidget.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>   VideoConferencePage(user.email,user.name,massegeWidget[index].message,false,user.photo),
                          ));
                    },
                    child: Image.asset("assets/voice_room.jpg"),
                  );
                }
            ):Center(
              child: Text("لا يوجد اي غرف صوتية"),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(
          side: BorderSide.none
        ),
        onPressed: (){
           // createAndJoinMeeting("GROUP",user.name);
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) =>  JoinScreen(),
          ));
        },
        child: ElevatedButton(onPressed: ()async{
          String idd="";
          int coins=int.parse(user.coin);
          if(coins>15){
            setState(() {
              coins=coins-15;
            });
            await _firestore.collection('user').where('email',isEqualTo: user.email).get().then((value){
              idd=value.docs[0].id;
            });
            try{
              final docRef = _firestore.collection("user").doc(idd);
              final updates = <String, dynamic>{
                "coin": coins.toString(),
              };
              docRef.update(updates);
            }
            catch(e){
              print(e);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   VideoConferencePage(user.email,user.name,user.email,true,user.photo),
                ));
          }

        }, child: Text("انشاء غرفة جديدة")),
      ),
    );

  }
  void checkCoin(String call,String name , String id)async{
    int coins=int.parse(user.coin);
    if(coins>15){
     setState(() {
       coins=coins-15;
     });
     await _firestore.collection('user').where('email',isEqualTo: user.email).get().then((value){
       id=value.docs[0].id;
     });
     try{
       final docRef = _firestore.collection("user").doc(id);
       final updates = <String, dynamic>{
         "coin": coins.toString(),
       };
       docRef.update(updates);

     }
     catch(e){
       print(e);
     }

    }
  }
  Future<void> joinMeeting(callType, displayName, meetingId) async {
    if (meetingId.isEmpty) {
      showSnackBarMessage(
          message: "Please enter Valid Meeting ID", context: context);
      return;
    }
    var validMeeting = await validateMeeting(_token, meetingId);
    if (validMeeting) {
      if (callType == "GROUP") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfereneceMeetingScreen(
              token: _token,
              meetingId: meetingId,
              displayName: displayName,
              micEnabled: true,
              camEnabled: true,
            ),
          ),
        );
      }
    } else {
      showSnackBarMessage(message: "Invalid Meeting ID", context: context);
    }
  }
  Future<void> createAndJoinMeeting(callType, displayName) async {
    try {
      var _meetingID = await createMeeting(_token);
      String docs="${DateTime.now().toString()}-${_auth.currentUser?.email}";
      await _firestore.collection('meeting').doc(docs).set({
        'id':_meetingID,
        'owner':_auth.currentUser?.email.toString(),
      });
      if (callType == "GROUP") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConfereneceMeetingScreen(
                  token: _token,
                  meetingId: _meetingID,
                  displayName: displayName,
                  micEnabled: true,
                  camEnabled: true,
                ),
          ),
        );
      }
    }catch (error) {
      showSnackBarMessage(message: error.toString(), context: context);
    }
  }

}