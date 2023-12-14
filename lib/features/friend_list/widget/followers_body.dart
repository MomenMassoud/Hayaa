import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import '../../chat/widget/common/contact_card.dart';


class FollowersBody  extends StatefulWidget{
  _FollowersBody createState()=>_FollowersBody();
}

class _FollowersBody extends State<FollowersBody>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
          ContactCard("Momen", AppImages.momen, "male"),
        ],
      ),
    );
  }

}