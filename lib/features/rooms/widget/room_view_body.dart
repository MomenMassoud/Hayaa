import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'constant.dart';
class RoomViewBody extends StatefulWidget{
  final String roomID;
  final bool isHost;
  final String username;
  final String userid;
  final layoutMode = LayoutMode.defaultLayout;
   RoomViewBody({Key? key, required this.roomID,required this.isHost,required this.username,required this.userid}) : super(key: key);
  _RoomViewBody createState()=>_RoomViewBody();
}

class _RoomViewBody extends State<RoomViewBody>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: 265494176, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: "2b1240dd8d882f29730af2121a749432cdae133cabda3388af8efc71b275c99e", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: widget.username,
        userName: widget.userid,
        roomID: "111222333",
        config:( widget.isHost
            ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
          ..background = background()
          ..seatConfig.avatarBuilder = (BuildContext context, Size size,
              ZegoUIKitUser? user, Map extraInfo) {
            return CircleAvatar(
              maxRadius: size.width,
              backgroundImage: CachedNetworkImageProvider(_auth.currentUser!.photoURL.toString()),
            );
          }
          ..topMenuBarConfig=ZegoTopMenuBarConfig(
            buttons: []
          )
          ..bottomMenuBarConfig=ZegoBottomMenuBarConfig(
            showInRoomMessageButton: true,
            audienceExtendButtons: [
              IconButton(onPressed: (){}, icon: Icon(Icons.card_giftcard_sharp))
            ],
            hostExtendButtons: [
              CircleAvatar(
                child: IconButton(onPressed: (){}, icon: Icon(Icons.card_giftcard_sharp)),
                backgroundColor: Colors.white,
              )
            ],
          )
        ..audioEffectConfig=ZegoAudioEffectConfig(
          reverbEffect: [
            ReverbType.concert,
            ReverbType.basement,
            ReverbType.gramophone,
            ReverbType.hall,
          ],
          voiceChangeEffect: [
            VoiceChangerType.aMajor,
            VoiceChangerType.cMajor,
            VoiceChangerType.deep,
          ],

        )
        ..durationConfig=ZegoLiveDurationConfig(
          isVisible: true,
        )
        ..memberListConfig=ZegoMemberListConfig(
          onClicked: (user) {
            print(user.name);
          },
        )
    ));
  }
  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('lib/core/Utils/assets/images/vip4.jpeg').image,
            ),
          ),
        ),
        const Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Live Audio Room',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            'ID: ${widget.roomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );

  }
}
