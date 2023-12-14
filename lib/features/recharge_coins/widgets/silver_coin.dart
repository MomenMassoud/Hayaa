import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import 'build_card.dart';


class SilverCoin extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView(
        children:<Widget> [
          Padding(padding: EdgeInsets.only(top: 20)),
          BuildCard('10', '100', AppImages.silver_coin,'Car', false, true),
          SizedBox(height: 20,),
          BuildCard('100', '1000', AppImages.silver_coin,'Car', true, true, ),
          SizedBox(height: 20,),
          BuildCard('1000', '10000', AppImages.silver_coin,'Car', false, true, ),
          SizedBox(height: 20,),
          BuildCard('5000', '50000', AppImages.silver_coin,'Car', false, true, ),
          SizedBox(height: 20,),
          BuildCard('10000', '100000', AppImages.silver_coin,'Car', false, true, ),
          SizedBox(height: 20,),
          BuildCard('50000', '500000', AppImages.silver_coin,'Car', false, true, ),
        ],
      ),
    );
  }

}