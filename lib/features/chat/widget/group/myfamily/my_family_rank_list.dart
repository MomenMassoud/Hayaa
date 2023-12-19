import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/family_model.dart';
import '../../../../../core/Utils/app_images.dart';


class MyFamilyRankList extends StatefulWidget{
  String id;
  MyFamilyRankList(this.id);
  _MyFamilyRankList createState()=>_MyFamilyRankList();
}

class _MyFamilyRankList extends State<MyFamilyRankList>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.family))
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text("ترتيب العائلات",style: TextStyle(fontSize: 20,color: Colors.white),),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('family').snapshots(),
            builder: (context,snapshot){
              List<FamilyModel> familys=[];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                familys.add(
                    FamilyModel(
                        massege.get('name'),
                        massege.get('idd'),
                        massege.get('id'),
                        massege.get('bio'),
                        massege.get('join'),
                        massege.get('photo'))
                );
              }
              return Text("data",style: TextStyle(color: Colors.white),);
            },
          ),
        )
    );
  }

}