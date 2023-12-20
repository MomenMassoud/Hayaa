import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_colors.dart';
import 'package:hayaa_main/features/agencies/models/agency_model.dart';

class AgenciesListItem extends StatelessWidget {
  const AgenciesListItem({super.key, required this.screenWidth, required this.screenHeight, required this.agencyModel});

  final double screenWidth;
  final double screenHeight;
  final AgencyModel agencyModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.1,
      decoration: const BoxDecoration(),
      child: Center(
          child: Row(
        children: [
          Container(
            width: screenWidth * 0.2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(agencyModel.agencyImage))),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                agencyModel.agencyName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.app3MainColor),
              onPressed: () {},
              child: const Text(
                "Join",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      )),
    );
  }
}
