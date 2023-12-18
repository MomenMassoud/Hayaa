import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      }
    }
    setState(() {
      userModel;
    });
  }

  List<dynamic> images = [
    Image.asset(AppImages.event1),
    Image.asset(AppImages.event2),
    Image.asset(AppImages.event3),
    Image.asset(AppImages.event4),
  ];

  List<RoomModel> rooms = [
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
  ];
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
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.manage_search_rounded)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
          SizedBox(
            width: screenWidth * 0.25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: screenWidth * 0.19,
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
                    width: screenWidth * 0.12,
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
                  width: screenWidth * 0.15,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HorizontalEventSlider(
                  screenHight: screenHight,
                  screenWidth: screenWidth,
                  images: images),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SubScreensSection(
                screenHight: screenHight,
                screenWidth: screenWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: HorezintalSection(
                  screenWidth: screenWidth,
                  screenHight: screenHight,
                  rooms: rooms),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: VerticalRoomsListViewBuilder(
                  rooms: rooms,
                  screenWidth: screenWidth,
                  screenHight: screenHight),
            )
          ],
        ),
      ),
    );
  }
}
