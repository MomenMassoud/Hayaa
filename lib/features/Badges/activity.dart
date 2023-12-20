import 'package:flutter/material.dart';

import '../../core/Utils/app_images.dart';

class activity extends StatelessWidget{
  final Function(String) onImageTap;
  activity({required this.onImageTap});
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      _buildCard('queen', AppImages.activity1, context),
      _buildCard('king', AppImages.activity2, context),
      _buildCard('queen', AppImages.activity3, context),
      _buildCard('queen',AppImages.activity4, context),
      _buildCard('king',AppImages.activity5, context),
      _buildCard('queen', AppImages.activity6, context),
      _buildCard('queen', AppImages.activity1, context),
      _buildCard('king', AppImages.activity2, context),
      _buildCard('queen', AppImages.activity3, context),
      _buildCard('queen',AppImages.activity4, context),
      _buildCard('king',AppImages.activity5, context),
      _buildCard('queen', AppImages.activity6, context),
      _buildCard('queen', AppImages.activity1, context),
      _buildCard('king', AppImages.activity2, context),
      _buildCard('queen', AppImages.activity3, context),
      _buildCard('queen',AppImages.activity4, context),
      _buildCard('king',AppImages.activity5, context),
      _buildCard('queen', AppImages.activity6, context),
    ];
    return  Scaffold(
      // backgroundColor: Color(0xFF946B50),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/core/Utils/assets/images/brown1.jpeg'), // Replace with your background image asset path
              fit: BoxFit.cover, // Set the fit property (other options: BoxFit.contain, BoxFit.fill, etc.)
            ),
          ),
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

  Widget _buildCard(String name,  String imgPath, context) {
    return InkWell(
        onTap: () {
          onImageTap(imgPath);
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage('lib/core/Utils/assets/images/badges/1.jpeg'), // Replace with your background image asset path
                fit: BoxFit.cover, // Set the fit property (other options: BoxFit.contain, BoxFit.fill, etc.)
              ),
            ),

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
