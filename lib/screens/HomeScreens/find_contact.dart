import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import 'package:iconnect2/screens/Chat/chat_screen.dart';

import '../../Model/massege_model.dart';

class FindContact extends StatefulWidget {
  static const String ScreenRoute = 'findcontact_screen';
  _FindContact createState() => _FindContact();
}

class _FindContact extends State<FindContact> {
  String search = "";
  List<chatmodel> users = [];
  chatmodel user=chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getHistory() async {
    Map<String, dynamic>? usersMap2;
    await for (var snapshot in _firestore
        .collection('historysearch')
        .where('owner', isEqualTo: _auth.currentUser!.email)
        .snapshots()) {
      for (int i = 0; i < snapshot.size; i++) {
        usersMap2 = snapshot.docs[i].data();
        chatmodel user =
            chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
        user.email = usersMap2!['email'];
        user.name = usersMap2!['name'];
        user.photo = usersMap2!['photo'];
        setState(() {
          users.add(user);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height - 160,
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .where('email', isNotEqualTo: _auth.currentUser?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                List<chatmodel> massegeWidget = [];
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  String email=massege.get('email');
                  String name=massege.get('name');
                  String bio=massege.get('bio');
                  String devicetoken=massege.get('devicetoken');
                  String gender=massege.get('gender');
                  String photo=massege.get('photo');
                  String seen=massege.get('seen');
                  chatmodel us =chatmodel(name, email, photo, bio, gender, devicetoken);
                  massegeWidget.add(us);
                }
                return ListView.builder(
                    itemCount: massegeWidget.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Text(massegeWidget[index].name),
                        subtitle: Text(massegeWidget[index].bio),
                        leading: CachedNetworkImage(imageUrl: massegeWidget[index].photo),
                        onTap: ()async{
                          try{
                            Map<String, dynamic>? usersMap;
                            int c=0;
                            await _firestore.collection('contact').where('myemail',isEqualTo: _auth.currentUser?.email).get().then((value){
                              for(int i=0;i<value.size;i++){
                                usersMap = value.docs[i].data();
                                String em=usersMap!['contact'];
                                if(massegeWidget[index].email==em){
                                  c++;
                                }
                              }
                              if(c==0){
                                setNewContact(_auth.currentUser!.email.toString(), massegeWidget[index].email);
                              }
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>   ChatScreen(user,massegeWidget[index]),
                                ));
                          }
                          catch(e){
                            print(e);
                          }
                        },
                      );
                    }
                );
              })),
    );
  }

  void setNewContact(String own,String con)async{
    try{
      await _firestore.collection('contact').doc().set({
        'myemail':own,
        'contact':con
      });
      await _firestore.collection('contact').doc().set({
        'myemail':con,
        'contact':own
      });
    }
    catch(e){
      print(e);
    }
  }
}
