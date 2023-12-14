import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/friend_list/widget/friend_requset.dart';
import 'package:hayaa_main/features/search/view/search_view.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';
import '../../chat/widget/common/contact_card.dart';
import '../../chat/widget/one_to_one/chat_body.dart';
import '../../friend_list/widget/friend_list_body.dart';

class MessagesViewBody extends StatefulWidget {
  _MessagesViewBody createState()=>_MessagesViewBody();
}

class _MessagesViewBody extends State<MessagesViewBody>{
  UserModel userModel=UserModel("email", "name", "gende", "photo", "id", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");

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
                    MaterialPageRoute(builder: (context) => FriendListBody(userModel)));
              }, icon: const Icon(Icons.people_outlined,color: Colors.black,)),
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, SearchView.id);
              },
              icon: Icon(Icons.search,color: Colors.black,))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("lib/core/Utils/assets/images/logo.png"),
            ),
            title: Text("فريق Hayaa"),
            subtitle: Text("اضغط لمعرفة اخر الاخبار"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt_1_sharp,color: Colors.blue,),
            title: Text("طلبات الصداقة"),
            subtitle: Text("اضغط لمعرفة من ارسل لك طلب صداقة"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: (){
              Navigator.pushNamed(context, FriendReuest.id);
            },
          ),
          Divider(thickness: 0.4,),
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
