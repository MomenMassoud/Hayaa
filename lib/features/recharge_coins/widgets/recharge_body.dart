import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  int coin=0;
  int daimond=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    getCharge();
  }
  void getCharge()async{
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).snapshots()){
      coin=int.parse(snap.get('coin'));
      daimond=int.parse(snap.get('daimond'));
      setState(() {
        coin;
        daimond;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180.0),
        child: AppBar(
          backgroundColor: Colors.blueAccent,
          title:Text(
            "Google Wallet",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              indicatorPadding: EdgeInsets.all(5),
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(AppImages.gold_coin),
                        radius: 20,
                      ),
                      SizedBox(width: 7,),
                      Text(coin.toString(),style: TextStyle(fontSize: 20),),

                    ],
                  ),
                ),
              ],
              labelColor: Colors.white, // Color of the selected tab label// Color of unselected tab labels
              indicatorColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,

            ),
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, HistoryRechargeView.id);
            }, icon: Icon(Icons.receipt_long_outlined)),
          ],
        ),
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