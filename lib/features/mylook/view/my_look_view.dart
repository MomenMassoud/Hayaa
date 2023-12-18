import 'package:flutter/material.dart';
import 'package:hayaa_main/features/mylook/widget/my_look_body.dart';


class MyLookView extends StatefulWidget{
  const MyLookView({super.key});
  static const id = 'MyLookView';
  _MylookView createState()=>_MylookView();
}

class _MylookView extends State<MyLookView>{
  @override
  Widget build(BuildContext context) {
    return MyLookBody();
  }

}