import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget{
  String photo;
  String name;
  String sex;
  ContactCard(this.name,this.photo,this.sex);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundImage: AssetImage(photo),
      ),
    );
  }

}