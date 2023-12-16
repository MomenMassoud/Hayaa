import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';

class BuildCard extends StatelessWidget{
  String name;
  String price;
  String imgPath;
  String category;
  bool added;
  bool isFavorite;
  BuildCard(this.name,this.price,this.imgPath,this.category,this.added,this.isFavorite);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0)
                ],
                color: Colors.white),
            child:isFavorite==false? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Image.asset(AppImages.gold_coin,width: 70,),
                ),
                Text(price,style: TextStyle(fontSize: 16,color: Colors.orange),),
                Text(name,style: TextStyle(fontSize: 16,color: Colors.grey))
              ],
            ):ListTile(
              title:Text(price),
              leading: CircleAvatar(
                backgroundImage: AssetImage(imgPath),
              ),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(backgroundImage: AssetImage(AppImages.gold_coin),radius: 5,),
                  Text(name)
                ],
              ),
            ),
          ),
        ),
    );
  }

}