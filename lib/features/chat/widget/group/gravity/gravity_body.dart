import 'package:flutter/material.dart';
import 'package:hayaa_main/features/chat/widget/group/gravity/gravity_all.dart';
import 'package:hayaa_main/features/chat/widget/group/gravity/gravity_day.dart';
import '../../../../../core/Utils/app_images.dart';
import 'gravity_month.dart';

class GravityBody extends StatefulWidget{
  String id;
  GravityBody(this.id);
  _GravityBody createState()=>_GravityBody();
}


class _GravityBody extends State<GravityBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(AppImages.family))
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("ترتيب الجاذبية",style: TextStyle(color: Colors.white),),
          elevation: 0.0,
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp,color: Colors.white,)),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Color(0xFFC88D67),
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: [
                Tab(
                    child: Text('الكل',
                        style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 21.0,
                        ))),
                Tab(
                    child: Text('يومي',
                        style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 21.0,
                        ))),
                Tab(
                    child: Text('شهري',
                        style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 21.0,
                        ))),

              ]
          ),
        ),
        backgroundColor: Colors.transparent,
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            GravityAll(widget.id),
            GravityDay(widget.id),
            GravityMonth(widget.id),
          ],
        ),
      ),
    );
  }

}