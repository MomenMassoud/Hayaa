import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/agencies/models/host_model.dart';
class HostsListItem extends StatelessWidget {
   HostsListItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight, required this.hostModel,
  });

  final double screenWidth;
  final double screenHeight;
  final HostModel hostModel;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.1,
      decoration:  BoxDecoration(),
      child: Center(
          child: Row(
        children: [
          Container(
            width: screenWidth * 0.1,
            decoration:  BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: CachedNetworkImageProvider(hostModel.hostImage))),
          ),
          const SizedBox(
            width: 10,
          ),
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hostModel.hostName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("ID :${hostModel.hostId}"),
            ],
          ),
          const Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: ()async{
                String id="";
                String hostID="";
                await _firestore.collection('user').doc(hostModel.doc).update({
                  'myagent':'',
                  'type':'normal',
                }).then((value){
                  _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((value){
                    id=value.get('myagent');
                  }).then((value){
                    _firestore.collection('agency').doc(id).collection('users').where('userid',isEqualTo: hostModel.doc).get().then((value){
                      hostID=value.docs[0].id;
                    }).then((value){
                      _firestore.collection('agency').doc(id).collection('users').doc(hostID).delete();
                    });
                  });
                });
              },
              child: const Text(
                "Remove",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      )),
    );
  }
}
