import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
//..userAvatarUrl="https://robohash.org/${widget.userID}.png"
import 'constant.dart';

class VideoConferencePage extends StatefulWidget {
  String userID;
  String UserName;
  String RoomID;
  String photo;
  bool host;
  final layoutMode = LayoutMode.defaultLayout;
  VideoConferencePage(
      this.userID, this.UserName, this.RoomID, this.host, this.photo);
  _VideoConferencePage createState() => _VideoConferencePage();
}

class _VideoConferencePage extends State<VideoConferencePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: 1635797258,
        appSign:
            "53721598b3f0dcc86024111505aa13f3f913d5b6c0e6504728077220e6851a15",
        userID: widget.userID,
        userName: widget.UserName,
        roomID: widget.RoomID,

        // Modify your custom configurations here.
        config:( widget.host
            ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
          ..seatConfig.avatarBuilder = (BuildContext context, Size size,
              ZegoUIKitUser? user, Map extraInfo) {
            return CircleAvatar(
              maxRadius: size.width,
              backgroundImage: CachedNetworkImageProvider(widget.photo),
            );
          }
          ..background = background()
          ..onLeaveConfirmation = (BuildContext context) async {
            return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                  title: const Text("This is your custom dialog",
                      style: TextStyle(color: Colors.white70)),
                  content: const Text(
                      "You can customize this dialog as you like",
                      style: TextStyle(color: Colors.white70)),
                  actions: [
                    ElevatedButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.white70)),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    ElevatedButton(
                      child: const Text("Exit"),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                );
              }
            );
          },
      ),
    );
  }
  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('assets/download.jpg').image,
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
                color: Color(0xff1B1B1B),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            'ID: ${widget.RoomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff606060),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );

  }

}
