import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'EmojiList.dart';
import 'CarStore.dart';
import 'HeadMoll.dart';
import 'bubble.dart';
class ListViewStore extends StatefulWidget {
  static const id = 'ListViewStore';
  const ListViewStore({super.key});
  @override
  ListViewStoreState createState() =>ListViewStoreState();
}

class ListViewStoreState extends State<ListViewStore>
    with SingleTickerProviderStateMixin {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Color(0xFF545D68)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.0),
        children: <Widget>[
          SizedBox(height: 15.0),
          TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: Text('رمز تعبيري',
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
          Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              child: TabBarView(
                  controller: _tabController,
                  children: [
                    EmojiList(),
                    CarStore(),
                    HeadMoll(),
                    bubble()
                  ]
              )
          )
        ],
      ),
    );
  }
}
