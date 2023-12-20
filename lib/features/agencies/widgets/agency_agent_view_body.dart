import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_colors.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/features/agencies/models/host_model.dart';
import 'package:hayaa_main/features/agencies/widgets/add_host.dart';
import 'package:hayaa_main/features/agencies/widgets/agent_requests.dart';
import 'package:hayaa_main/features/agencies/widgets/hostes_list_Iitem.dart';
import 'package:hayaa_main/models/user_model.dart';

class AgencyAgentViewBody extends StatefulWidget {
  const AgencyAgentViewBody({
    super.key,
  });

  @override
  State<AgencyAgentViewBody> createState() => _AgencyAgentViewBodyState();
}

class _AgencyAgentViewBodyState extends State<AgencyAgentViewBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<HostModel> hosts = [
    HostModel(
        hostId: "090932092", hostImage: AppImages.UserImage, hostName: "Momen"),
    HostModel(
        hostId: "090932sd92",
        hostImage: AppImages.UserImage,
        hostName: "Momen"),
    HostModel(
        hostId: "0909xc092", hostImage: AppImages.UserImage, hostName: "Momen"),
    HostModel(
        hostId: "090ad2092", hostImage: AppImages.UserImage, hostName: "Momen"),
    HostModel(
        hostId: "090932092", hostImage: AppImages.UserImage, hostName: "Momen"),
    HostModel(
        hostId: "090dsd32092",
        hostImage: AppImages.UserImage,
        hostName: "Momen"),
    HostModel(
        hostId: "090sad32092",
        hostImage: AppImages.UserImage,
        hostName: "Momen"),
    HostModel(
        hostId: "090sad32092",
        hostImage: AppImages.UserImage,
        hostName: "Momen"),
    HostModel(
        hostId: "090sad32092",
        hostImage: AppImages.UserImage,
        hostName: "Momen"),
  ];
  String myagend = "";
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text("مرحبا وكيلنا العزيز",
              style: TextStyle(fontWeight: FontWeight.bold)).tr(args: ['مرحبا وكيلنا العزيز']),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .where('doc', isEqualTo: _auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              myagend = massege.get('myagent');
            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('agency')
                  .doc(myagend)
                  .collection('users')
                  .where('type', isEqualTo: 'host')
                  .snapshots(),
              builder: (context, snapshot) {
                List<HostModel> host = [];
                List<UserModel> user = [];
                List<String> userDoc = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  final us = UserModel(
                      "email",
                      "name",
                      "gender",
                      "photo",
                      "id",
                      "phonenumber",
                      "devicetoken",
                      "daimond",
                      "vip",
                      "bio",
                      "seen",
                      "lang",
                      "country",
                      "type",
                      "birthdate",
                      "coin",
                      "exp",
                      "level");
                  us.docID = massege.get('userid');
                  user.add(us);
                  userDoc.add(massege.id);
                }
                return user.length>0?ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('user')
                          .where('doc', isEqualTo: user[index].docID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                        final masseges = snapshot.data?.docs;
                        for (var massege in masseges!.reversed) {
                          user[index].bio = massege.get('bio');
                          user[index].birthdate = massege.get('birthdate');
                          user[index].coin = massege.get('coin');
                          user[index].country = massege.get('country');
                          user[index].daimond = massege.get('daimond');
                          user[index].coin = massege.get('coin');
                          user[index].devicetoken = massege.get('devicetoken');
                          user[index].email = massege.get('email');
                          user[index].exp = massege.get('exp');
                          user[index].gender = massege.get('gender');
                          user[index].id = massege.get('id');
                          user[index].lang = massege.get('lang');
                          user[index].level = massege.get('level');
                          user[index].name = massege.get('name');
                          user[index].phonenumber = massege.get('phonenumber');
                          user[index].photo = massege.get('photo');
                          user[index].seen = massege.get('seen');
                          user[index].type = massege.get('type');
                          user[index].vip = massege.get('vip');
                          user[index].docID = massege.id;
                          user[index].myfamily = massege.get('myfamily');
                        }
                        for(int i=0;i<user.length;i++){
                          host.add(
                            HostModel(hostId: user[index].id, hostImage: user[index].photo, hostName: user[index].name)
                          );
                        }
                        return StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('agency')
                              .doc(myagend)
                              .collection('user')
                              .doc(userDoc[index])
                              .collection('income')
                              .snapshots(),
                          builder: (context, snapshot) {
                            int totalincome = 0;
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            }
                            final masseges = snapshot.data?.docs;
                            for (var massege in masseges!.reversed) {
                              totalincome += int.parse(massege.get('count'));
                            }
                            if(index==0){
                              return  Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child:  Text("الاعدادات",
                                              style:
                                              TextStyle(color: Colors.black)).tr(args: ['الاعدادات']),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => AgentRequest(myagend)));
                                          },
                                          child:  Text("طلبات الانضمام",
                                              style:
                                              TextStyle(color: Colors.black)).tr(args: ['طلبات الانضمام']),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) => AddHost(myagend)));
                                          },
                                          child:  Text("اضافة مضيف",
                                              style:
                                              TextStyle(color: Colors.black)).tr(args: ['اضافة مضيف']),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "اجمالي دخل الوكالة الشهري",
                                    style:
                                    TextStyle(fontSize: screenWidth * 0.05),
                                  ).tr(args: ['اجمالي دخل الوكالة الشهري']),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: screenHeight * 0.2,
                                    width: screenWidth * 0.7,
                                    decoration: const BoxDecoration(
                                      color: AppColors.app3MainColor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Column(children: [
                                      SizedBox(
                                        width: screenWidth * 0.3,
                                        child: const Image(
                                          image: AssetImage(AppImages.daimond),
                                        ),
                                      ),
                                      Text(
                                        totalincome.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.07),
                                      ),
                                    ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child:  Text(
                                      "تحميل التقرير الشهري",
                                      style: TextStyle(color: Colors.black),
                                    ).tr(args: ['تحميل التقرير الشهري']),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  HostsListItem(
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      hostModel: host[index])
                                ],
                              );
                            }
                            else{
                              return HostsListItem(
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  hostModel: host[index]);
                            }
                          },
                        );
                      },
                    );
                  },
                ):Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("الاعدادات",
                                style:
                                TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => AgentRequest(myagend)));
                            },
                            child: Text("طلبات الانضمام",
                                style:
                                TextStyle(color: Colors.black)).tr(args: ['طلبات الانضمام']),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => AddHost(myagend)));
                            },
                            child: Text("اضافة مضيف",
                                style:
                                TextStyle(color: Colors.black)).tr(args: ['اضافة مضيف']),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "اجمالي دخل الوكالة الشهري",
                      style:
                      TextStyle(fontSize: screenWidth * 0.05),
                    ).tr(args: ['اجمالي دخل الوكالة الشهري']),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.7,
                      decoration: const BoxDecoration(
                        color: AppColors.app3MainColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(children: [
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: const Image(
                            image: AssetImage(AppImages.daimond),
                          ),
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.07),
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child:  Text(
                        "تحميل التقرير الشهري",
                        style: TextStyle(color: Colors.black),
                      ).tr(args: ['تحميل التقرير الشهري']),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            );
          },
        ));
  }
}
