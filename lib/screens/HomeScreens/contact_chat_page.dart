import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Custom_Wedgit/custom_card.dart';
import '../../Model/ChatModel.dart';

class ChatPage extends StatefulWidget{
  chatmodel source;
  ChatPage(this.source);
  _ChatPage createState()=>_ChatPage();
}

class _ChatPage extends State<ChatPage>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<chatmodel> contacts =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }
  void getContact()async{
    Map<String,dynamic>?usersMap2;
    await for(var snapShot in _firestore.collection('contact').where('myemail',isEqualTo:widget.source.email ).snapshots()){
      for(var cont in snapShot.docs){
        usersMap2=cont.data();
        String contactEmail=usersMap2!['contact'];
        getContactData(contactEmail);
      }
    }
  }
  void getContactData(String email)async{
    Map<String,dynamic>?usersMap2;
    chatmodel target=chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
    await for(var snapShot in _firestore.collection('user').where('email',isEqualTo:email ).snapshots()) {
      usersMap2 = snapShot.docs[0].data();
      target.bio=usersMap2!['bio'];
      target.coin=usersMap2!['coin'];
      target.devicetoken=usersMap2!['devicetoken'];
      target.gender=usersMap2!['gender'];
      target.name=usersMap2!['name'];
      target.photo=usersMap2!['photo'];
      target.seen=usersMap2!['seen'];
      target.email=usersMap2!['email'];
      setState(() {
        contacts.add(target);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:contacts.length>0? ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context,index){
              return CustomCard(widget.source,contacts[index]);
          }):Center(
              child: Text("لا يوجد اي محادثات"),
    ),
    );
  }

}