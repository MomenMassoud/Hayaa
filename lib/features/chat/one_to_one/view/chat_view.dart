import 'package:flutter/material.dart';
import 'package:hayaa_main/models/firends_model.dart';

import '../../widget/one_to_one/chat_body.dart';



class ChatView extends StatefulWidget{
  static const id = 'ChatView';
  const ChatView({super.key});
  _ChatView createState()=>_ChatView();
}

class _ChatView extends State<ChatView>{
  @override
  Widget build(BuildContext context) {
    return ChatBody(FriendsModel("email", "id", "docID", "photo", "name", "phonenumber", "gender"));
  }

}