import 'package:flutter/material.dart';

import '../models/room_model.dart';
import 'horezintal_rooms_list_item.dart';


class HorezintalRoomsListViewBuilder extends StatelessWidget {
  const HorezintalRoomsListViewBuilder({
    super.key,
    required this.screenHight,
    required this.rooms,
    required this.screenWidth,
  });

  final double screenHight;
  final List<RoomModel> rooms;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHight * 0.15,
      child: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return HorezintalRoomsListItem(
              index: index + 1,
              screenWidth: screenWidth,
              screenHight: screenHight,
              roomModel: rooms[index]);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
