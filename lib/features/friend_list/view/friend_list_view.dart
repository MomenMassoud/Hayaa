import 'package:flutter/material.dart';
import '../widget/friend_list_body.dart';

class FriendListView  extends StatefulWidget{
  static const id = 'FriendListView';
  const FriendListView({super.key});
  _FriendListView createState()=>_FriendListView();
}

class _FriendListView extends State<FriendListView>{
  @override
  Widget build(BuildContext context) {
    return FriendListBody();
  }

}