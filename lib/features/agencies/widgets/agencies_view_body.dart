import 'package:flutter/material.dart';
import 'package:hayaa_main/features/agencies/views/agency_creation_view.dart';
import 'package:hayaa_main/features/agencies/views/agency_join_view.dart';
import 'package:hayaa_main/features/auth/choice%20between%20registration%20and%20login/widgets/gradiant_button.dart';

class AgenciesViewBody extends StatelessWidget {
  const AgenciesViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Agencies",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradiantButton(
                screenWidth: screenWidth,
                buttonLabel: "Create Agency",
                onPressed: () {
                  Navigator.pushNamed(context, AgencyCreationView.id);
                },
                buttonRatio: 0.7),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        GradiantButton(
            screenWidth: screenWidth,
            buttonLabel: "Join Agency",
            onPressed: () {
              Navigator.pushNamed(context, AgencyJoiningView.id);
            },
            buttonRatio: 0.7),
      ]),
    );
  }
}
