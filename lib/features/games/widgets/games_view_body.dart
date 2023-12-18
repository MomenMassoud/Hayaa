import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_colors.dart';
import 'games.dart';
import 'more_games.dart';

class GamesViewBody extends StatefulWidget {
  _GamesViewBody createState()=>_GamesViewBody();
}

class _GamesViewBody extends State<GamesViewBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: screenHight * 0.12,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              TabBar(
                isScrollable: true,
                controller: _tabController,
                  labelColor: Colors.white, // Color of the selected tab label// Color of unselected tab labels
                  indicatorColor: Colors.orange,
                  indicatorSize: TabBarIndicatorSize.label,
                  enableFeedback: true,
                  tabs:<Widget> [
                    Tab(child:SizedBox(
                      width: screenWidth * 0.12,
                      child:  Text(
                        "لعبة",
                        style: TextStyle(fontFamily: "Hayah", fontSize: 20,color: Colors.white),
                      ).tr(args: ['لعبة']),
                    ),),
                    Tab(child:SizedBox(
                      width: screenWidth * 0.12,
                      child:  Text(
                        "اكثر",
                        style: TextStyle(fontFamily: "Hayah", fontSize: 20,color: Colors.white),
                      ).tr(args: ['اكثر']),
                    ),),
                  ]
              ),
            ],
          ),
        ],
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.emoji_events_outlined,color: Colors.white,)),
      ),
      // body: TabBarView(
      //   controller: _tabController,
      //     children: <Widget>[
      //       Games(),
      //       MoreGames()
      //     ]
      // ),
      body: Center(
        child: Text("Common Soon!",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.grey),),
      ),
    );
  }
}
