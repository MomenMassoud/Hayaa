import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/room_model.dart';
import '../views/all_rooms_view.dart';
import 'gradient_rounded_container.dart';
import 'horezintal_rooms_list_view_builder.dart';

class HorezintalSection extends StatelessWidget {
  const HorezintalSection({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.rooms,
  });

  final double screenWidth;
  final double screenHight;
  final List<RoomModel> rooms;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GradientRoundedContainer(
        colorOne: Colors.pink.withOpacity(0),
        colorTwo: Colors.pink.withOpacity(0),
        screenWidth: screenWidth,
        screenHeight: screenHight * 0.15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AllRoomsView.id);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.pink),
                      Text("الكل",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: screenHight * 0.02,
                              fontFamily: "Questv1"))
                          .tr(args: ['الكل']),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 5),
                child: Text("غرف الاصدقاء",
                    style: TextStyle(
                        color: Colors.pink,
                        fontSize: screenHight * 0.02,
                        fontFamily: "Questv1"))
                    .tr(args: ['قد تكون مهتماً']),
              ),
            ],
          ),
          HorezintalRoomsListViewBuilder(
              screenHight: screenHight, rooms: rooms, screenWidth: screenWidth),
        ],
      )
    ]);
  }
}
