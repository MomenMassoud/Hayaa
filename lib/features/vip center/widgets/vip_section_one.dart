import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/features/vip%20center/widgets/send_vip.dart';
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
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  List<FeatureModel> featurs = [
    FeatureModel(
        featureIcon: AppImages.Wearingmedal ,
        featureLable: "Wearing medal ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Titlemedal ,
        featureLable: "Title medal ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Roomentereffect ,
        featureLable: "Room enter effect  ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Flyingcomments,
        featureLable: "Flying comments ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Colorednickname,
        featureLable: "Colored nickname ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Toponlinerankinglist,
        featureLable: "Top Medal",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Upgradelevelfast ,
        featureLable: "Upgrade level fast ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.platformwidenotification ,
        featureLable: "platform-wide notification ",
        active: true),
    FeatureModel(
        featureIcon: AppImages.Exclusivenobletitlecard ,
        featureLable: "Exclusive noble title card ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.specialchatbubble,
        featureLable: "special chat bubble",
        active: false),
    FeatureModel(
        featureIcon: AppImages.exclusiverideandmic ,
        featureLable: "exclusive ride and mic ",
        active: false),
    FeatureModel(
        featureIcon: AppImages.Exclusivegifts ,
        featureLable: "Exclusive gifts ",
        active: false),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVipPrice();
  }
  String coin="";
  void getVipPrice()async{
    await for(var snap in _firestore.collection('vip').where('id',isEqualTo: 'vip1').snapshots()){
      setState(() {
        coin=snap.docs[0].get('coin');
      });
    }
  }
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
                child: const Image(image: AssetImage(AppImages.VIP1))),
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
                              onPressed: () async{
                                DateTime now=DateTime.now();
                                int month=now.month+1;
                                int mycoin=0;
                                DateTime end=DateTime(now.year,month,now.day,now.hour,now.minute,now.second,now.millisecond,now.microsecond);
                                _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((value){
                                   mycoin=int.parse(value.get('coin'));
                                }).then((value){
                                  if(mycoin>=int.parse(coin)){
                                    int newcoin=mycoin-int.parse(coin);
                                    _firestore.collection("user").doc(_auth.currentUser!.uid).update({
                                      'vip':'1',
                                      'vip_end':end.toString(),
                                      'coin':newcoin.toString()
                                    }).then((value){
                                      Allarm();
                                      _firestore.collection('user').doc(_auth.currentUser!.uid).collection('payment').doc().set({
                                        'date':DateTime.now().toString(),
                                        'type':'coin',
                                        'pay':'out',
                                        'value':coin,
                                        'bio':'vip1'
                                      });
                                    });
                                  }
                                  else{
                                    AllarmError();
                                  }
                                });

                              },
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SendVip('1', int.parse(coin))));
                              },
                              child: const Text(
                                "ارسال",
                                style: TextStyle(color: Colors.amberAccent),
                              )),
                        ),
                        const Spacer(),
                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "$coin Coin",
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
  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title:Text("مبرك"),
              content:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("تم الحصول هذه Vip")
                ],
              )
          );
        });
  }
  void AllarmError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title:Text("ناسف"),
              content:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("لا تملك عملات كافية")
                ],
              )
          );
        });
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
