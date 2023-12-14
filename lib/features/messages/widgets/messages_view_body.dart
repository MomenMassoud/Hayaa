import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
import '../../chat/widget/common/contact_card.dart';
import '../../chat/widget/one_to_one/chat_body.dart';
import '../../friend_list/widget/friend_list_body.dart';

class MessagesViewBody extends StatelessWidget {
  const MessagesViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: screenHight * 0.12,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appPrimaryColors400,
                AppColors.appInformationColors700
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title:GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: screenWidth * 0.12,
            child: Text(
              "الدردشة",
              style: TextStyle(fontFamily: "Hayah", fontSize: 22),
            ).tr(args: ['الدردشة']),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FriendListBody()));
              }, icon: const Icon(Icons.person_search,color: Colors.black,)),
        ],
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChatBody()));
            },
              child: ContactCard("Momen", AppImages.momen, "male")
          ),
          ContactCard("Momen", AppImages.momen, "male"),
        ],
      ),
    );
  }
}
