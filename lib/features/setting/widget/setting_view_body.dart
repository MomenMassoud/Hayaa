import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/splash/views/splash_view.dart';


class SettingViewBody extends StatefulWidget{
  _SettingViewBody createState()=>_SettingViewBody();
}

class _SettingViewBody extends State<SettingViewBody>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 227, 213,1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('الاعدادات',style: TextStyle(color: Colors.black),).tr(args: ['الاعدادات']),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Account Security"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.privacy_tip,color: Colors.blue,),
                  ),
                  ListTile(
                    title: Text("Privacy"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.lock,color: Colors.orangeAccent,),
                  ),
                  ListTile(
                    title: Text("تغير اللغة").tr(args: ['تغير اللغة']),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.language,color: Colors.greenAccent,),
                    onTap: (){
                      if(context.locale.languageCode=="en"){
                        _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                          'country':'DZ',
                          'lang':'ar'
                        }).then((value){
                          print("Switch");
                        });
                        context.setLocale(Locale("ar","DZ"));
                      }
                      else{
                        _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                          'country':'US',
                          'lang':'en'
                        }).then((value){
                          print("Switch");
                        });
                        context.setLocale(Locale("en","US"));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Help"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.question_mark_sharp,color: Colors.orangeAccent,),
                  ),
                  ListTile(
                    title: Text("feedback"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.email,color: Colors.lightBlue,),
                  ),
                  ListTile(
                    title: Text("About"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                    leading: Icon(Icons.tag_faces_sharp,color: Colors.greenAccent,),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text("Logout"),
                trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 12,),
                leading: Icon(Icons.logout,color: Colors.red,),
                onTap: ()async{
                  FirebaseAuth auth=FirebaseAuth.instance;
                  await auth.signOut();
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, SplashView.id);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}