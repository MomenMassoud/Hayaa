import 'package:flutter/material.dart';

import '../widget/followers_body.dart';

class FollowersView  extends StatefulWidget{
  _FollowersView createState()=>_FollowersView();
}

class _FollowersView extends State<FollowersView>{
  @override
  Widget build(BuildContext context) {
    return FollowersBody();
  }

}