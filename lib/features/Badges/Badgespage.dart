import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/Utils/app_images.dart';
import 'Achievements.dart';
import 'activity.dart';

class Badges extends StatefulWidget {
  const Badges({super.key});
  static const id = 'Badges';
  @override
  _BadgesState createState() => _BadgesState();
}

class _BadgesState extends State<Badges> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedImagePath = '';


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: screenHight * 0.2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.badges1), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "الشارات",
          style: TextStyle(color: Colors.white),
        ).tr(args: ['الشارات']),
        actions: [
          IconButton(
            icon: Icon(Icons.star, color: Colors.white),
            onPressed: () {
              // Add your icon action here
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add your icon action here
            },
          ),
        ],
      ),
      body: Container(
        height: screenHight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.badges2),
            // Replace with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(left: 1.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            // Circular image and text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: 160,bottom: 30,top: 300,right: 25),
                  child: Row(
                    children: [
                      selectedImagePath.isNotEmpty
                          ? Image.asset(
                        selectedImagePath,
                        //fit: BoxFit.fill,
                        scale: 1.2,
                      )
                          : Container(),
                      // Add any other widgets or text as needed
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            // TabBar and TabBarView
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.black,
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: 70),
                    unselectedLabelColor: Color(0xFFCDCDCD),
                    tabs: [
                      Tab(
                        child: Text('مدلياتي',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 25.0,
                            )).tr(args: ['مدلياتي']),
                      ),
                      Tab(
                        child: Text('نشاط',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 25.0,
                            )).tr(args: ['نشاط']),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 50.0,
                    width: double.infinity,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Replace these with your actual widgets
                        Achievements(
                          onImageTap: (path) {
                            // Update the selected image path
                            setState(() {
                              selectedImagePath = path;
                            });
                          },),
                        activity(
                          onImageTap: (path) {
                            // Update the selected image path
                            setState(() {
                              selectedImagePath = path;
                            });
                          },
                        ),
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
