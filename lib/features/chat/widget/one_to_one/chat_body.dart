import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/Utils/app_images.dart';
import '../common/own_massege.dart';
import '../common/system_msg.dart';
import 'chat_setting.dart';



class ChatBody extends StatefulWidget{
  _ChatBody createState()=>_ChatBody();
}

class _ChatBody extends State<ChatBody>{
  bool IsRecording=false;
  bool type = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Momen",style: TextStyle(fontSize: 16,color: Colors.black),),
        bottomOpacity: 2,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, ChatSetting.id);
          }, icon: Icon(Icons.person_outline,color: Colors.black,))
        ],
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 160,
              child: ListView(
                children: [
                  SystemMSG("للحفاظ علي الثقافة"),
                  OwnMassege("hi", AppImages.momen),
                  OwnMassege("hi", AppImages.momen),
                  OwnMassege("hi", AppImages.momen),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 55,
                    child: Card(
                      margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        //controller: _controller,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (value){
                          // setState(() {
                          //   if (value == null) {
                          //     type = false;
                          //   } else if (value == "") {
                          //     type = false;
                          //   } else {
                          //     type = true;
                          //   }
                          //   msg = value;
                          // });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "اكتب الرسالة هنا".tr(args: ['اكتب الرسالة هنا']),

                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // showModalBottomSheet(
                                    //     backgroundColor:
                                    //     Colors.transparent,
                                    //     context: context,
                                    //     builder: (builder) =>
                                    //         bottomSheet());
                                  },
                                  icon: Icon(Icons.photo)),
                            ],
                          ),
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                  type
                      ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, right: 3, left: 2),
                    child: CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () {
                          // checkCoins();
                          // setState(() {
                          //   type = false;
                          //   _controller.clear();
                          // });
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, right: 3, left: 2),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: IconButton(
                        onPressed: () async {
                          // await recordMethod.toggleRecording();
                          // recordMethod.ChatRoomID = chatroomID;
                          // setState(() {
                          //   IsRecording = recordMethod.isRecording;
                          // });
                        },
                        icon: IsRecording
                            ? Icon(
                          Icons.stop_circle,
                          color: Colors.red,
                        )
                            : Icon(Icons.mic_none),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Offstage(
                //   offstage: !emojiShowing,
                //   child: SizedBox(
                //     height: 250,
                //     child: EmojiPicker(
                //       textEditingController: _controller,
                //       config: Config(
                //         columns: 7,
                //         emojiSizeMax: 32 *
                //             (defaultTargetPlatform ==
                //                 TargetPlatform.iOS
                //                 ? 1.30
                //                 : 1.0),
                //         verticalSpacing: 0,
                //         horizontalSpacing: 0,
                //         gridPadding: EdgeInsets.zero,
                //         bgColor: const Color(0xFFF2F2F2),
                //         indicatorColor: Colors.blue,
                //         iconColor: Colors.grey,
                //         iconColorSelected: Colors.blue,
                //         backspaceColor: Colors.blue,
                //         skinToneDialogBgColor: Colors.white,
                //         skinToneIndicatorColor: Colors.grey,
                //         enableSkinTones: true,
                //         recentsLimit: 28,
                //         replaceEmojiOnLimitExceed: false,
                //         noRecents: const Text(
                //           'No Recents',
                //           style:
                //           TextStyle(fontSize: 20, color: Colors.black26),
                //           textAlign: TextAlign.center,
                //         ),
                //         loadingIndicator: const SizedBox.shrink(),
                //         tabIndicatorAnimDuration: kTabScrollDuration,
                //         categoryIcons: const CategoryIcons(),
                //         buttonMode: ButtonMode.MATERIAL,
                //         checkPlatformCompatibility: true,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

}