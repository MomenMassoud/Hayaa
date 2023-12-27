import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/gift_model.dart';
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

class _RoomViewBody extends State<RoomViewBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('user').where(
          'doc', isEqualTo: _auth.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        String Mycar = "";
        String Myframe = "";
        String Mywallpaper = "";
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed) {
          Mycar = massege.get('mycar');
          Myframe = massege.get('myframe');
        }
        return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('store').where('id',isEqualTo: Myframe).snapshots(),
            builder: (context,snapshot){
              String framePhoto="";
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                framePhoto=massege.get('photo');
              }
              return  SafeArea(
                  child: ZegoUIKitPrebuiltLiveAudioRoom(
                      appID: 265494176,
                      // Fill in the appID that you get from ZEGOCLOUD Admin Console.
                      appSign: "2b1240dd8d882f29730af2121a749432cdae133cabda3388af8efc71b275c99e",
                      // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
                      userID: widget.username,
                      userName: widget.userid,
                      roomID: "111222333",
                      config: (widget.isHost
                          ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                          : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
                        ..background = background()
                        ..seatConfig.avatarBuilder = (BuildContext context, Size size,
                            ZegoUIKitUser? user, Map extraInfo) {
                          return Stack(
                            children: [
                              Container(
                                width: size.width*2,
                                child: CircleAvatar(
                                  maxRadius: size.width+100,
                                  backgroundImage: CachedNetworkImageProvider(framePhoto),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              // Display the second image on the right
                              Center(
                                child: Container(
                                  width: size.width-20-3.5,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(_auth.currentUser!.photoURL.toString() ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        ..hostSeatIndexes = [0]
                      ..inRoomMessageConfig=ZegoInRoomMessageConfig(
                        height: 166,
                        showAvatar: false,
                      )
                        ..layoutConfig.rowConfigs = [
                          ZegoLiveAudioRoomLayoutRowConfig(count: 1, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                        ]
                  ));
            }
        );
      },
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
              image: Image
                  .asset('lib/core/Utils/assets/images/vip4.jpeg')
                  .image,
            ),
          ),
        ),
         Positioned(
            top: 10,
            left: 10,
            child: Text(
              widget.isHost?_auth.currentUser!.displayName.toString():'Live Audio Room',
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
            widget.isHost?'ID : ${_auth.currentUser!.uid}':'ID: ${widget.roomID}',
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
  Widget bottomSheet() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin:  EdgeInsets.all(18),
        child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('gifts').snapshots(),
              builder: (context,snapshot){
                List<GiftModel> gifts=[];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  gifts.add(
                      GiftModel(massege.id, massege.get('name'), massege.get('photo'), massege.get('price'),massege.get('type'))
                  );
                }
                return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: gifts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          showModalBottomSheet(
                              backgroundColor:
                              Colors.black,
                              context: context,
                              builder: (builder) =>
                                  bottomSheet2());
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                gifts[index].type=="svga"?CircleAvatar(
                                  radius: 30,
                                  child: SVGASimpleImage(
                                    resUrl: gifts[index].photo,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ):CircleAvatar(
                                  radius: 30,
                                  child: CachedNetworkImage(imageUrl: gifts[index].photo),
                                  backgroundColor: Colors.transparent,
                                ),
                                Text(gifts[index].Name),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(AppImages.gold_coin),
                                      radius: 5,
                                    ),
                                    Text(gifts[index].price,style: TextStyle(color: Colors.orangeAccent),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                );
              },
            )
        ),
      ),
    );
  }
  Widget bottomSheet2() {
    return SizedBox(
      height: 478,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin:  EdgeInsets.all(18),
        child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('room').doc(widget.roomID).collection('user').where('id',isNotEqualTo: _auth.currentUser!.uid).snapshots(),
              builder: (context,snapshot){
                List<String> usersDocs=[];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed){
                  usersDocs.add(massege.id);
                }
                return Container(
                  height: 400,
                  child: ListView.builder(
                    itemCount: usersDocs.length,
                    itemBuilder: (context,index){
                      return StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('user').where('doc',isEqualTo: usersDocs[index]).snapshots(),
                        builder: (context,snapshot){
                          String userName="";
                          String UserPhoto="";
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                          final masseges = snapshot.data?.docs;
                          for (var massege in masseges!.reversed){
                            userName=massege.get('name');
                            UserPhoto=massege.get('photo');
                          }
                          return ListTile(
                            title: Text(userName,style: TextStyle(color: Colors.white),),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(UserPhoto),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            )
        ),
      ),
    );
  }
}
