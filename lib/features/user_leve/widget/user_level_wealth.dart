import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';

class UserLevelWealth extends StatefulWidget {
  _UserLevelWealth createState() => _UserLevelWealth();
}

class _UserLevelWealth extends State<UserLevelWealth> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int level = 0;
  int exp = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserLevel();
  }

  void setUserLevel() async {
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      exp=int.parse(snap.get('exp'));
      level=int.parse(snap.get('level'));
      int i=0;
      while(i==0){
        if(exp>=1000){
          level=level+1;
          exp=exp-1000;
        }
        else{
          break;
        }
      }
      _firestore.collection('user').doc(_auth.currentUser!.uid).update({
        'exp':exp.toString(),
        'level':level.toString(),
      });
      setState(() {
        exp;
        level;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .where('doc', isEqualTo: _auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            UserModel userModel=UserModel("email", "name", "gende", "photo", "id", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              userModel.bio=massege.get('bio');
              userModel.birthdate=massege.get('birthdate');
              userModel.coin=massege.get('coin');
              userModel.country=massege.get('country');
              userModel.daimond=massege.get('daimond');
              userModel.coin=massege.get('coin');
              userModel.devicetoken=massege.get('devicetoken');
              userModel.email=massege.get('email');
              userModel.exp=massege.get('exp');
              userModel.gender=massege.get('gender');
              userModel.id=massege.get('id');
              userModel.lang=massege.get('lang');
              userModel.level=massege.get('level');
              userModel.name=massege.get('name');
              userModel.phonenumber=massege.get('phonenumber');
              userModel.photo=massege.get('photo');
              userModel.seen=massege.get('seen');
              userModel.type=massege.get('type');
              userModel.vip=massege.get('vip');
              userModel.docID=massege.id;
            }
            print(1-(int.parse(userModel.exp)/1000));
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Clip the container to a circle
                        ),
                        child: Stack(
                          children: [
                            SVGASimpleImage(
                              resUrl: "https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/gifts%2F30977485Eid%20al-Fitr3.svga?alt=media&token=a149e1da-da01-45dc-b434-a62c9789a9d8",
                            ),
                            Center(
                              child: Text("Level ${userModel.level}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 19.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Lv.${userModel.level}',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 10,
                        width: 250,
                        child: LinearProgressIndicator(
                          semanticsValue: userModel.exp,
                          semanticsLabel: userModel.exp,
                          value: (int.parse(userModel.exp)/1000), // percent filled
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      'Lv.${int.parse(userModel.level)+1}',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 19,),
                    Text(
                      'يلزم ${1000-int.parse(userModel.exp)} من نقاط الخبره للترثقه',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ).tr(args: ['يلزم 700 من نقاط الخبره للترثقه']),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("كيف تتم الترقية",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)],),
                        ),
                        ListTile(
                          title:Text("ارسال هدية") ,
                          subtitle: Text('1 Daimond = 1EXP'),
                          leading: CircleAvatar(
                            child: Icon(Icons.card_giftcard,color: Colors.white),
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50.0,left: 50,top: 6),
                          child: Divider(thickness: 1,),
                        ),
                        ListTile(
                          title:Text("شراء دخولية") ,
                          subtitle: Text('1 Daimond = 1EXP'),
                          leading: CircleAvatar(
                            child: Icon(IconData(0xf012,fontFamily: 'MaterialIcons'),color: Colors.white),
                            backgroundColor: Colors.pink.shade400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50.0,left: 50,top: 6),
                          child: Divider(thickness: 1,),
                        ),
                        ListTile(
                          title:Text("شراء اطار") ,
                          subtitle: Text('1 Daimond = 1EXP'),
                          leading: CircleAvatar(
                            child: Icon(IconData(0xf27b,fontFamily: 'MaterialIcons'),color: Colors.white),
                            backgroundColor: Colors.purple.shade400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50.0,left: 50,top: 6),
                          child: Divider(thickness: 1,),
                        ),
                        ListTile(
                          title:Text("شراء استقراطية") ,
                          subtitle: Text('1 Daimond = 1EXP'),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(AppImages.crown),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
