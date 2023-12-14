import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../chat/widget/common/contact_card.dart';


class VisitorBody extends StatefulWidget{
  _VisitorBody createState()=>_VisitorBody();
}

class _VisitorBody extends State<VisitorBody>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("الزوار").tr(args: ['الزوار']),
      ),
      body: ListView(
        children: [
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
        ],
      ),
    );
  }

}