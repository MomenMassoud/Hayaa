import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';
import 'build_card.dart';

class GoldCoin extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(
      //  children:<Widget> [
      //    Padding(padding: EdgeInsets.only(top: 20)),
      //    BuildCard('EGP 35.99', '700', AppImages.gold_coin,'Car', false, false),
      //    SizedBox(height: 20,),
      //    BuildCard('EGP 179.99', '3500', AppImages.gold_coin,'Car', true, false, ),
      //    SizedBox(height: 20,),
      //    BuildCard('EGP 359.99', '7050', AppImages.gold_coin,'Car', false, false, ),
      //    SizedBox(height: 20,),
      //    BuildCard('EGP 1799.99', '35300', AppImages.gold_coin,'Car', false, false, ),
      //    SizedBox(height: 20,),
      //    BuildCard('EGP 3599.99', '70800', AppImages.gold_coin,'Car', false, false, ),
      //    SizedBox(height: 20,),
      //    BuildCard('EGP 4399.99', '90760', AppImages.gold_coin,'Car', false, false, ),
      //  ],
      // ),
       body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 19.0,
          childAspectRatio: 0.8,
         children: <Widget>[
           BuildCard('EGP 35.99', '700', AppImages.gold_coin,'Car', false, false),
           BuildCard('EGP 179.99', '3500', AppImages.gold_coin,'Car', true, false, ),
           BuildCard('EGP 359.99', '7050', AppImages.gold_coin,'Car', false, false, ),
           BuildCard('EGP 1799.99', '35300', AppImages.gold_coin,'Car', false, false, ),
           BuildCard('EGP 3599.99', '70800', AppImages.gold_coin,'Car', false, false, ),
           BuildCard('EGP 4399.99', '90760', AppImages.gold_coin,'Car', false, false, ),
         ],
        )
    );
  }
}
