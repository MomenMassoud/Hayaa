import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';



class SaleryBody extends StatefulWidget{
  _SaleryBody createState()=>_SaleryBody();
}


class _SaleryBody extends State<SaleryBody>{
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 243, 255, 1),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("دخل",style: TextStyle(fontSize: 16,color: Colors.black),).tr(args: ['دخل']),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream:_auth.currentUser!.email==null? _firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.phoneNumber).snapshots():_firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.email).snapshots(),
        builder: (context,snapshot){
          String daimond="";
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            daimond=massege.get('daimond');
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 13),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("الالماس المتاح",style: TextStyle(color: Colors.grey),).tr(args: ['الالماس المتاح']),
                      Divider(thickness: 2),
                      ListTile(
                        title: Text(daimond),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(AppImages.daimond),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      )
    );
  }
  
}