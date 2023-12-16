import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/user_leve/widget/user_level_charming.dart';
import 'package:hayaa_main/features/user_leve/widget/user_level_wealth.dart';


class UserLevelBody extends StatefulWidget{
  _UserLevelBody createState()=>_UserLevelBody();
}

class _UserLevelBody extends State<UserLevelBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print("Current Tab Index: ${_tabController.index}");
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _tabController.index==0?Colors.orange:Colors.purple,
        elevation: 0.0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          labelColor:Colors.white,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          enableFeedback: true,
          indicatorPadding: EdgeInsets.all(5),
          indicatorWeight: 0.3,
          tabs: [
            Tab(
              child: Text('الثروه',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 25.0,
                  )).tr(args: ['الثروه']),
            ),
            Tab(
              child: Text('روعه',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 25.0,
                  )).tr(args: ['روعه']),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.orange,
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            UserLevelWealth(),
            UserLevelCharming()
          ]
      ),
    );
  }

}