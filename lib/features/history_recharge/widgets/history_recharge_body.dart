import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../core/Utils/app_colors.dart';
import 'gold_history.dart';

class HistoryRechargeBody extends StatefulWidget{
  _HistoryRechargeBody createState()=>_HistoryRechargeBody();
}

class _HistoryRechargeBody extends State<HistoryRechargeBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("سجل الفواتير").tr(args: ['سجل الفواتير']),
        bottom: TabBar(
          indicatorPadding: EdgeInsets.all(5),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text("عملة",style: TextStyle(fontSize: 20),).tr(args: ['عملة']),
            ),
          ],
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.orange,
        ),
      ),
        key: _globalKey,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            GoldHistory(),
          ]
          ,)
    );
  }

}