import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../view/followers_view.dart';
import '../view/friends_view.dart';
import '../view/likers_view.dart';


class FriendListBody  extends StatefulWidget{
  _FriendListBody createState()=>_FriendListBody();
}

class _FriendListBody extends State<FriendListBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  String Title="";
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
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
          _tabController.index==0?"الاصدقاء(5)".tr(args: ['الاصدقاء(5)']):_tabController.index==1?"تمت المتابة(6)".tr(args: ['تمت المتابة(6)']):"المعجبون(20)".tr(args: ['المعجبون(20)']),
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
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.black,))
        ],
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