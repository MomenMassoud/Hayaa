import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../chat/widget/common/contact_card.dart';

class LikerBody extends StatefulWidget{
  _LikerBody createState()=>_LikerBody();
}

class _LikerBody extends State<LikerBody>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
        ],
      ),
    );
  }

}