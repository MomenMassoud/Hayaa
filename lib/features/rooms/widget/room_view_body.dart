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
  List<int> lockedSeats = []; // List to store locked seat indexes
  List<String> userSeats=[];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String framePhoto="";
  final isSeatClosedNotifier = ValueNotifier<bool>(false);
  final isRequestingNotifier = ValueNotifier<bool>(false);
  final controller = ZegoLiveAudioRoomController();
  List<IconData> customIcons = [Icons.cookie, Icons.phone, Icons.speaker, Icons.air, Icons.blender, Icons.file_copy, Icons.place, Icons.phone_android, Icons.phone_iphone];
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
                      roomID: "111222333",
                      config: widget.isHost
                          ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                          : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
                        ..background = background()
                        ..takeSeatIndexWhenJoining =
                        widget.isHost ? getHostSeatIndex() : -1
                        ..hostSeatIndexes = [0]
                        ..useSpeakerWhenJoining=true
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
                        ..innerText.memberListTitle = 'Members'
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
                        ..bottomMenuBarConfig.audienceButtons = const [
                          ZegoMenuBarButtonName.showMemberListButton,
                          ZegoMenuBarButtonName.closeSeatButton,
                          ZegoMenuBarButtonName.applyToTakeSeatButton
                        ]
                        ..bottomMenuBarConfig.audienceExtendButtons = [
                          connectButton(),
                        ]
                      ..onSeatClicked=(index, user) {
                        if(widget.isHost){
                          if(isSeatOpen(index) && user==null){
                            openSeat(index);
                          }
                          else{
                           if(user==null){
                             closeSeat(index);
                           }
                           else{
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
                          // Update usersInSeats list with user IDs in taken seats
                          userSeats.clear();
                          // Iterate through taken seats and print user information
                          takenSeats.forEach((seatIndex, user) {
                            debugPrint('Seat $seatIndex is taken by user: $user');
                            setState(() {
                              userSeats.add(user.id);
                            });
                            // Do whatever you need with the updated list of users in seats
                            debugPrint('Users currently in seats: $userSeats');
                          });

                        }
                        ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                          maxCount: 5,
                          audienceExtendButtons: [
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
                                              bottomSheet());
                                    }, icon: Icon(Icons.card_giftcard,color: Colors.black,))),
                                Text("Send Gift",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ],
                          speakerExtendButtons: [
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
                                              bottomSheet());
                                    }, icon: Icon(Icons.card_giftcard,color: Colors.black,))),
                                Text("Send Gift",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ],
                          hostExtendButtons: [
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
                                              bottomSheet());
                                    }, icon: Icon(Icons.card_giftcard,color: Colors.black,))),
                                Text("Send Gift",style: TextStyle(color: Colors.white),)
                              ],
                            ),
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.password,color: Colors.black,))),
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.music_note,color: Colors.black,))),

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
    return !lockedSeats.contains(seatIndex);
  }

  // Function to open a seat
  void openSeat(int seatIndex) {
    if (widget.isHost && isSeatOpen(seatIndex)) {
      // Implement logic to open the seat
      setState(() {
        lockedSeats.remove(seatIndex);
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
      debugPrint('Host closed seat $seatIndex');
    }
  }


  void showEvictionConfirmationDialog(BuildContext context, int seatIndex, ZegoUIKitUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Evict User'),
          content: Text('Do you want to evict ${user.name} from the seat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to evict the user from the seat
                evictUserFromSeat(seatIndex, user);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Evict'),
            ),
          ],
        );
      },
    );
  }

  void evictUserFromSeat(int seatIndex, ZegoUIKitUser user) {
    // Check if the seat is occupied by the specified user
    controller.removeSpeakerFromSeat(user!.id);
    print("Target ============${user.id}");
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
  void showDemoBottomSheet(BuildContext context) {
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
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Menu $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
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
  Widget foregroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    var userName = user?.name.isEmpty ?? true
        ? Container()
        : Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Text(
        user?.name ?? "",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          backgroundColor: Colors.black.withOpacity(0.1),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    );

    if (!isAttributeHost(user!.inRoomAttributes as Map<String, String>?)) {
      return userName;
    }

    var hostIconSize = Size(size.width / 3, size.height / 3);
    var hostIcon = Positioned(
      bottom: 3,
      right: 0,
      child: Container(
        width: hostIconSize.width,
        height: hostIconSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(_auth.currentUser!.photoURL.toString())
          ),
        ),
      ),
    );

    return Stack(children: [userName, hostIcon]);
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image:CachedNetworkImageProvider("https://firebasestorage.googleapis.com/v0/b/hayaa-161f5.appspot.com/o/rooms%2Fclose-up-microphone-pop-filter-studio.jpg?alt=media&token=c9014900-dba7-4e7c-80c4-8d9fc6055462")
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
                                      SendDone();
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
}
