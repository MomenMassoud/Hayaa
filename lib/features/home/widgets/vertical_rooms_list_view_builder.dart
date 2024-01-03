import 'package:flutter/material.dart';
import 'package:hayaa_main/features/home/widgets/vertical_rooms_list_item.dart';

import '../../../models/room_model.dart';
import '../models/room_model.dart';

class VerticalRoomsListViewBuilder extends StatelessWidget {
  const VerticalRoomsListViewBuilder({
    super.key,
    required this.rooms,
    required this.screenWidth,
    required this.screenHight,
  });

  final List<RoomModels> rooms;
  final double screenWidth;
  final double screenHight;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        growable: true,
        rooms.length,
            (index) {
          return VerticalRoomsListItem(
              index: index + 1,
              screenWidth: screenWidth,
              screenHight: screenHight,
              roomModel: rooms[index]);
        },
      ),
    );
  }
}
