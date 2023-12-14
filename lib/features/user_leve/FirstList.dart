import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/Utils/app_images.dart';
import 'ScrollList.dart';
class FirstList extends StatefulWidget {
  const FirstList({super.key});
  static const id = 'FirstList';
  @override
  _FirstListState createState() => _FirstListState();
}

class _FirstListState extends State<FirstList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0.0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          labelColor:Colors.white,
          unselectedLabelColor: Colors.black, //0xFF020202
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
      backgroundColor: Colors.purple,
      body: ListView(
        padding: EdgeInsets.only(left: 1.0),
        children: <Widget>[
          SizedBox(height: 50.0),
          // Circular image and text
          DefaultTabController(
            length: 2,
            child: Column(
              children: [

                SizedBox(height: 40.0),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Clip the container to a circle
                    border: Border.all(
                      color: Colors.brown, // Add a border color if desired
                      width: 2.0, // Specify the border width
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppImages.momen,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover, // Adjust the fit based on your needs
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      'Lv.1',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(width: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 10,
                        width: 250,
                        child: LinearProgressIndicator(
                          value: 0.2, // percent filled
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          backgroundColor: Color(0xFFFFDAB8),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),// Adjust the width between the texts as needed
                    Text(
                      'Lv.0',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),

                SizedBox(height: 10.0),

                Text(
                  'يلزم 700 من نقاط الخبره للترثقه',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ).tr(args: ['يلزم 700 من نقاط الخبره للترثقه']),
                SizedBox(height: 30.0),
                Container(
                  height: MediaQuery.of(context).size.height - 20.0,
                  width: double.infinity,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ScrollList(),
                      ScrollList()
                      // Replace these with your actual widgets
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Clip the container to a circle
                  border: Border.all(
                    color: Colors.black, // Add a border color if desired
                    width: 2.0, // Specify the border width
                  ),
                ),

              ),
            ],
          ),
        ],
      ),
    );
  }
}
