import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

import '../../../../core/Utils/app_images.dart';


class OtherCard extends StatelessWidget{
  String Name;
  String index;
  String bio;
  String Number;
  String img;
  OtherCard(this.Name,this.index,this.bio,this.Number,this.img);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(Name,style: TextStyle(fontSize: 20,color: Colors.white)),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(index,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            HexagonWidget.pointy(
              width: 100,
              color: Colors.yellow,
              elevation: 8,
              child: CachedNetworkImage(imageUrl: img),
              inBounds: true,
            ),
          ],
        ),
        subtitle: Text(bio,style: TextStyle(color: Colors.white)),
        trailing: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            Number,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.yellow),
          ),
        ),
      ),
    );
  }

}