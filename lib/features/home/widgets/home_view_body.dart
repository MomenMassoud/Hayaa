import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
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
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.manage_search_rounded)),
          IconButton(
            onPressed: () {},
            icon: const Image(image: AssetImage(AppImages.prizeIcon)),
          ),
          SizedBox(
            width: screenWidth * 0.25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: screenWidth * 0.12,
                  child:  Text(
                    "مجاورون",
                    style: TextStyle(fontFamily: "Hayah", fontSize: 20),
                  ).tr(args: ['مجاورون']),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: screenWidth * 0.12,
                    child:  Text(
                      "شعبي",
                      style: TextStyle(fontFamily: "Hayah", fontSize: 22),
                    ).tr(args: ['شعبي']),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: screenWidth * 0.12,
                  child:  Text(
                    "متعلق",
                    style: TextStyle(fontFamily: "Hayah", fontSize: 20),
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
