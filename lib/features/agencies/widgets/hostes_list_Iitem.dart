import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/agencies/models/host_model.dart';

import '../../../core/Utils/app_images.dart';

class HostsListItem extends StatelessWidget {
  const HostsListItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight, required this.hostModel,
  });

  final double screenWidth;
  final double screenHeight;
  final HostModel hostModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.1,
      decoration:  BoxDecoration(),
      child: Center(
          child: Row(
        children: [
          Container(
            width: screenWidth * 0.2,
            decoration:  BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: CachedNetworkImageProvider(hostModel.hostImage))),
          ),
          const SizedBox(
            width: 10,
          ),
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hostModel.hostName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(hostModel.hostId),
            ],
          ),
          const Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {},
              child: const Text(
                "Remove",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      )),
    );
  }
}
