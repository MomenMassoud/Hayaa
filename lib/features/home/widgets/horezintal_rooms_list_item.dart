import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/room_model.dart';

class HorezintalRoomsListItem extends StatelessWidget {
  const HorezintalRoomsListItem({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.roomModel,
    required this.index,
  });

  final double screenWidth;
  final double screenHight;
  final RoomModel roomModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("${index}tapped");
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth * 0.2,
              height: screenHight * 0.1,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        roomModel.userImage!,
                      ),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle,
                  color: Colors.amber,
                  border: Border.all(
                      color: Colors.pinkAccent.withOpacity(0.5), width: 3)),
            ),
          ),
          Text(
            '${roomModel.name} $index' ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
