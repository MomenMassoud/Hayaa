import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/widget/room_view_body.dart';

class RoomView extends StatefulWidget{
  String roomID;bool isHost;String userName;String UserID;
  RoomView(this.roomID,this.isHost,this.UserID,this.userName);
  _RoomView createState()=>_RoomView();
}

class _RoomView extends State<RoomView>{
  @override
  Widget build(BuildContext context) {
    return RoomViewBody(roomID: widget.roomID,isHost: widget.isHost,username: widget.userName,userid: widget.UserID,);
  }
  
}