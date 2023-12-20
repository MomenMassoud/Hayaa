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
        title: Text("مركز VIP" ,style: TextStyle(
            color: Colors.white
        ),).tr(args: ['مركز VIP']),
        // backgroundColor:  Color(0xFF3F3B3B),
        flexibleSpace: Container(
          height: screenHight * 0.12,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/core/Utils/assets/images/vip2.jpeg'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/core/Utils/assets/images/vip2.jpeg'),
            // Replace with your image asset
            fit: BoxFit.cover,
          ),
        ),
        // Set the width to fill the available space
        height: double.infinity,
        child: ListView(
          children: <Widget>[
            DefaultTabController(
              initialIndex: 1,
              length: 8,
              child: Column(
                children: [
                  SizedBox(height:10),
                  TabBar(
                    indicatorWeight: 5,
                    indicatorColor: Colors.yellow,
                    //controller: _tabController,
                    // indicatorColor: Colors.yellow,
                    // labelColor: Colors.yellow,
                    //   isScrollable: true,

                    // unselectedLabelColor: Color(0xFF020202),
                    tabs: [
                      Tab(
                        child: Text('Vip1',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 16,
                                color: Colors.white54
                            )),
                      ),
                      Tab(
                        child: Text('Vip2',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 16,
                                color: Colors.white54
                            )),
                      ),
                      Tab(
                        child: Text('Vip3',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 16,
                                color: Colors.white54
                            )),
                      ),
                      Tab(
                        child: Text('Vip4',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 16,
                                color: Colors.white54
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
                        'lib/core/Utils/assets/images/Vip/4b.png',
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
                      //  controller: _tabController,
                      children: [
                        VipList(), // Replace with your actual widget for Vip1
                        VipList(), // Replace with your actual widget for Vip2
                        VipList(), // Replace with your actual widget for Vip3
                        VipList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}