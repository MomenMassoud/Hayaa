import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class Recorder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FileName=DateTime.now().toString();
  final recorder= FlutterSoundRecorder();
  bool stateRecorder=false;
  late String useremail;
  late String target;
  late bool isGroup;
  late String ChatRoomID;
  late String userName;

  bool get isRecording => stateRecorder;
  Future Record()async{
    await recorder.startRecorder(toFile: '${_auth.currentUser?.email}$FileName.aac');
    stateRecorder=true;
  }
  Future stop()async{
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print("Recorded in $audioFile");
    if(isGroup==true){
      _SetCloudGroup(audioFile);
    }
    else{
      _SetCloudRecord(audioFile);
    }
    //OpenFile.open(audioFile.path);
    stateRecorder=false;
  }
  void _SetCloudGroup(File image)async{
    final path = "chat_group/record/$FileName.mp3";
    final file = File(image.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : $urlDownload");
    final id = DateTime.now().toString();
    String idd = "$id-$useremail";
    print("Massege Send");
    await _firestore.collection('MassegeGroup').doc(idd).set({
      'GroupID': target,
      'sender': useremail,
      'type': 'record',
      'time': DateTime.now().toString().substring(10, 16),
      'Msg': urlDownload,
      'name': userName,
      "assigmentid":""
    });
    Map<String, dynamic>?usersMap;
    await _firestore.collection("Groups").where(
        'GroupID', isEqualTo: target).get().then((
        value) {
      for (int i = 0; i < value.docs.length; i++) {
        usersMap = value.docs[i].data();
        String em = usersMap!['User'];
        String idUser = value.docs[i].id;
        final docRef = _firestore.collection("Groups").doc(idUser);
        final updates = <String, dynamic>{
          "LastMSG": "record",
          "typeLastMSG": "record",
          "time": DateTime.now().toString().substring(10, 16)
        };
        docRef.update(updates);
        print("update Fileds In Group");
      }
    });
  }
  void _SetCloudRecord(File image)async{
    final path = "chat/records/$FileName.mp3";
    final file = File(image.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : $urlDownload");
    final id = DateTime.now().toString();
    String idd = "$id-$useremail";

    await _firestore.collection('chat').doc(idd).set({

      'chatroom': ChatRoomID,
      'sender': useremail,
      'type': 'record',
      'time': DateTime.now().toString().substring(10, 16),
      'msg': urlDownload,
      'delete1':"false",
      "delete2":"false",
      "seen":"false"
    });
    String idUser = "$useremail$target";
    final docRef = _firestore.collection("contact").doc(idUser);
    final updates = <String, dynamic>{
      "lastmsg": "record",
      'time': DateTime.now().toString().substring(10, 16),
      'typeLast': "msg"
    };
    docRef.update(updates);
    idUser = "$target$useremail";
    final docRef2 = _firestore.collection("contact").doc(idUser);
    final updates2 = <String, dynamic>{
      "lastmsg": "record",
      'time': DateTime.now().toString().substring(10, 16),
      'typeLast': "msg"
    };
    docRef2.update(updates2);
    print("Massege Send");

  }
  Future initRecorder()async{
    final PermissionStatus status = await Permission.microphone.request();
    // Check if permission is granted
    if (status == PermissionStatus.granted) {
      try {
        // Open the audio session
        await recorder.openAudioSession();

        // Set the subscription duration
        recorder.setSubscriptionDuration(const Duration(microseconds: 500));

        // Now, you can proceed with your recording logic
      } catch (e) {
        print("Error initializing recorder: $e");
        // Handle error, perhaps show a user-friendly message
      }
    } else {
      // Handle case where permission is denied
      // You might want to inform the user and handle it accordingly
      print("Microphone permission denied");
    }
  }
  void dispose(){
    recorder.closeAudioSession();
  }

  Future toggleRecording()async {
    if(recorder.isRecording){
      await stop();
    }
    else{
      await Record();
    }
  }
}