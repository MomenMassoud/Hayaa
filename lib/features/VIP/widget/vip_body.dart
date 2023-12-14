import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';
import 'ListVip1.dart';


class VipBody extends StatefulWidget{
  _VipBody createState()=>_VipBody();
}


class _VipBody extends State<VipBody>with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("مركز VIP").tr(args: ['مركز VIP']),
        flexibleSpace: Container(
          height: screenHight * 0.12,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD700), // Gold
                Color(0xFF800080),
                Color(0xFF4B0082),
              ],
              begin: Alignment.topLeft,
              stops: [0.0, 0.5, 1.0],
              end: Alignment.topRight,
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFF800080),
              Color(0xFF4B0082),
            ],
            begin: Alignment.topLeft,
            stops: [0.0, 0.5, 1.0],
            end: Alignment.topRight,
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: <Widget>[
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: 30, top: 30),
                    unselectedLabelColor: Color(0xFF020202),
                    tabs: [
                      Tab(
                        child: Text('Vip1',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 16,
                            )),
                      ),
                      Tab(
                        child: Text('Vip2',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 16,
                            )),
                      ),
                      Tab(
                        child: Text('Vip3',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 16,
                            )),
                      ),
                      Tab(
                        child: Text('Vip4',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 16,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.vip,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: MediaQuery.of(context).size.height - 20.0,
                    width: double.infinity,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        VipList(), // Replace with your actual widget for Vip1
                        VipList(), // Replace with your actual widget for Vip2
                        VipList(), // Replace with your actual widget for Vip3
                        VipList(), // Replace with your actual widget for Vip4
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle button 1 press
                  },
                  child: Text('Button 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle button 2 press
                  },
                  child: Text('Button 2'),
                ),
                Text(
                  'Right Text',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 12,
                    color: Color(0xFFCDCDCD),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}