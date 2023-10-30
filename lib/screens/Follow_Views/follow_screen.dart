import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Model/followes_model.dart';


class FollowScreen extends StatefulWidget{
  List<Follows> follow ;
  FollowScreen(this.follow);
  _FollowScreen createState()=>_FollowScreen();
}

class _FollowScreen extends State<FollowScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صفحة المتابعين"),
        backgroundColor: Colors.orange,
      ),
      body: widget.follow.length>0?ListView.builder(
          itemCount: widget.follow.length,
          itemBuilder: (context,index){
            return ListTile(
              title: Text(widget.follow[index].name),
              subtitle: Text(widget.follow[index].email),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.follow[index].photo),
              ),
            );
          }
      ):Center(
        child: Text("لا يوجد اي مستخدمين تتابعهم"),
      ),
    );
  }

}