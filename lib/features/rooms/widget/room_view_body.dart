import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/gift_model.dart';
import 'constant.dart';
import 'package:zego_uikit/zego_uikit.dart';

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
  bool openchat=true;
  List<int> lockedSeats = []; // List to store locked seat indexes
  List<String> userSeats=[];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String framePhoto="";
  final isSeatClosedNotifier = ValueNotifier<bool>(false);
  final isRequestingNotifier = ValueNotifier<bool>(false);
  final controller = ZegoLiveAudioRoomController();
  List<String> musicPath=[];
  List<String> musicname=[];
  DateTime? seatOccupiedTime;
  bool viewMusic=false;
  String viewID="";
  String bio="";
  String layoutSeats="";
  String wallpaper="https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462";
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  String pass="";
  String giftMedia="";
  String carMedia="";
  String cartype="";
  String gifttype="";
  String myType="";
  @override
  void initState() {
    super.initState();
    setUserInRoom();
    getMyCar();
    getWallpaper();
    UserBlock();
  }
  void setUserInRoom()async{
    _firestore.collection('room').doc(widget.roomID).collection('user').doc(_auth.currentUser!.uid).set({
      'id':_auth.currentUser!.uid
    });
  }
  void getMyCar()async{
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).snapshots()){
      setState(() {
        myType=snap.get('type');
      });
      await for(var snapp in _firestore.collection('store').doc(snap.get('mycar')).snapshots()){
        setState(() {
          carMedia=snapp.get('photo');
           cartype=snapp.get('type');
          _firestore.collection('room').doc(widget.roomID).update({
            'car':carMedia,
            'cartype':cartype,
          });
          Future.delayed(const Duration(seconds: 4)).then((value){
            setState(() {
              carMedia="";
            });
            _firestore.collection('room').doc(widget.roomID).update({
              'car':'',
              'cartype':''
            }).then((value){
              controller.message.send('Join to Room');
            });
          });
        });
      }
    }
  }
  void getWallpaper()async{
    await for(var snap in _firestore.collection('room').doc(widget.roomID).snapshots()){
      setState(() {
        wallpaper=snap.get('wallpaper');
        viewID=snap.get('id');
        bio=snap.get('bio');
        layoutSeats=snap.get('seat');
        pass=snap.get('password');
        giftMedia=snap.get('gift');
        carMedia=snap.get('car');
      });
    }
  }
  void UserBlock()async{
    if(!widget.isHost){
      await for(var snap in _firestore.collection('room').doc(widget.roomID).collection('block').where('id',isEqualTo: _auth.currentUser!.uid).snapshots()){
        if(snap.size!=0){
          controller.leave(context,showConfirmation: false);
        }
      }
    }
  }
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
                      roomID: viewID,
                      config: widget.isHost
                          ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                          : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
                      ..onLeaveConfirmation=(context)async {
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                                title: const Text("Leave Confirm",
                                    style: TextStyle(color: Colors.white70)),
                                content: const Text(
                                    "Are you sure Leave from room",
                                    style: TextStyle(color: Colors.white70)),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Cancel",),
                                    onPressed: () => Navigator.of(context).pop(false),
                                  ),
                                  ElevatedButton(
                                    child: const Text("Exit"),
                                    onPressed: () async{
                                      _firestore.collection('room').doc(widget.roomID).collection('user').doc(_auth.currentUser!.uid).delete().then((value){
                                        Navigator.of(context).pop(true);
                                      });
                                      },
                                  ),
                                ],
                              );
                            }
                        );
                      }
                        ..background = background()
                        ..takeSeatIndexWhenJoining =
                        widget.isHost ? getHostSeatIndex() : -1
                        ..hostSeatIndexes = [0]
                        ..useSpeakerWhenJoining=true
                        ..onMemberListMoreButtonPressed=onMemberListMoreButtonPressed
                        ..seatConfig=ZegoLiveAudioRoomSeatConfig(
                          backgroundBuilder: (context, size, user, extraInfo) {
                            return Container(color: Colors.transparent,);
                          },
                          closeIcon: Image.network("https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Flock_5794524.png?alt=media&token=a613f54d-477a-42c9-98a6-fa65dac2a49e"),
                          openIcon: Image.network("https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fsofa_6458474.png?alt=media&token=dff6124f-805c-4386-bd95-394c4fa611f7")
                        )
                        ..seatConfig.avatarBuilder=(context, size, user, extraInfo) {
                          if(user!.id==_auth.currentUser!.uid){
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
                          else{
                            return StreamBuilder<QuerySnapshot>(
                              stream: _firestore.collection('user').where('doc',isEqualTo: user!.id).snapshots(),
                              builder: (context,snapshot){
                                String userPhoto="";
                                String userFrame="";
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                }
                                final masseges = snapshot.data?.docs;
                                for (var massege in masseges!.reversed){
                                  userPhoto=massege.get('photo');
                                  userFrame=massege.get('myframe');
                                }
                                return StreamBuilder<QuerySnapshot>(
                                    stream:_firestore.collection('store').where('id',isEqualTo: userFrame).snapshots(),
                                    builder: (context,snapshot){
                                      String userFramePhoto="";
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      }
                                      final masseges = snapshot.data?.docs;
                                      for (var massege in masseges!.reversed){
                                        userFramePhoto=massege.get('photo');
                                      }
                                      return Stack(
                                        children: [
                                          Container(
                                            width: size.width*2,
                                            child: CircleAvatar(
                                              maxRadius: size.width+100,
                                              backgroundImage: CachedNetworkImageProvider(userFramePhoto),
                                              backgroundColor: Colors.transparent,
                                            ),
                                          ),
                                          // Display the second image on the right
                                          Center(
                                            child: Container(
                                              width: size.width-20-3.5,
                                              child: CircleAvatar(
                                                backgroundImage: CachedNetworkImageProvider(userPhoto),
                                                backgroundColor: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                }
                                );
                              },
                            );
                          }
                        }
                      ..inRoomMessageConfig=ZegoInRoomMessageConfig(
                        height: 166,
                        showAvatar: false,
                      )
                        ..layoutConfig.rowConfigs =layoutSeats=='9'? [
                          ZegoLiveAudioRoomLayoutRowConfig(count: 1, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                        ]: layoutSeats=='11'?[
                          ZegoLiveAudioRoomLayoutRowConfig(count: 1, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 2, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                        ]:[
                          ZegoLiveAudioRoomLayoutRowConfig(count: 1, alignment: ZegoLiveAudioRoomLayoutAlignment.center),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                          ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                        ]
                        ..bottomMenuBarConfig.audienceButtons = const [
                          ZegoMenuBarButtonName.showMemberListButton,
                          ZegoMenuBarButtonName.applyToTakeSeatButton
                        ]
                      ..onSeatClicked=(index, user) {
                        print("Value ${isSeatOpen(index)}");
                        if(widget.isHost){
                          if(isSeatOpen(index) && user==null){
                            openSeat(index);
                          }
                          else{
                           if(user==null){
                             closeSeat(index);
                           }
                           else{
                             controller.message.send('Remove ${user.name} from Seat');
                             controller.removeSpeakerFromSeat(user!.id);
                           }
                          }
                        }
                      }
                        ..onSeatsChanged = (
                            Map<int, ZegoUIKitUser> takenSeats,
                            List<int> untakenSeats,
                            ) {
                          if (isRequestingNotifier.value) {
                            if (takenSeats.values
                                .map((e) => e.id)
                                .toList()
                                .contains(widget.userid)) {
                              /// on the seat now
                              isRequestingNotifier.value = false;
                            }
                          }
                        }
                        ..onSeatTakingRequestFailed = () {
                          isRequestingNotifier.value = false;
                        }
                        ..onSeatTakingRequestRejected = () {
                          isRequestingNotifier.value = false;
                        }
                        ..onSeatTakingRequested = (ZegoUIKitUser audience) {
                          debugPrint('on seat taking requested, audience:$audience');
                        }
                        ..onInviteAudienceToTakeSeatFailed = () {
                          debugPrint('on invite audience to take seat failed');
                        }
                        ..onSeatsChanged = (
                            Map<int, ZegoUIKitUser> takenSeats,
                            List<int> untakenSeats,
                            ) {
                          debugPrint(
                            'on seats changed, taken seats: $takenSeats, untaken seats: $untakenSeats',
                          );
                          setState(() {
                            userSeats.clear();
                          });
                          takenSeats.forEach((seatIndex, user) {
                            setState(() {
                              userSeats.add(user.id);
                            });
                            debugPrint('Seat $seatIndex is taken by user: $user');
                            if (user.id==_auth.currentUser!.uid && myType=="host") {
                              print("Start Time ===================");
                              seatOccupiedTime = DateTime.now();
                            }

                            // Do whatever you need with the updated list of users in seats
                            debugPrint('Users currently in seats: $userSeats');
                          });
                          if (userSeats.contains(_auth.currentUser!.uid)==false) {
                            print("user lefttttttttttttttttttttt");
                            if (seatOccupiedTime != null) {
                              DateTime now = DateTime.now();
                              Duration timeSpent = now.difference(seatOccupiedTime!);
                              print('User spent ${timeSpent.inMinutes} minutes in the seat.');
                              // Reset the seatOccupiedTime
                              seatOccupiedTime = null;
                              String myagent="";
                              _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((value){
                                myagent=value.get('myagent');
                              }).then((value){
                                int lastincome=0;
                                String docs="${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
                                _firestore.collection('agency').doc(myagent).collection('users').doc(_auth.currentUser!.uid).collection('income').doc(docs).get().then((value){
                                  lastincome=int.parse(value.get('hosttime'))+timeSpent.inMinutes;
                                }).whenComplete((){
                                  if(lastincome==0){
                                    _firestore.collection('agency').doc(myagent).collection('users').doc(_auth.currentUser!.uid).collection('income').doc(docs).set({
                                      'date':DateTime.now().toString(),
                                      'hosttime': timeSpent.inMinutes.toString(),
                                      'numberradio':timeSpent.inMinutes>=60?'1':'0',
                                    });
                                  }
                                  else{
                                    _firestore.collection('agency').doc(myagent).collection('users').doc(_auth.currentUser!.uid).collection('income').doc(docs).update({
                                      'hosttime':lastincome.toString(),
                                      'numberradio':lastincome>=60?'1':'0',
                                    });
                                  }
                                });
                              });
                            }
                          }
                        }
                        ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                          maxCount: 6,
                          audienceExtendButtons: [
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(onPressed: (){
                                  showModalBottomSheet(
                                      backgroundColor:
                                      Colors.transparent,
                                      context: context,
                                      builder: (builder) =>
                                          bottomSheet());
                                }, icon: Icon(Icons.card_giftcard,color: Colors.black,))),
                          ],
                          speakerExtendButtons: [
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(onPressed: (){
                                  showModalBottomSheet(
                                      backgroundColor:
                                      Colors.transparent,
                                      context: context,
                                      builder: (builder) =>
                                          bottomSheet());
                                }, icon: Icon(Icons.card_giftcard,color: Colors.black,))),
                          ],
                          hostExtendButtons: [

                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(onPressed: (){
                                  showModalBottomSheet(
                                      backgroundColor:
                                      Colors.transparent,
                                      context: context,
                                      builder: (builder) =>
                                          bottomSheet());
                                }, icon: Icon(Icons.card_giftcard,color: Colors.black,))),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child:pass==""? IconButton(onPressed: (){
                                      Navigator.pop(context);
                                      SetPassword();
                                    }, icon: Icon(Icons.password,color: Colors.black,)):IconButton(onPressed: ()async{
                                      _firestore.collection('room').doc(widget.roomID).update({
                                        'password':''
                                      }).then((value){
                                        controller.message.send('Remove Password from Room');
                                        setState(() {
                                          pass="";
                                        });
                                        Navigator.pop(context);
                                      });
                                    }, icon: Icon(Icons.remove_circle_outline))
                                ),
                                pass==""?Text("Set Password To Room",style: TextStyle(color: Colors.white,fontSize: 8),):Text("Remove Password To Room",style: TextStyle(color: Colors.white,fontSize: 8),)
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(onPressed: (){
                                      controller?.media.pickPureAudioFile().then((value){
                                        Navigator.pop(context);
                                        musicPath.add(value[0].path.toString());
                                        musicname.add(value[0].name);
                                        showModalBottomSheet(
                                            backgroundColor:
                                            Colors.transparent,
                                            context: context,
                                            builder: (builder) =>
                                                MyMusic());
                                      });


                                    }, icon: Icon(Icons.music_note,color: Colors.black,))),
                                Text("Play Music",style: TextStyle(color: Colors.white,fontSize: 8),)
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(onPressed: (){
                                      Navigator.pop(context);
                                      showModalBottomSheet(
                                          backgroundColor:
                                          Colors.transparent,
                                          context: context,
                                          builder: (builder) =>
                                              MyWallpaper());
                                    }, icon: Icon(Icons.photo,color: Colors.black,))),
                                Text("Change Room Wallpaper",style: TextStyle(color: Colors.white,fontSize: 8),)
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(onPressed: (){
                                      ShowNumberSeat();
                                    }, icon: Icon(Icons.layers,color: Colors.black,))),
                                Text("Change Seat Number in Room",style: TextStyle(color: Colors.white,fontSize: 8),)
                              ],
                            ),
                            controller.media.getCurrentProgress()!=0? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(onPressed: ()async{
                                    print("done");
                                    await controller.media.stop().whenComplete((){
                                      print("done");
                                    });
                                    await controller.media.pause();
                                  }, icon: Icon(Icons.music_off_sharp)),
                                ),
                                Text("Stop Media",style: TextStyle(color: Colors.white,fontSize: 8),)
                              ],
                            ):Container(),
                          ],
                          speakerButtons: [
                            ZegoMenuBarButtonName.toggleMicrophoneButton,
                            ZegoMenuBarButtonName.showMemberListButton,
                          ],
                        ),
                      controller: controller,

                  ));
            }
        );
      },
    );
  }
  // Function to check if a seat is open
  bool isSeatOpen(int seatIndex) {
    return lockedSeats.contains(seatIndex);
  }

  // Function to open a seat
  void openSeat(int seatIndex) {
    if (widget.isHost && isSeatOpen(seatIndex)) {
      // Implement logic to open the seat
      setState(() {
        lockedSeats.remove(seatIndex);
        print("Opennnnnnnnnnn");
      });
      controller.openSeats(targetIndex: seatIndex); // You may need to implement this method in your ZegoLiveAudioRoomController
      debugPrint('Host opened seat $seatIndex');
    }
  }

  // Function to close a seat
  void closeSeat(int seatIndex) {
    if (widget.isHost && !isSeatOpen(seatIndex)) {
      // Implement logic to close the seat
      setState(() {
        lockedSeats.add(seatIndex);
      });
      controller.closeSeats(targetIndex: seatIndex); // You may need to implement this method in your ZegoLiveAudioRoomController
      controller.message.send("Close Seat${seatIndex+1}");
      debugPrint('Host closed seat $seatIndex');
    }
  }

  Widget connectButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isSeatClosedNotifier,
      builder: (context, isSeatClosed, _) {
        return isSeatClosed
            ? ValueListenableBuilder<bool>(
          valueListenable: isRequestingNotifier,
          builder: (context, isRequesting, _) {
            return isRequesting
                ? ElevatedButton(
              onPressed: () {
                controller.cancelSeatTakingRequest().then((result) {
                  isRequestingNotifier.value = false;
                });
              },
              child: const Text('Cancel'),
            )
                : ElevatedButton(
              onPressed: () {
                controller.applyToTakeSeat().then((result) {
                  isRequestingNotifier.value = result;
                });
              },
              child: const Text('Request'),
            );
          },
        )
            : Container();
      },
    );
  }
  int getHostSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  bool isAttributeHost(Map<String, String>? userInRoomAttributes) {
    return (userInRoomAttributes?[attributeKeyRole] ?? "") ==
        ZegoLiveAudioRoomRole.host.index.toString();
  }
  Widget backgroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    if (!isAttributeHost(user!.inRoomAttributes as Map<String, String>?)) {
      return Container();
    }

    return Positioned(
      top: -8,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image:DecorationImage(
              image: CachedNetworkImageProvider(framePhoto)
          )
        ),
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
              image:CachedNetworkImageProvider(wallpaper==""?"https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462":wallpaper)
            ),
          ),
        ),
         Positioned(
            top: 10,
            left: 10,
            child: InkWell(
              onTap: (){
                UpdateBio();
              },
              child: Text(
                bio,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            "ID : ${viewID}",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        giftMedia!=""?Center(
          child:gifttype!="svga"? CachedNetworkImage(
            imageUrl: giftMedia,
          ):SVGASimpleImage(
            resUrl: giftMedia,
          ),
        ):Container(),
        carMedia!=""?Center(
          child:cartype!="svga"? CachedNetworkImage(
            imageUrl: carMedia,
          ):SVGASimpleImage(
            resUrl: carMedia,
          ),
        ):Container(),

      ],
    );
  }
  void SetPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تعين كلمة سر"),
              content: Container(
                child: SizedBox(
                  height: 478,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:  List.generate(
                                6,
                                    (index) => SizedBox(
                                  width: 40.0,
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < 5) {
                                        _focusNodes[index + 1].requestFocus();
                                      } else if (value.isEmpty && index > 0) {
                                        _focusNodes[index - 1].requestFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: ()async {
                                String passs = _controllers.map((controller) => controller.text).join();
                                _firestore.collection('room').doc(widget.roomID).update({
                                  'password':passs,
                                }).then((value){
                                  setState(() {
                                    pass=passs;
                                    for(int i=0;i<_controllers.length;i++){
                                      _controllers[i].clear();
                                    }
                                  });
                                  controller.message.send('Set Password to Room');
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('Save Password'),
                            ),
                          ],
                        )
                    ),
                  ),
                )
              )
          );
        });
  }
  Widget MyWallpaper() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin:  EdgeInsets.all(18),
        child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mylook').where('cat',isEqualTo: 'wallpaper').snapshots(),
              builder: (context,snapshot){
                List<String> wallpapersDoc=[];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed){
                  wallpapersDoc.add(massege.get('id'));
                }
                return GridView.builder(
                    itemCount: wallpapersDoc.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context,index){
                      return  StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection("store").where('id',isEqualTo: wallpapersDoc[index]).snapshots(),
                        builder: (context,snapshot){
                          String wallpaperPhoto="";
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                          final masseges = snapshot.data?.docs;
                          for (var massege in masseges!.reversed){
                            wallpaperPhoto=massege.get('photo');
                          }
                          return InkWell(
                            onTap: ()async{
                              await _firestore.collection('room').doc(widget.roomID).update({
                                'wallpaper':wallpaperPhoto
                              }).then((value){
                                controller.message.send('Change Wallpaper of Room');
                                setState(() {
                                  wallpaper=wallpaperPhoto;
                                });
                              });
                            },
                            child: CircleAvatar(
                              radius: 30,
                              child: CachedNetworkImage(imageUrl:wallpaperPhoto),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        },
                      );
                }
                );
              },
            )
        ),
      ),
    );
  }
  Widget MyMusic() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin:  EdgeInsets.all(18),
        child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView.builder(
              itemCount: musicPath.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(musicname[index],style: TextStyle(color: Colors.white),),
                  trailing: IconButton(onPressed: (){
                    setState(() {
                      viewMusic=true;
                    });
                    controller.media.play(filePathOrURL: musicPath[index]);
                    controller.message.send('Play music ${musicPath[index]}');
                    Navigator.pop(context);
                  }, icon: Icon(Icons.play_arrow,color: Colors.green,)),
                );
              },
            )
        ),
      ),
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
                                  bottomSheet2(gifts[index]));
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
  String mycoin="";
  String myexp="";
  String myfamily="";
  Widget bottomSheet2(GiftModel gift) {
    return SizedBox(
      height: 478,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.black,
        margin:  EdgeInsets.all(18),
        child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView.builder(
              itemCount: userSeats.length,
              itemBuilder: (context,index){
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('user').where("doc",isEqualTo: userSeats[index]).snapshots(),
                  builder: (context,snapshot){
                    String type="";
                    String name="";
                    String photo="";
                    String framedoc="";
                    String framephoto="";
                    String agent="";
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                    final masseges = snapshot.data?.docs;
                    for (var massege in masseges!.reversed){
                      name=massege.get('name');
                      photo=massege.get("photo");
                      framedoc=massege.get("myframe");
                      type=massege.get('type');
                      agent=massege.get('myagent');
                      if(userSeats[index]==_auth.currentUser!.uid){
                        mycoin=massege.get('coin');
                        myexp=massege.get('exp');
                        myfamily=massege.get('myfamily');
                      }
                    }
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('store').where("id",isEqualTo: framedoc).snapshots(),
                      builder: (context,snapshot){
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                        final masseges = snapshot.data?.docs;
                        for (var massege in masseges!.reversed){
                          framephoto=massege.get('photo');
                        }
                        return userSeats[index]==_auth.currentUser!.uid?Container()
                            :ListTile(
                          title: Text(name,style: TextStyle(color: Colors.white),),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(photo),
                                radius: 12,
                                backgroundColor: Colors.white,
                              ),
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(framephoto),
                                radius: 12,
                                backgroundColor: Colors.transparent,
                              )
                            ],
                          ),
                          onTap: ()async{
                            int coins=int.parse(mycoin);
                            int price=int.parse(gift.price);
                            double exp2=0;
                            int daimonds=0;
                            if(coins>=price){
                              int exp=int.parse(myexp);
                              exp=exp+price;
                              coins=coins-price;
                              await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                                'coin':coins.toString(),
                                'exp':exp.toString(),
                              }).then((value){
                                _firestore.collection('user').doc(userSeats[index]).get().then((value){
                                  exp2=double.parse(value.get('exp2'));
                                  daimonds=int.parse(value.get('daimond'));
                                }).then((value){
                                  daimonds=daimonds+price;
                                  double newexp=(exp2)+(daimonds/4);
                                  _firestore.collection('user').doc(userSeats[index]).update({
                                    'exp2':newexp.toString(),
                                    'daimond':daimonds.toString(),
                                  }).then((value){
                                    _firestore.collection('user').doc(userSeats[index]).collection('Mygifts').doc().set({
                                      'id':gift.docID
                                    }).then((value){
                                      _firestore.collection('user').doc(userSeats[index]).get().then((value){
                                        String friendfamily=value.get('myfamily');
                                        if(friendfamily==""){

                                        }
                                        else{
                                          _firestore.collection('family').doc(friendfamily).collection('count2').doc().set({
                                            'user':userSeats[index],
                                            'day':DateTime.now().day.toString(),
                                            'month':DateTime.now().month.toString(),
                                            'year':DateTime.now().year.toString(),
                                            'coin':gift.price
                                          });
                                        }
                                      });
                                    }).then((value){
                                      String docs="${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
                                      if(type=="host"){
                                        int lastincome=0;
                                        _firestore.collection('agency').doc(agent).collection('users').doc(userSeats[index]).collection('income').doc(docs).get().then((value){
                                          lastincome=int.parse(value.get('count'))+int.parse(gift.price);
                                        }).whenComplete((){
                                          if(lastincome==0){
                                            _firestore.collection('agency').doc(agent).collection('users').doc(userSeats[index]).collection('income').doc(docs).set({
                                              'date':DateTime.now().toString(),
                                              'hosttime':'0',
                                              'numberradio':'0',
                                              'count':gift.price,
                                            });
                                          }
                                          else{
                                            _firestore.collection('agency').doc(agent).collection('users').doc(userSeats[index]).collection('income').doc(docs).update({
                                              'count':lastincome.toString()
                                            });
                                          }
                                          SendDone();
                                          Navigator.pop(context);
                                        });
                                      }
                                      else{
                                        SendDone();
                                        Navigator.pop(context);
                                      }
                                    }).then((value){
                                      Navigator.pop(context);
                                      controller.message.send("Send ${gift.Name} to User ${name}");
                                      _firestore.collection('room').doc(widget.roomID).update({
                                        'gift':gift.photo,
                                        'gifttype':gift.type
                                      });
                                      setState(() {
                                        giftMedia=gift.photo;
                                        gifttype=gift.type;
                                      });
                                      SendDone();
                                      Future.delayed(const Duration(seconds: 4)).then((value){
                                        _firestore.collection('room').doc(widget.roomID).update({
                                          'gift':"",
                                          'gifttype':""
                                        });
                                        setState(() {
                                          giftMedia="";
                                          gifttype="";
                                        });
                                      }).then((value){
                                        String docGift="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                                        _firestore.collection('room').doc(widget.roomID).collection('gift').doc(docGift).set({
                                          'giftdoc':gift.docID,
                                          'sender':_auth.currentUser!.uid,
                                          'recever':userSeats[index]
                                        }).then((value){
                                          _firestore.collection('user').doc(_auth.currentUser!.uid).collection('sendgift').doc().set({
                                            'giftid':gift.docID,
                                            'target':userSeats[index]
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            }
                            else{
                              SendDisApprove();
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            )
        ),
      ),
    );
  }
  void SendDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("مبروك"),
              content: Container(
                height: 120,
                child: Center(
                  child:  Text("تم ارسال الهدية بنجاح"),
                ),
              )
          );
        });
  }
  void SendDisApprove() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ناسف"),
              content: Container(
                height: 120,
                child: Center(
                  child:  Text("لا تملك العملات الكافية"),
                ),
              )
          );
        });
  }
  void UpdateBio() {
    TextEditingController controllerBio=TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تحديث عنوان الغرفة"),
              content: Container(
                height: 220,
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'ادخل عنوان الغرفة الجديد',
                      ),
                      controller: controllerBio,
                    ),
                    ElevatedButton(onPressed: (){}, child: Text("تحديث"))
                  ],
                )
              )
          );
        });
  }
  void ShowNumberSeat() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تحدديد عدد المايكات"),
              content: Container(
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: ()async{
                      _firestore.collection('room').doc(widget.roomID).update({
                        'seat':'9'
                      }).then((value){
                        setState(() {
                          layoutSeats='9';
                          Navigator.pop(context);
                        });
                      });
                    }, child: Text('9')),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: ()async{
                      _firestore.collection('room').doc(widget.roomID).update({
                        'seat':'11'
                      }).then((value){
                        setState(() {
                          layoutSeats='11';
                          Navigator.pop(context);
                        });
                      });
                    }, child: Text('11')),
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: ()async{
                      _firestore.collection('room').doc(widget.roomID).update({
                        'seat':'13'
                      }).then((value){
                        setState(() {
                          layoutSeats='13';
                          Navigator.pop(context);
                        });
                      });
                    }, child: Text('13')),
                  ],
                )
              )
          );
        });
  }
  void onMemberListMoreButtonPressed(ZegoUIKitUser user) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        const textStyle = TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
        final listMenu =widget.isHost
            ? [
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
              ZegoUIKit().removeUserFromRoom(
                [user.id],
              ).then((result) {
                _firestore.collection("room").doc(widget.roomID).collection('user').doc(user.id).delete().then((value){
                  controller.message.send('Kikout ${user.name} from room');
                });
              });
            },
            child: Text(
              'Kick Out ${user.name}',
              style: textStyle,
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
              _firestore.collection('room').doc(widget.roomID).collection('block').doc(user.id).set({
                'id':user.id
              }).then((value){
                ZegoUIKit().removeUserFromRoom(
                  [user.id],
                ).then((result) {
                  _firestore.collection("room").doc(widget.roomID).collection('user').doc(user.id).delete().then((value){
                    controller.message.send('Block ${user.name} in room');
                  });
                });
              });
            },
            child: Text(
              'Block ${user.name}',
              style: textStyle,
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();

              controller
                  ?.inviteAudienceToTakeSeat(user.id)
                  .then((result) {
                debugPrint('invite audience to take seat result:$result');
              });
            },
            child: Text(
              'Invite ${user.name} to take seat',
              style: textStyle,
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: textStyle,
            ),
          ),
        ]
            : [];
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listMenu.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 60,
                  child: Center(child: listMenu[index]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
