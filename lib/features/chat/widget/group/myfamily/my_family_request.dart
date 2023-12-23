import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/user_model.dart';

import '../../../../../core/Utils/app_images.dart';


class MyFamilyRequest extends StatefulWidget{
  String familyID;
  MyFamilyRequest(this.familyID);
  _MyFamilyRequest createState()=>_MyFamilyRequest();
}

class _MyFamilyRequest extends State<MyFamilyRequest>{
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
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp,color: Colors.white,)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text("Join Request",style: TextStyle(color: Colors.white),),
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('family').doc(widget.familyID).collection('req').snapshots(),
            builder: (context,snapshot){
              List<UserModel> users=[];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                UserModel us=UserModel("email", "name", "gender", "photo", "massege.id", "phonenumber",massege.id, "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
                us.devicetoken=massege.id;
                us.docID=massege.get('id');
                users.add(us);
              }
              return users.length>0?ListView.builder(
                itemCount: users.length,
                itemBuilder: (context,index){
                   return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('user').where('doc',isEqualTo: users[index].docID).snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed){
                        users[index].bio=massege.get('bio');
                        users[index].birthdate=massege.get('birthdate');
                        users[index].coin=massege.get('coin');
                        users[index].country=massege.get('country');
                        users[index].daimond=massege.get('daimond');
                        users[index].coin=massege.get('coin');
                        users[index].email=massege.get('email');
                        users[index].exp=massege.get('exp');
                        users[index].gender=massege.get('gender');
                        users[index].id=massege.get('id');
                        users[index].lang=massege.get('lang');
                        users[index].level=massege.get('level');
                        users[index].name=massege.get('name');
                        users[index].phonenumber=massege.get('phonenumber');
                        users[index].photo=massege.get('photo');
                        users[index].seen=massege.get('seen');
                        users[index].type=massege.get('type');
                        users[index].vip=massege.get('vip');
                        users[index].docID=massege.id;
                        users[index].myfamily=massege.get('myfamily');
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(users[index].name,style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(users[index].photo),
                              ),
                              subtitle: Text("BIO: ${users[index].bio}  - ID: ${users[index].id}",style: TextStyle(color: Colors.white),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(onPressed: (){
                                    Allarm(users[index]);
                                  }, child: Text("قبول")),
                                  ElevatedButton(onPressed: (){
                                    Allarm2(users[index]);
                                  }, child: Text("رفض")),
                                ],
                              ),
                            ),
                            Divider(thickness: 0.5,)
                          ],
                        ),
                      );
                    },
                   );
                },
              ):Center(
                child: Text("لا يوجد اي طلبات انضمام",style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
              );
            },
          ),
        ),
    );
  }
  void Allarm(UserModel docs) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("هل انت متاكد من قبول هذا المستخدم في العائلة"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        await _firestore.collection('user').doc(docs.docID).update({
                          'myfamily':widget.familyID
                        }).then((value){
                          _firestore.collection('family').doc(widget.familyID).collection('user').doc().set({
                            'user':docs.docID,
                            'type':'member'
                          }).then((value){
                            _firestore.collection('family').doc(widget.familyID).collection('req').doc(docs.devicetoken).delete();
                          }).then((value){
                            Navigator.pop(context);
                          });
                        });
                      }, child: Text("نعم")),
                      ElevatedButton(onPressed: ()async{
                        await _firestore.collection('family').doc(widget.familyID).collection('req').doc(docs.devicetoken).delete();
                      }, child: Text("لا")),
                    ],
                  )
                ],
              )
          );
        });
  }
  void Allarm2(UserModel docs) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("هل انت متاكد من رفض هذا العضو"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        await _firestore.collection('family').doc(widget.familyID).collection('req').doc(docs.devicetoken).delete().then((value){
                         Navigator.pop(context);
                         ReqCancell();
                        });
                      }, child: Text("نعم")),
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("لا")),
                    ],
                  )
                ],
              )
          );
        });
  }
  void ReqDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                height: 120,
                child: Center(
                  child: Text("تم اضافة العضو الي العائلة"),
                ),
              )
          );
        });
  }
  void ReqCancell() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                height: 120,
                child: Center(
                  child: Text("تم رفض انضمام العضو"),
                ),
              )
          );
        });
  }

}