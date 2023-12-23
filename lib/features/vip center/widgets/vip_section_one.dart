import 'package:flutter/material.dart';
import '../models/feature_model.dart';
import 'feature_item.dart';


class VipSectionOne extends StatefulWidget {
  const VipSectionOne({
    super.key,
  });

  @override
  State<VipSectionOne> createState() => _VipSectionOneState();
}

class _VipSectionOneState extends State<VipSectionOne> {
  List<FeatureModel> featurs = [
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/1.png",
        featureLable: "مؤثرات الدخول",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/2.png",
        featureLable: "براويز مميزة ",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/3.png",
        featureLable: "ايقونة ",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/4.png",
        featureLable: "مؤثرات الدخول",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/5.png",
        featureLable: "مؤثرات الدخول",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/6.png",
        featureLable: "مؤثرات الدخول",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/1.png",
        featureLable: "مؤثرات الدخول",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/2.png",
        featureLable: "مؤثرات الدخول",
        active: true),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/3.png",
        featureLable: "مؤثرات الدخول",
        active: false),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/4.png",
        featureLable: "مؤثرات الدخول",
        active: false),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/5.png",
        featureLable: "مؤثرات الدخول",
        active: false),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/6.png",
        featureLable: "مؤثرات الدخول",
        active: false),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/3.png",
        featureLable: "مؤثرات الدخول",
        active: false),
    FeatureModel(
        featureIcon: "lib/core/Utils/assets/images/vip_icon/4.png",
        featureLable: "مؤثرات الدخول",
        active: false),
  ];
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHight * 0.22,
          width: screenWidth,
          child: Center(
            child: SizedBox(
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                child: const Image(image: AssetImage("lib/core/Utils/assets/images/1b.png"))),
          ),
        ),
        Expanded(
          child: ClipPath(
            clipper: CurvedContainerClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: SizedBox(
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHight * 0.05,
                    ),
                    Text("الامتيازات",
                        style: TextStyle(color: Colors.amberAccent[100])),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(featurs.length, (index) {
                            return FeatureItem(
                                screenWidth: screenWidth,
                                featureModel: featurs[index]);
                          }),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHight * 0.08,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: const Border(
                              top: BorderSide(color: Colors.grey, width: 0.6))),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.amberAccent),
                              ),
                              onPressed: () {},
                              child: Text(
                                "شراء",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        22), // Set the border radius
                                    side: const BorderSide(
                                        color: Colors.amberAccent,
                                        width: 1), // Set the border properties
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "ارسال",
                                style: TextStyle(color: Colors.amberAccent),
                              )),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            " 5000 ذهب ",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 20),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CurvedContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CurvedContainerClipper oldClipper) => false;
}
