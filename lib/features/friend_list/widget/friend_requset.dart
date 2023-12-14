import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/friend_requst_model.dart';

class FriendReuest extends StatefulWidget {
  static const id = "FriendReuest";
  _FriendRequest createState() => _FriendRequest();
}

class _FriendRequest extends State<FriendReuest> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String id = "";
  String docID="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
  }
  void getID()async{
    await _firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.email).get().then((value){
      setState(() {
        id=value.docs[0].get('id');
        docID=value.docs[0].id;
        print(id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ادارة طلبات الصداقة",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('friendreq')
            .where('owner', isEqualTo: id)
            .snapshots(),
        builder: (context, snapshot) {
          List<FriendReqModel> request = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            FriendReqModel req=FriendReqModel(massege.get("owner"), massege.get("sender"), massege.get("senderName"), massege.get("senderPhoto"), massege.id);
            request.add(req);
          }
          return request.length>0?ListView.builder(
            itemCount: request.length,
            itemBuilder: (context,index){
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(request[index].SenderPhoto),
                ),
                title: Text(request[index].SenderName),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(onPressed: (){
                      AcceptReuest(request[index]);
                    }, child: Text("قبول")),
                    ElevatedButton(onPressed: (){}, child: Text("رفض"))
                  ],
                ),
              );
            },
          ):Center(child: Text("لا توجد اي طلبات صداقة"),);
        },
      ),
    );
  }
  void AcceptReuest(FriendReqModel req)async{
    String friend="";
    await _firestore.collection('user').doc(docID).collection('friends').doc(req.Sender).set({
      'id':req.Sender
    }).then((value){
      _firestore.collection('user').where('id',isEqualTo: req.Sender).get().then((value){
        friend=value.docs[0].id;
      }).then((value){
        _firestore.collection('user').doc(friend).collection('friends').doc(docID).set({
          'id':docID
        }).then((value){
          _firestore.collection('friendreq').doc(req.doc).delete().then((value){
            print("Deleted Request And Accept Friend");
          });
        });
      });
    });
  }
  void RejectRequest(FriendReqModel req)async{
    await _firestore.collection('friendreq').doc(req.doc).delete().then((value){
      print("Deleted Request And Reject Friend");
    });
  }
}
