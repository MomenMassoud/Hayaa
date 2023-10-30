import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';

class MakeNewCall extends StatefulWidget {
  chatmodel source;
  MakeNewCall(this.source);
  _MakeNewCall createState() => _MakeNewCall();
}

class _MakeNewCall extends State<MakeNewCall> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User SignInUser;
  List<chatmodel> chat = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getContact2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make New Call"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(chat[index].name),
                  subtitle: Text(chat[index].bio),
                  leading: chat[index].photo != ""
                      ? CircleAvatar(
                    backgroundImage:
                    CachedNetworkImageProvider(chat[index].photo),
                  )
                      : CircleAvatar(
                    backgroundImage: AssetImage("Images/pop.jpg"),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () async {
                            String chatroomID = "";
                            if (widget.source.email[0]
                                .toLowerCase()
                                .codeUnits[0] >
                                chat[index].email.toLowerCase().codeUnits[0]) {
                              chatroomID =
                              "${widget.source.email}${chat[index].email}";
                            } else {
                              chatroomID =
                              "${chat[index].email}${widget.source.email}";
                            }
                            try {
                              String id = DateTime.now().toString();
                              String idd = "$id-${widget.source.email}";
                              await _firestore
                                  .collection("callhistory")
                                  .doc(idd)
                                  .set({
                                'profileIMG': chat[index].photo,
                                'time':
                                DateTime.now().toString().substring(10, 16),
                                'myemail': widget.source.email,
                                'mycontactemail': chat[index].email,
                                'type': 'audiocall',
                                'sendtype': 'outline',
                                'mycontactname': chat[index].name,
                                'callid': chatroomID
                              });
                              id = DateTime.now().toString();
                              idd = "$id-${chat[index].email}";
                              await _firestore
                                  .collection("callhistory")
                                  .doc(idd)
                                  .set({
                                'profileIMG': widget.source.photo,
                                'time':
                                DateTime.now().toString().substring(10, 16),
                                'myemail': chat[index].email,
                                'mycontactemail': widget.source.email,
                                'type': 'audiocall',
                                'sendtype': 'incoming',
                                'mycontactname': SignInUser.displayName,
                                'callid': chatroomID
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => AudioCallOneToOne(
                            //           chatroomID,
                            //           widget.source.name,
                            //           widget.source.email,
                            //         )));
                          },
                          icon: Icon(
                            Icons.call,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: () async {
                            String chatroomID = "";
                            if (widget.source.email[0]
                                .toLowerCase()
                                .codeUnits[0] >
                                chat[index].email.toLowerCase().codeUnits[0]) {
                              chatroomID =
                              "${widget.source.email}${chat[index].email}";
                            } else {
                              chatroomID =
                              "${chat[index].email}${widget.source.email}";
                            }
                            try {
                              String id = DateTime.now().toString();
                              String idd = "$id-${widget.source.email}";
                              await _firestore
                                  .collection("callhistory")
                                  .doc(idd)
                                  .set({
                                'profileIMG': chat[index].photo,
                                'time':
                                DateTime.now().toString().substring(10, 16),
                                'myemail': widget.source.email,
                                'mycontactemail': chat[index].email,
                                'type': 'vediocall',
                                'sendtype': 'outline',
                                'mycontactname': chat[index].name,
                                'callid': chatroomID
                              });
                              id = DateTime.now().toString();
                              idd = "$id-${chat[index].email}";
                              await _firestore
                                  .collection("callhistory")
                                  .doc(idd)
                                  .set({
                                'profileIMG': widget.source.photo,
                                'time':
                                DateTime.now().toString().substring(10, 16),
                                'myemail': chat[index].email,
                                'mycontactemail': widget.source.email,
                                'type': 'vediocall',
                                'sendtype': 'incoming',
                                'mycontactname': SignInUser.displayName,
                                'callid': chatroomID
                              });
                            } catch (e) {
                              print(e);
                            }
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => CallPage(
                            //           CallID: chatroomID,
                            //           UserName: widget.source.name,
                            //           email: widget.source.email,
                            //         )));
                          },
                          icon: Icon(
                            Icons.video_camera_back,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  void getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        SignInUser = user;
        setState(() {
          widget.source.name = SignInUser.displayName!;
          widget.source.email = SignInUser.email!;
          widget.source.photo = SignInUser.photoURL!;
        });
        Map<String, dynamic>? usersMap2;
        await _firestore
            .collection('user')
            .where('email', isEqualTo: widget.source.email)
            .get()
            .then((value) {
          usersMap2 = value.docs[0].data();
          String bio = usersMap2!['bio'];
          setState(() {
            widget.source.bio = bio;
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getContact2() async {
    Map<String, dynamic>? usersMap;
    String contactEmail = "";
    await for (var snapShot in _firestore
        .collection('contact')
        .where('myemail', isEqualTo: SignInUser.email)
        .snapshots()) {
      for (var cont in snapShot.docs) {
        usersMap = cont.data();
        contactEmail = usersMap!['myContactEmail'];
        String msg = usersMap!['latsMSG'];
        String type = usersMap!['typeLast'];
        String time = usersMap!['time'];
        String seen = usersMap!['seen'];
        getContactData2(contactEmail, time, msg, type, seen);
      }
    }
  }

  void getContactData2(
      String Contact, String time, String msg, String type, String seen) async {
    Map<String, dynamic>? usersMap2;
    await for (var snapShot in _firestore
        .collection('user')
        .where('email', isEqualTo: Contact)
        .snapshots()) {
      usersMap2 = snapShot.docs[0].data();
      String email = usersMap2!['email'];
      String name = usersMap2!['name'];
      String img = usersMap2!['profileIMG'];
      String bio = usersMap2!['bio'];
      chatmodel con = chatmodel(name, img, "false", time, msg, "5");
      con.email = email;
      con.bio = bio;
      con.seen = seen;
      int c = 0;
      setState(() {
        for (int i = 0; i < chat.length; i++) {
          if (chat[i].email == con.email) {
            chat[i].seen = seen;
            c++;
          }
        }
        if (c == 0) {
          chat.add(con);
        }
      });
    }
  }
}
