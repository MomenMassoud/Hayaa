import 'package:flutter/material.dart';
import 'package:hayaa_main/features/agencies/views/agency_agent_view.dart';
import 'package:hayaa_main/features/agencies/widgets/custom_image_picker.dart';
import 'package:hayaa_main/features/agencies/widgets/seperated_text.dart';
import 'package:hayaa_main/features/auth/choice%20between%20registration%20and%20login/widgets/gradiant_button.dart';

class AgencyCreationViewBody extends StatefulWidget {
  const AgencyCreationViewBody({
    super.key,
  });

  @override
  State<AgencyCreationViewBody> createState() => _AgencyCreationViewBodyState();
}

class _AgencyCreationViewBodyState extends State<AgencyCreationViewBody> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text("Hayaa", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomImagePicker(
                screenWidth: screenWidth,
                onTap: () {},
              ),
              const SeperatedText(
                tOne: "Agency Name ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Please Enter Name",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "Definition Of Agency ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(fontSize: 22),
                maxLength: 300,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Please Define Your Agency",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SeperatedText(
                tOne: "Mean Of Communication ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Please Enter Your E-mail",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "A Photo Of The ID Card ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Icon(
                          Icons.add,
                          size: screenWidth * 0.2,
                          color: Colors.blueGrey,
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Icon(
                          Icons.add,
                          size: screenWidth * 0.2,
                          color: Colors.blueGrey,
                        )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "Country",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Choose Country",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SizedBox(
                height: 30,
              ),
              GradiantButton(
                  screenWidth: screenWidth,
                  buttonLabel: "Create Agency ",
                  onPressed: () {
                    Navigator.pushNamed(context, AgencyAgentView.id);
                  },
                  buttonRatio: 0.8),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
