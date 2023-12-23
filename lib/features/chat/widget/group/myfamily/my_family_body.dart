import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/features/chat/widget/group/contribution/family_member_rank.dart';
import 'package:hayaa_main/features/chat/widget/group/gravity/gravity_body.dart';
import 'package:hayaa_main/features/chat/widget/group/myfamily/list_member_family.dart';
import 'package:hayaa_main/features/chat/widget/group/myfamily/my_family_rank_list.dart';
import 'package:hayaa_main/features/chat/widget/group/myfamily/my_family_request.dart';
import 'package:hayaa_main/features/chat/widget/group/myfamily/send_invite_family.dart';
import 'package:hayaa_main/models/family_model.dart';
import 'package:hayaa_main/models/family_user_model.dart';

class MyFamilyBody extends StatefulWidget {
  static const id = 'MyFamilyBody';
  const MyFamilyBody({super.key});
  _MyFamilyBody createState() => _MyFamilyBody();
}

class _MyFamilyBody extends State<MyFamilyBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mytype = "";
  String familyID = "";
  int req=0;
  int total=0;
  int level=0;
  late FamilyModel familyModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFamilyName();
    getLevelFamily();
  }
  void getLevelFamily()async{


  }

  void getFamilyName() async {
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      setState(() {
        familyID = snap.get('myfamily');
      });
      await for(var snap in _firestore.collection('family').doc(familyID).collection('count').snapshots()){
        for(int i=0;i<snap.size;i++){
          total+=int.parse(snap.docs[i].get('coin'));
          print(total);
        }
        int j=0;
        while(j==0){
          if(total>=1000){
            total=total-1000;
            level+=1;
          }
          else{
            break;
          }
        }
        print('level $level');
        _firestore.collection('family').doc(familyID).update({
          'level':level.toString()
        }).then((value){
          setState(() {
            level;
            total;
          });
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(AppImages.family6))
      ),
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
          actions: [
            Row(
              children: [
                Text("ارسال دعوة",style: TextStyle(fontSize: 18,color: Colors.white),),
                IconButton(onPressed: (){
                  if(mytype=="owner"){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SendInviteFamily(familyID)));
                  }
                },
                    icon: Icon(Icons.add,color: Colors.white,)
                ),
              ],
            ),
            IconButton(onPressed: (){
              if(mytype=="owner"){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyFamilyRequest(familyID)));
              }
            },
                icon: Icon(Icons.mail,color: Colors.white,)
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('family')
              .where('id', isEqualTo: familyID)
              .snapshots(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              familyModel = FamilyModel(
                  massege.get('name'),
                  massege.get('idd'),
                  massege.get('id'),
                  massege.get('bio'),
                  massege.get('join'),
                  massege.get('photo'));

            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('family')
                  .doc(familyID)
                  .collection('user')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  if(massege.get('user')==_auth.currentUser!.uid){
                    mytype=massege.get('type');
                  }
                  familyModel.users.add(
                    FamilyUserModel(massege.id, massege.get('type'),massege.get('user'))
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                image: DecorationImage(image: CachedNetworkImageProvider(familyModel.photo))
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(familyModel.name,style: TextStyle(color: Colors.white),),
                          Text("ID: ${familyModel.id},",style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Level $level',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 10,
                                  width: 250,
                                  child: LinearProgressIndicator(
                                    value: (total/1000), // percent filled
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ),
                              Text('Level ${level+1}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          Text("تعريف العائلة:",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text(familyModel.bio,style: TextStyle(fontSize: 16,color: Colors.grey),)
                        ],
                      ),
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          Text("غرف العائلة:",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      ),
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          Text("ترتيب اعضاء العائلة",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)
                        ],
                      ),
                      ListTile(
                        title: Text("ترتيب المساهمة",style: TextStyle(fontSize: 18,color: Colors.white),),
                        subtitle: Text("مشاهدة ترتيب اعضاء المساهمة",style: TextStyle(color: Colors.white),),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white),
                        leading: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadiusDirectional.circular(10)
                            ),
                            child: Icon(Icons.favorite,color: Colors.white,)
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FamilyMemeberRank(familyID)));
                        },
                      ),
                      ListTile(
                        title: Text("ترتيب الكاريزما",style: TextStyle(fontSize: 18,color: Colors.white),),
                        subtitle: Text("مشاهدة ترتيب اعضاء الكاريزما",style: TextStyle(color: Colors.white),),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white),
                        leading: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.purpleAccent,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadiusDirectional.circular(10)
                            ),
                            child: Icon(Icons.recommend,color: Colors.white,)
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => GravityBody(familyID)));
                        },
                      ),
                      SizedBox(height: 50,),
                      ListTile(
                        title: Text("اعضاء العائلة",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                        subtitle: Text("مشاهدة جميع اعضاء العائلة",style: TextStyle(color: Colors.white),),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ListMemberFamily(familyID)));
                        },
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Colors.red
                            ),
                          ),
                          onPressed: (){
                            Allarm();
                          },
                          child: Text("مغادرة العائلة",style: TextStyle(fontSize: 20,color: Colors.white),))
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("هل انت متاكد من مغادرة هذه العائلة",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        int count=0; String mydoc="";String mytype="";
                       for(int i=0;i<familyModel.users.length;i++){
                         if(familyModel.users[i].id!=_auth.currentUser!.uid){
                           if(familyModel.users[i].type=="owner" || familyModel.users[i].type=="admin"){
                             count++;
                           }
                         }
                         else{
                           mydoc=familyModel.users[i].doc;
                           mytype=familyModel.users[i].type;
                         }
                       }
                       if(mytype!="owner"){
                         await _firestore.collection('family').doc(familyID).collection('user').doc(mydoc).delete().then((value){
                           _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                             'myfamily':''
                           }).then((value){
                             Navigator.pop(context);
                             LeaveDone();
                           });
                         });
                       }
                       else if(count==0){
                         Navigator.pop(context);
                         LeaveCancell();
                       }
                       else{
                         await _firestore.collection('family').doc(familyID).collection('user').doc(mydoc).delete().then((value){
                           _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                             'myfamily':''
                           }).then((value){
                             Navigator.pop(context);
                             LeaveDone();
                           });
                         });

                       }
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
  void LeaveDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                height: 120,
                child: Center(
                  child: Text("تم مغادرة العائلة"),
                ),
              )
          );
        });
  }
  void LeaveCancell() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ناسف لا يوجد مسؤول او مالك غيرك"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("قم بترقيى عضو ليصبح مسؤول لتستطيع المغادرة"),
                ),
              )
          );
        });
  }
}
