import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/store/widget/car_store.dart';
import 'package:hayaa_main/features/store/widget/freams_store.dart';
import 'package:hayaa_main/features/store/widget/head_store.dart';
import 'package:hayaa_main/features/store/widget/wallpaper_store.dart';

class StoreBody extends StatefulWidget{
  _StoreBody createState()=>_StoreBody();
}

class _StoreBody extends State<StoreBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('مركز تجاري',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 30.0,
                color: Color(0xFF545D68))).tr(args: ['مركز تجاري']),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: Color(0xFFC88D67),
            isScrollable: true,
            labelPadding: EdgeInsets.only(right: 45.0),
            unselectedLabelColor: Color(0xFFCDCDCD),
            tabs: [
              Tab(
                child: Text('خلفيات',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 21.0,
                    )).tr(args: ['رمز تعبيري']),
              ),
              Tab(
                child: Text('السيارات',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 21.0,
                    )).tr(args: ['السيارات']),
              ),
              Tab(
                child: Text('مول الراس',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 21.0,
                    )).tr(args: ['مول الراس']),
              ),
              Tab(
                child: Text('فقاعه',
                    style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 21.0,
                    )).tr(args: ['فقاعه']),
              ),
            ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          WallpaperStore(),
          CarStoreList(),
          FrameStore(),
          HeadStore(),
        ],
      ),
    );
  }

}