import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/view/room_view.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';
import '../models/room_model.dart';
import 'horezintal_rooms_section.dart';
import 'horizontal_event_slider.dart';
import 'sub_screens_section.dart';
import 'vertical_rooms_list_view_builder.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel userModel = UserModel(
      "email",
      "name",
      "gende",
      "photo",
      "id",
      "phonenumber",
      "devicetoken",
      "daimond",
      "vip",
      "bio",
      "seen",
      "lang",
      "country",
      "type",
      "birthdate",
      "coin",
      "exp",
      "level");

  @override
  void initState() {
    super.initState();
    start();
    getEvent();
  }

  void start() async {
    if (_auth.currentUser!.email == null) {
      await for (var snap in _firestore
          .collection('user')
          .where('phonenumber', isEqualTo: _auth.currentUser!.phoneNumber)
          .snapshots()) {
        userModel.bio = snap.docs[0].get('bio');
        userModel.birthdate = snap.docs[0].get('birthdate');
        userModel.coin = snap.docs[0].get('coin');
        userModel.country = snap.docs[0].get('country');
        userModel.daimond = snap.docs[0].get('daimond');
        userModel.devicetoken = snap.docs[0].get('devicetoken');
        userModel.email = snap.docs[0].get('email');
        userModel.exp = snap.docs[0].get('exp');
        userModel.gender = snap.docs[0].get('gender');
        userModel.id = snap.docs[0].get('id');
        userModel.lang = snap.docs[0].get('lang');
        userModel.level = snap.docs[0].get('level');
        userModel.name = snap.docs[0].get('name');
        userModel.phonenumber = snap.docs[0].get('phonenumber');
        userModel.photo = snap.docs[0].get('photo');
        userModel.seen = snap.docs[0].get('seen');
        userModel.type = snap.docs[0].get('type');
        userModel.vip = snap.docs[0].get('vip');
        userModel.myroom=snap.docs[0].get('room');
      }
    } else {
      await for (var snap in _firestore
          .collection('user')
          .where('email', isEqualTo: _auth.currentUser!.email)
          .snapshots()) {
        userModel.bio = snap.docs[0].get('bio');
        userModel.birthdate = snap.docs[0].get('birthdate');
        userModel.coin = snap.docs[0].get('coin');
        userModel.country = snap.docs[0].get('country');
        userModel.daimond = snap.docs[0].get('daimond');
        userModel.devicetoken = snap.docs[0].get('devicetoken');
        userModel.email = snap.docs[0].get('email');
        userModel.exp = snap.docs[0].get('exp');
        userModel.gender = snap.docs[0].get('gender');
        userModel.id = snap.docs[0].get('id');
        userModel.lang = snap.docs[0].get('lang');
        userModel.level = snap.docs[0].get('level');
        userModel.name = snap.docs[0].get('name');
        userModel.phonenumber = snap.docs[0].get('phonenumber');
        userModel.photo = snap.docs[0].get('photo');
        userModel.seen = snap.docs[0].get('seen');
        userModel.type = snap.docs[0].get('type');
        userModel.vip = snap.docs[0].get('vip');
        userModel.myroom=snap.docs[0].get('room');
      }
    }
    setState(() {
      userModel;
    });
  }
  void getEvent()async{
    await for(var snap in _firestore.collection('event').snapshots()){
      for(int i=0;i<snap.size;i++){
        setState(() {
          images.add(
              snap.docs[i].get('photo')
          );
        });
      }
    }
  }
  List<String> images = [];
  List<String> countryCodes = Flags.flagsCode;
  List<RoomModel> rooms = [
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage2),
  ];
  List<RoomModel> rooms2 = [
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage4),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.search,color: Colors.white,)),
          IconButton(
              onPressed: () {
                // if(userModel.myroom==""){
                //   CreateRoom();
                // }
                // else{
                //   _firestore.collection('room').doc(userModel.myroom).collection('user').doc(_auth.currentUser!.uid).set({
                //     'id':userModel.id,
                //     'doc':_auth.currentUser!.uid
                //   }).then((value){
                //     Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => RoomView(userModel.myroom,true,userModel.name,_auth.currentUser!.uid,),));
                //   });
                // }

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RoomView("2023-12-28 15:16:07.683239-tJlADfx1AwY3eVxB0E9N4ANKFbx1",false,userModel.name,_auth.currentUser!.uid,),));
              }, icon:userModel.myroom==""?Icon(Icons.add_home_outlined,color: Colors.white,):
              Icon(Icons.home_filled,color: Colors.white,)
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: const Text(
                    "مجاورون",
                    style: TextStyle(
                        fontFamily: "Hayah", fontSize: 20, color: Colors.white),
                  ).tr(args: ['مجاورون']),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: const Text(
                      "شعبي",
                      style: TextStyle(
                          fontFamily: "Hayah",
                          fontSize: 22,
                          color: Colors.white),
                    ).tr(args: ['شعبي']),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: const Text(
                    "متعلق",
                    style: TextStyle(
                        fontFamily: "Hayah", fontSize: 20, color: Colors.white),
                  ).tr(args: ['متعلق']),
                ),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: HorizontalEventSlider(
                    screenHight: MediaQuery.of(context).size.height,
                    screenWidth: MediaQuery.of(context).size.width,
                    images: images),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
                child: SubScreensSection(
                  screenHight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0,right: 8.0,left: 8.0),
                child: HorezintalSection(
                    screenWidth: MediaQuery.of(context).size.width,
                    screenHight: MediaQuery.of(context).size.height,
                    rooms: rooms),
              ),
              ListTile(
                title: Text("الدول",style: TextStyle(color: Colors.pink.withOpacity(1),fontFamily: "Questv1"),),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Show All",style: TextStyle(color: Colors.pink.withOpacity(1),fontFamily: "Questv1")),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward,color:Colors.pink.withOpacity(1) ,))
                  ],
                ) ,
              ),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:8,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flag.fromString(
                            countryCodes[index],
                            height: 40,
                            width: 60,
                          ),
                          SizedBox(height: 5),
                          Text(
                            Flag.fromString(
                              countryCodes[index],
                              height: 40,
                              width: 60,
                            ).country,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0,right: 8.0,left: 8.0,bottom: 8.0),
                child: VerticalRoomsListViewBuilder(
                    rooms: rooms,
                    screenWidth: MediaQuery.of(context).size.width,
                    screenHight: MediaQuery.of(context).size.height),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.0,bottom: 18),
                child: HorizontalEventSlider(
                    screenHight: MediaQuery.of(context).size.height,
                    screenWidth: MediaQuery.of(context).size.width,
                    images: images),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: VerticalRoomsListViewBuilder(
                    rooms: rooms2,
                    screenWidth: MediaQuery.of(context).size.width,
                    screenHight: MediaQuery.of(context).size.height),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> generateFlagsWithCode() {
    List<String> countryCodes = Flags.flagsCode;
    return countryCodes.map((code) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flag.fromString(
              code,
              height: 40,
              width: 60,
            ),
            SizedBox(height: 5),
            Text(
              Flag.fromString(
                code,
                height: 40,
                width: 60,
              ).country,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }
  void CreateRoom() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تنبيه"),
              content: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("هل تود انشاء غرفتك"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: ()async{
                          String roomID="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                          _firestore.collection('room').doc(roomID).set({
                            'id':userModel.id,
                            'doc':roomID,
                            'owner':_auth.currentUser!.uid
                          }).then((value){
                           _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                             'room':roomID
                           }).then((value){
                             setState(() {
                               userModel.myroom=roomID;
                             });
                             Navigator.pop(context);
                           });
                          });
                        }, child: Text("نعم")),
                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("لا"))
                      ],
                    )
                  ],
                ),
              )
          );
        });
  }
}
