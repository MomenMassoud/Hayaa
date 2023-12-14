import 'package:flutter/material.dart';
import '../widget/friends_body.dart';

class FriendsView  extends StatefulWidget{
  _FriendsView createState()=>_FriendsView();
}

class _FriendsView extends State<FriendsView>{
  @override
  Widget build(BuildContext context) {
    return FriendsBody();
  }

}