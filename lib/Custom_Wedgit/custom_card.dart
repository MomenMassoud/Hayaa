import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';

import '../screens/Chat/chat_screen.dart';


class CustomCard extends StatefulWidget{
  chatmodel source,target;
  CustomCard(this.source,this.target);
  _CustomCard createState()=>_CustomCard();
}

class _CustomCard extends State<CustomCard>{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.target.name),
      leading:widget.target.photo!=""? CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(widget.target.photo),
      ):CircleAvatar(
        radius: 19,
        backgroundImage: AssetImage("assets/user.jpeg"),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChatScreen(widget.source,widget.target)));
      },
      subtitle: Text("اضغط لبداء المحادثة"),
      
    );
  }

}