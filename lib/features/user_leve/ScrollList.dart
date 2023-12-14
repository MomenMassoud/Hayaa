import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/Utils/app_images.dart';

class ScrollList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'مكافاه المستوي',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ).tr(args: ['مكافاه المستوي']),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'السيارات',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ).tr(args: ['السيارات']),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(
                  ' ${'ايام'.tr(args: ['ايام'])}   $index',
                  AppImages.car1,
                  context,
                );
              },
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'ايطار',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 220.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(
                  'Item $index',
                  AppImages.db22,
                  context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String name, String imgPath, context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xC59B9292),
                spreadRadius: 5.0,
                blurRadius: 6.0,
              )
            ],
            color: Color(0xD7FFFFFF),
          ),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(5.0)),
              Hero(
                tag: imgPath,
                child: Container(
                  height: 120.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imgPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Color(0xFF020202),
                      fontFamily: 'bold',
                      fontSize: 19.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
