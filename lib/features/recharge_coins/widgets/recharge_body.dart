import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../history_recharge/view/history_recharge_view.dart';
import 'gold_coin.dart';


class RechargeBody extends StatefulWidget{
  const RechargeBody({super.key});
  _RechargeBody createState()=>_RechargeBody();
}

class _RechargeBody extends State<RechargeBody>with SingleTickerProviderStateMixin{
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "Google Wallet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              CircleAvatar(
                radius: 9,
                backgroundImage: AssetImage(AppImages.gold_coin),
              ),
              Text(
                "60",
                style: TextStyle(
                    fontSize: 12
                ),
              ),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              CircleAvatar(
                radius: 9,
                backgroundImage: AssetImage(AppImages.silver_coin),
              ),
              Text(
                "560",
                style: TextStyle(
                    fontSize: 12
                ),
              ),
            ],)
          ],
        ),
        bottom: TabBar(
          indicatorPadding: EdgeInsets.all(5),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text("عملة",style: TextStyle(fontSize: 20),).tr(args: ['عملة']),
            ),
          ],
          labelColor: Colors.white, // Color of the selected tab label// Color of unselected tab labels
          indicatorColor: Colors.orange,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, HistoryRechargeView.id);
          }, icon: Icon(Icons.receipt_long_outlined))
        ],
      ),
      key: _globalKey,
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          GoldCoin(),
        ]
        ,)
    );
  }

}