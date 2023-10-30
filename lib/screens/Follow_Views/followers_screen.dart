import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/followes_model.dart';

class FollowersScreen extends StatefulWidget{
  List<String> emails;
  FollowersScreen(this.emails);
  _FollowersScreen createState()=>_FollowersScreen();
}

class _FollowersScreen extends State<FollowersScreen>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  List<Follows> follows=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0;i<widget.emails.length;i++){
      getFollowData(widget.emails[i]);
    }
  }
  void getFollowData(String em)async{
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore
        .collection('user')
        .where('email', isEqualTo: em)
        .snapshots()) {
      for(int i=0;i<snapshots.size;i++){
        usersMap2 = snapshots.docs[i].data();
        String email = usersMap2!['email'];
        String names = usersMap2!['name'];
        String photo = usersMap2!['photo'];
        print("objecttttttttttt");
        Follows followss=Follows(email, names, photo);
        setState(() {
          follows.add(followss);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("متابعينك"),
      ),
      body: ListView.builder(
          itemCount: follows.length,
          itemBuilder: (context,index){
        return ListTile(
          title: Text(follows[index].name),
          subtitle: Text(follows[index].email),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(follows[index].photo),
          ),
        );
      }),
    );
  }

}