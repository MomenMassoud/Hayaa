import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../chat/widget/common/contact_card.dart';

class FriendsBody  extends StatefulWidget{
  _FriendsBody createState()=>_FriendsBody();
}

class _FriendsBody extends State<FriendsBody>{
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
        ],
      ),
    );
  }

}