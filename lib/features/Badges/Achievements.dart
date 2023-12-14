import 'package:flutter/material.dart';

import '../../core/Utils/app_images.dart';

class Achievements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      _buildCard('queen', AppImages.db11, context),
      _buildCard('king', AppImages.db22, context),
      _buildCard('queen', AppImages.db33, context),
      _buildCard('queen', AppImages.db11, context),
      _buildCard('king', AppImages.db22, context),
      _buildCard('queen', AppImages.db33, context),
      _buildCard('queen', AppImages.db11, context),
      _buildCard('king', AppImages.db22, context),
      _buildCard('queen', AppImages.db33, context),
      _buildCard('queen', AppImages.db11, context),
      _buildCard('king', AppImages.db22, context),
      _buildCard('queen', AppImages.db33, context),
      _buildCard('queen', AppImages.db11, context),
      _buildCard('king', AppImages.db22, context),
      _buildCard('queen', AppImages.db33, context),
      _buildCard('queen', AppImages.db11, context),
      _buildCard('king', AppImages.db22, context),
      _buildCard('queen', AppImages.db33, context),
    ];
    return Scaffold(
      backgroundColor: Color(0xFF946B50),
      body: Container(
          padding: EdgeInsets.all(8.0),
          child: GridView.count(
              crossAxisCount: 3,
              primary: false,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.8,
              children: list)),
    );
  }

  Widget _buildCard(String name, String imgPath, context) {
    return InkWell(
        onTap: () {},
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.brown,
                      spreadRadius: 3.0,
                      blurRadius: 6.0)
                ],
                color: Color(0xFF8F7264)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imgPath),
              Text(name,
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'bold',
                      fontSize: 15.0)),
            ])));
  }
}
