import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/Utils/app_images.dart';
import '../common/contact_card.dart';


class ChatSetting extends StatefulWidget{
  static const id = 'ChatSetting';
  _ChatSetting createState()=>_ChatSetting();
}

class _ChatSetting extends State<ChatSetting>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 243, 255, 1),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("اعدادات الدردشة",style: TextStyle(fontSize: 16,color: Colors.black),).tr(args: ['اعدادات الدردشة']),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 13),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ContactCard("Momen",AppImages.momen,"male"),
                  Divider(thickness: 2),
                  ListTile(
                    title: Text("اضافة للقائمة السوداء").tr(args: ['اضافة للقائمة السوداء']),
                    trailing: IconButton(onPressed: (){},icon: Icon(Icons.arrow_forward_ios_rounded),),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}