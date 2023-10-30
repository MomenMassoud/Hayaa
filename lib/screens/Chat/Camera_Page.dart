import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';

import 'Camera_Screen.dart';

class CameraPage extends StatefulWidget{
  chatmodel user;
  CameraPage(this.user);
  @override
  _CameraPage createState()=>_CameraPage();

}

class _CameraPage extends State<CameraPage>{
  @override
  Widget build(BuildContext context) {
    return CameraScreen(widget.user);
  }

}