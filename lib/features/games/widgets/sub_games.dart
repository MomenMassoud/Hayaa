import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../home/widgets/gradient_rounded_container.dart';

class SubGames extends StatelessWidget{
  String image;
  String cost;
  String name;
  SubGames(this.image,this.cost,this.name);
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientRoundedContainer(
              screenHeight: screenHight * 0.08,
              screenWidth: screenWidth * 0.3,
              colorOne: Colors.indigo,
              colorTwo: Colors.green),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: screenWidth * 0.1,
                          child:Image(image: AssetImage(image))),
                    ],
                  ),
                  Text(name),
                  Row(
                    children: [
                      CircleAvatar(backgroundImage: AssetImage(AppImages.silver_coin),radius: 6,),
                      Text(cost)
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

}