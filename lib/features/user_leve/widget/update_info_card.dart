import 'package:flutter/material.dart';


class UpdateInfoCard extends StatelessWidget{
  String title;
  String subtitle;
  Icon icons;
  UpdateInfoCard(this.title,this.subtitle,this.icons);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: CircleAvatar(
        child: icons,
      ),
    );
  }

}