import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/features/agencies/models/agency_model.dart';
import 'package:hayaa_main/features/agencies/views/agency_creation_view.dart';
import 'package:hayaa_main/features/agencies/widgets/agencies_list_item.dart';

class AgencyJoiningViewBody extends StatefulWidget {
  const AgencyJoiningViewBody({
    super.key,
  });

  @override
  State<AgencyJoiningViewBody> createState() => _AgencyJoiningViewBodyState();
}

class _AgencyJoiningViewBodyState extends State<AgencyJoiningViewBody> {
  List<AgencyModel> agencies = [
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p3,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p1,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p3,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p2,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p3,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p1,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p3,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p1,
        agencyDefinition: "Lovly Agency"),
    AgencyModel(
        agencyName: "Community",
        agencyImage: AppImages.p2,
        agencyDefinition: "Lovly Agency"),
  ];
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Choose Agency",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: screenWidth * 0.4,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AgencyCreationView.id);
              },
              child: const Text("Create Agency",
                  style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
                itemCount: agencies.length,
                itemBuilder: (context, index) {
                  return AgenciesListItem(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      agencyModel: agencies[index]);
                }),
          ))
        ],
      ),
    );
  }
}
