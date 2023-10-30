import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import '../Model/call_model.dart';
import 'make_new_call.dart';

class Call_History extends StatefulWidget{
  _Call_History createState()=>_Call_History();
}

class _Call_History extends State<Call_History>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final chatmodel source = chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  final FirebaseAuth _auth=FirebaseAuth.instance;
  List<CallModel> calls=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  void getUser() async{
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('callhistory')
              .where('myemail', isEqualTo: source.email)
              .snapshots(),
          builder: (context, snapshot) {
            List<CallModel> massegeWidget = [];
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              final mycontactemail = massege.get('mycontactemail');
              final mycontactname = massege.get('mycontactname');
              final prodileimg = massege.get('profileIMG');
              final sendtype = massege.get('sendtype');
              final time = massege.get('time');
              final type = massege.get('type');
              final callid = massege.get('callid');
              final id = massege.id;
              CallModel call = CallModel(
                  myemail: source.email,
                  mycontactemail: mycontactemail,
                  profileIMG: prodileimg,
                  type: type,
                  time: time,
                  sendtype: sendtype,
                  mycontactname: mycontactname,
                  callid: callid);
              call.id = id;
              calls.add(call);
              massegeWidget.add(call);
            }
            return massegeWidget.length > 0
                ? ListView.builder(
              itemCount: massegeWidget.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text("سجل المكالمات"),
                        leading: Icon(Icons.history),
                        subtitle: Text("سجل جميع المكالمات"),
                        trailing: IconButton(
                          onPressed: () async {
                            for (int i = 0;
                            i < massegeWidget.length;
                            i++) {
                              _firestore
                                  .collection("callhistory")
                                  .doc(massegeWidget[i].id)
                                  .delete()
                                  .then((value) => print("deleted"));
                            }
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ),
                      Divider(
                        thickness: 4,
                      ),
                      ListTile(
                        title: Text(massegeWidget[index].mycontactname),
                        subtitle: Row(
                          children: [
                            massegeWidget[index].sendtype == "outline"
                                ? Icon(
                              Icons.call_made,
                              color: Colors.green,
                            )
                                : Icon(
                              Icons.call_received,
                              color: Colors.blueAccent,
                            ),
                            Text(massegeWidget[index].time)
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              massegeWidget[index].profileIMG),
                        ),
                        trailing: massegeWidget[index].type == "audiocall"
                            ? IconButton(
                            onPressed: () async {
                              String chatroomID = "";
                              if (massegeWidget[index].type ==
                                  "audiocall") {
                                try {
                                  String id =
                                  DateTime.now().toString();
                                  String idd = "$id-${source.email}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': massegeWidget[index]
                                        .profileIMG,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': source.email,
                                    'mycontactemail':
                                    massegeWidget[index]
                                        .mycontactemail,
                                    'type': 'audiocall',
                                    'sendtype': 'outline',
                                    'mycontactname':
                                    massegeWidget[index]
                                        .mycontactname,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                  id = DateTime.now().toString();
                                  idd =
                                  "$id-${massegeWidget[index].mycontactemail}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': source.photo,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': massegeWidget[index]
                                        .mycontactemail,
                                    'mycontactemail': source.email,
                                    'type': 'audiocall',
                                    'sendtype': 'incoming',
                                    'mycontactname':
                                    source.name,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                } catch (e) {
                                  print(e);
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) =>
                                //             AudioCallOneToOne(
                                //               massegeWidget[index]
                                //                   .callid,
                                //               source.name,
                                //               source.email,
                                //             )));
                              } else {
                                try {
                                  String id =
                                  DateTime.now().toString();
                                  String idd = "$id-${source.email}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': massegeWidget[index]
                                        .profileIMG,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': source.email,
                                    'mycontactemail':
                                    massegeWidget[index]
                                        .mycontactemail,
                                    'type': 'vediocall',
                                    'sendtype': 'outline',
                                    'mycontactname':
                                    massegeWidget[index]
                                        .mycontactname,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                  id = DateTime.now().toString();
                                  idd =
                                  "$id-${massegeWidget[index].mycontactemail}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': source.photo,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': massegeWidget[index]
                                        .mycontactemail,
                                    'mycontactemail': source.email,
                                    'type': 'vediocall',
                                    'sendtype': 'incoming',
                                    'mycontactname':
                                    source.photo,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                } catch (e) {
                                  print(e);
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) =>
                                //             CallPage(
                                //               CallID:
                                //               massegeWidget[index]
                                //                   .callid,
                                //               UserName: source.name,
                                //               email: source.email,
                                //             )));
                              }
                            },
                            icon: Icon(
                              Icons.call,
                              color: Colors.blueAccent,
                            ))
                            : IconButton(
                            onPressed: () async {
                              String chatroomID = "";
                              if (massegeWidget[index].type ==
                                  "audiocall") {
                                try {
                                  String id =
                                  DateTime.now().toString();
                                  String idd = "$id-${source.email}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': massegeWidget[index]
                                        .profileIMG,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': source.email,
                                    'mycontactemail':
                                    massegeWidget[index]
                                        .mycontactemail,
                                    'type': 'audiocall',
                                    'sendtype': 'outline',
                                    'mycontactname':
                                    massegeWidget[index]
                                        .mycontactname,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                  id = DateTime.now().toString();
                                  idd =
                                  "$id-${massegeWidget[index].mycontactemail}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': source.photo,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': massegeWidget[index]
                                        .mycontactemail,
                                    'mycontactemail': source.email,
                                    'type': 'audiocall',
                                    'sendtype': 'incoming',
                                    'mycontactname':
                                    source.name,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                } catch (e) {
                                  print(e);
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) =>
                                //             AudioCallOneToOne(
                                //               massegeWidget[index]
                                //                   .callid,
                                //               source.name,
                                //               source.email,
                                //             )));
                              } else {
                                try {
                                  String id =
                                  DateTime.now().toString();
                                  String idd = "$id-${source.email}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': massegeWidget[index]
                                        .profileIMG,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': source.email,
                                    'mycontactemail':
                                    massegeWidget[index]
                                        .mycontactemail,
                                    'type': 'vediocall',
                                    'sendtype': 'outline',
                                    'mycontactname':
                                    massegeWidget[index]
                                        .mycontactname,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                  id = DateTime.now().toString();
                                  idd =
                                  "$id-${massegeWidget[index].mycontactemail}";
                                  await _firestore
                                      .collection("callhistory")
                                      .doc(idd)
                                      .set({
                                    'profileIMG': source.photo,
                                    'time': DateTime.now()
                                        .toString()
                                        .substring(10, 16),
                                    'myemail': massegeWidget[index]
                                        .mycontactemail,
                                    'mycontactemail': source.email,
                                    'type': 'vediocall',
                                    'sendtype': 'incoming',
                                    'mycontactname':
                                    source.name,
                                    'callid':
                                    massegeWidget[index].callid
                                  });
                                } catch (e) {
                                  print(e);
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) =>
                                //             CallPage(
                                //               CallID:
                                //               massegeWidget[index]
                                //                   .callid,
                                //               UserName: source.name,
                                //               email: source.email,
                                //             )));
                              }
                            },
                            icon: Icon(
                              Icons.video_camera_back,
                              color: Colors.blueAccent,
                            )),
                        onLongPress: () async {

                        },
                        onTap: () async {
                          try {
                            _firestore
                                .collection("callhistory")
                                .doc(massegeWidget[index].id)
                                .delete()
                                .then((value) => print("deleted"));
                          } catch (e) {
                            print(e);
                          }
                        },
                      )
                    ],
                  );
                } else {
                  return ListTile(
                    title: Text(massegeWidget[index].mycontactname),
                    subtitle: Row(
                      children: [
                        massegeWidget[index].sendtype == "outline"
                            ? Icon(
                          Icons.call_made,
                          color: Colors.green,
                        )
                            : Icon(
                          Icons.call_received,
                          color: Colors.blueAccent,
                        ),
                        Text(massegeWidget[index].time)
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          massegeWidget[index].profileIMG),
                    ),
                    trailing: massegeWidget[index].type == "audiocall"
                        ? Icon(
                      Icons.call,
                      color: Colors.blueAccent,
                    )
                        : Icon(
                      Icons.video_camera_back,
                      color: Colors.blueAccent,
                    ),
                    onTap: () async {
                      String chatroomID = "";
                      if (massegeWidget[index].type == "audiocall") {
                        try {
                          String id = DateTime.now().toString();
                          String idd = "$id-${source.email}";
                          await _firestore
                              .collection("callhistory")
                              .doc(idd)
                              .set({
                            'profileIMG': massegeWidget[index].profileIMG,
                            'time': DateTime.now()
                                .toString()
                                .substring(10, 16),
                            'myemail': source.email,
                            'mycontactemail':
                            massegeWidget[index].mycontactemail,
                            'type': 'audiocall',
                            'sendtype': 'outline',
                            'mycontactname':
                            massegeWidget[index].mycontactname,
                            'callid': massegeWidget[index].callid
                          });
                          id = DateTime.now().toString();
                          idd =
                          "$id-${massegeWidget[index].mycontactemail}";
                          await _firestore
                              .collection("callhistory")
                              .doc(idd)
                              .set({
                            'profileIMG': source.photo,
                            'time': DateTime.now()
                                .toString()
                                .substring(10, 16),
                            'myemail':
                            massegeWidget[index].mycontactemail,
                            'mycontactemail': source.email,
                            'type': 'audiocall',
                            'sendtype': 'incoming',
                            'mycontactname': source.name,
                            'callid': massegeWidget[index].callid
                          });
                        } catch (e) {
                          print(e);
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (builder) => AudioCallOneToOne(
                        //           massegeWidget[index].callid,
                        //           source.name,
                        //           source.email,
                        //         )));
                      } else {
                        try {
                          String id = DateTime.now().toString();
                          String idd = "$id-${source.email}";
                          await _firestore
                              .collection("callhistory")
                              .doc(idd)
                              .set({
                            'profileIMG': massegeWidget[index].profileIMG,
                            'time': DateTime.now()
                                .toString()
                                .substring(10, 16),
                            'myemail': source.email,
                            'mycontactemail':
                            massegeWidget[index].mycontactemail,
                            'type': 'vediocall',
                            'sendtype': 'outline',
                            'mycontactname':
                            massegeWidget[index].mycontactname,
                            'callid': massegeWidget[index].callid
                          });
                          id = DateTime.now().toString();
                          idd =
                          "$id-${massegeWidget[index].mycontactemail}";
                          await _firestore
                              .collection("callhistory")
                              .doc(idd)
                              .set({
                            'profileIMG': source.photo,
                            'time': DateTime.now()
                                .toString()
                                .substring(10, 16),
                            'myemail':
                            massegeWidget[index].mycontactemail,
                            'mycontactemail': source.email,
                            'type': 'vediocall',
                            'sendtype': 'incoming',
                            'mycontactname': source.name,
                            'callid': massegeWidget[index].callid
                          });
                        } catch (e) {
                          print(e);
                        }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (builder) => CallPage(
                        //           CallID: massegeWidget[index].callid,
                        //           UserName: source.name,
                        //           email: source.email,
                        //         )));
                      }
                    },
                  );
                }
              },
            )
                : Center(
              child: Text("لا تمتلك اي سجلات"),
            );
          }),
    );
  }


}
