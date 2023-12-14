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
          child:isFavorite==false? ListTile(
            title:Text(price),
            subtitle:Text(name),
            leading: CircleAvatar(
              backgroundImage: AssetImage(imgPath),
            ),
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
    );
  }

}