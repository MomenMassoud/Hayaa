import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/user_model.dart';
import '../view/followers_view.dart';
import '../view/friends_view.dart';
import '../view/likers_view.dart';


class FriendListBody  extends StatefulWidget{
  UserModel user;
  FriendListBody(this.user);
  _FriendListBody createState()=>_FriendListBody();
}

class _FriendListBody extends State<FriendListBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  String Title="";
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  int friend=0;
  int follow=0;
  int fans=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      print("Current Tab Index: ${_tabController.index}");
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        key: _globalKey,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          _tabController.index==0?"اصدقاء".tr(args: ['اصدقاء']):_tabController.index==1?"تمت المتابعة".tr(args: ['تمت المتابعة']):"المعجبون".tr(args: ['المعجبون']),
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
            controller: _tabController,
            tabs:<Widget>[
              Tab(
                child: Text("اصدقاء",style: TextStyle(fontSize: 20,color: Colors.black),).tr(args: ['اصدقاء']),
              ),
              Tab(
                child: Text("تمت المتابعة",style: TextStyle(fontSize: 20,color: Colors.black),).tr(args: ['تمت المتابعة']),
              ),
              Tab(
                child: Text("المعجبون",style: TextStyle(fontSize: 20,color: Colors.black),).tr(args: ['المعجبون']),
              ),
            ],
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.orange,
        ),
      ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            FriendsView(),
            FollowersView(),
            LikerView(),
          ]
          ,)
    );
  }

}