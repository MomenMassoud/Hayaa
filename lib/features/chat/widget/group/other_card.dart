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
    return ListTile(
      title: Text(Name,style: TextStyle(fontSize: 20,color: Colors.white)),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(index,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
          HexagonWidget.pointy(
            width: 100,
            color: Colors.yellow,
            elevation: 8,
            child: Image.asset(img),
            inBounds: true,
          ),
        ],
      ),
      subtitle: Text(bio,style: TextStyle(color: Colors.white)),
      trailing: Card(
        shape: BeveledRectangleBorder( //<-- 2. SEE HERE
          side: BorderSide(
            color: Color.fromRGBO(255, 215, 0, 1),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(17.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            Number,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}