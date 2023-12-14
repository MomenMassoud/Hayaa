import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget{
  String title;
  String subtitle;
  String value;
  String icon;
  bool month;
  HistoryCard(this.title,this.subtitle,this.value,this.icon,this.month);
  @override
  Widget build(BuildContext context) {
    return month?Container(
      color: Colors.blueGrey[200],
      child: ListTile(
        title: Text(title,style: TextStyle(color: Colors.white),),
      ),
    ):ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,style: TextStyle(color: Colors.blue),),
          CircleAvatar(backgroundImage: AssetImage(icon),)
        ],
      ),
    );
  }

}