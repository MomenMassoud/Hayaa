import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/games/widgets/sub_game_list.dart';
import 'package:hayaa_main/features/games/widgets/sub_games.dart';


import '../../../core/Utils/app_images.dart';
import '../../home/models/room_model.dart';
import '../../home/widgets/horizontal_event_slider.dart';
import '../../home/widgets/vertical_rooms_list_view_builder.dart';
import 'custom_card_game.dart';


class Games extends StatefulWidget{
  _Games createState()=>_Games();
}

class _Games extends State<Games>{
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
  List<SubGames> games=[
    SubGames(AppImages.uno, "Free", "UNO"),
    SubGames(AppImages.domino, "10", "Domino"),
    SubGames(AppImages.uno, "Free", "UNO"),
    SubGames(AppImages.uno, "Free", "UNO"),
    SubGames(AppImages.uno, "Free", "UNO"),
    SubGames(AppImages.uno, "Free", "UNO")
  ];
  List<dynamic> images = [
    Image.asset(AppImages.event1),
    Image.asset(AppImages.event2),
    Image.asset(AppImages.event3),
    Image.asset(AppImages.event4),
  ];
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          CustomCardGame(),
          Container(
              height: 150.0,
              child: SubGameList(games)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalEventSlider(
                screenHight: screenHight,
                screenWidth: screenWidth,
                images: images),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("غرفة الالعاب",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),).tr(args: ['غرفة الالعاب']),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: VerticalRoomsListViewBuilder(
                rooms: rooms,
                screenWidth: screenWidth,
                screenHight: screenHight),
          )
        ],
      )
    );
  }

}