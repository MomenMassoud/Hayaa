import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../widget/friend_list_body.dart';

class FriendListView  extends StatefulWidget{
  static const id = 'FriendListView';
  const FriendListView({super.key});
  _FriendListView createState()=>_FriendListView();
}

class _FriendListView extends State<FriendListView>{
  UserModel userModel=UserModel("email", "name", "gende", "photo", "id", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
  @override
  Widget build(BuildContext context) {
    return FriendListBody(userModel);
  }

}