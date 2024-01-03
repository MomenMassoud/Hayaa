import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';


class UserLevelCharming extends StatefulWidget{
  _UserLevelCharming createState()=>_UserLevelCharming();
}

class _UserLevelCharming extends State<UserLevelCharming>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  int level=0;
  int exp=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserLevel();
  }
  void setUserLevel()async{
    await for (var snap in _firestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .snapshots()) {
      double convert=double.parse(snap.get('exp2'));
      exp=convert.toInt();
      level=int.parse(snap.get('level2'));
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
        'exp2':exp.toString(),
        'level2':level.toString(),
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
            userModel.exp2=massege.get('exp2');
            userModel.level2=massege.get('level2');
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
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                             int.parse(userModel.level2)>=1 && int.parse(userModel.level2)<20?AppImages.charm1to19Main:
                             int.parse(userModel.level2)>=20 &&int.parse(userModel.level2)<40?AppImages.charm20to39Main:
                             int.parse(userModel.level2)>=40 && int.parse(userModel.level2)<50?AppImages.charm40to49Main:
                             int.parse(userModel.level2)>=50 && int.parse(userModel.level2)<60?AppImages.charm50to59Main:
                             int.parse(userModel.level2)>=60 && int.parse(userModel.level2)<70?AppImages.charm60to69Main:
                             int.parse(userModel.level2)>=70 && int.parse(userModel.level2)<80?AppImages.charm70to79Main:
                             int.parse(userModel.level2)>=80 && int.parse(userModel.level2)<90?AppImages.charm80to89Main:
                             int.parse(userModel.level2)>=90&&int.parse(userModel.level2)<100?AppImages.charm90to99Main:
                             int.parse(userModel.level2)>=100 && int.parse(userModel.level2)<126?AppImages.charm100to125Main:
                                 AppImages.charm126to150Main
                          ),
                          Center(
                            child: Text("${userModel.level2}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                    'Lv.${userModel.level2}',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 10,
                      width: 250,
                      child: LinearProgressIndicator(
                        semanticsValue: userModel.exp2,
                        semanticsLabel: userModel.exp2,
                        value: (double.parse(userModel.exp2)/1000), // percent filled
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    'Lv.${int.parse(userModel.level2)+1}',
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
                        title:Text("استلام هدية") ,
                        subtitle: Text('4 Daimond = 1EXP'),
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
                        title:Text("استلام دخولية") ,
                        subtitle: Text('4 Daimond = 1EXP'),
                        leading: CircleAvatar(
                          child: Icon(Icons.car_repair,color: Colors.white),
                          backgroundColor: Colors.pink.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0,left: 50,top: 6),
                        child: Divider(thickness: 1,),
                      ),
                      ListTile(
                        title:Text("استلام اطار") ,
                        subtitle: Text('4 Daimond = 1EXP'),
                        leading: CircleAvatar(
                          child: Icon(Icons.person,color: Colors.white),
                          backgroundColor: Colors.purple.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0,left: 50,top: 6),
                        child: Divider(thickness: 1,),
                      ),
                      ListTile(
                        title:Text("استلام استقراطية") ,
                        subtitle: Text('4 Daimond = 1EXP'),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(AppImages.crown),
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

}