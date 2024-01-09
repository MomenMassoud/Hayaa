import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/badge_model.dart';
import 'badges_list_item.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({
    super.key,
  });

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  void SetBadge(String id)async{
    await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mybadges').doc(id).set({
      'id':id
    });
  }
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('sendgift').snapshots(),
        builder: (context,snapshot){
          List<String> MyBadesdocs=[];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            MyBadesdocs.add(massege.get('giftid'));
          }
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('badges').snapshots(),
            builder: (context,snapshot){
              List<BadgeModel> badges = [];

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                final bad= BadgeModel(badgeImage: massege.get('photo'), badgeName: massege.get('name'), count: massege.get('count'), gift: massege.get('gift'), Giftphoto:massege.get('giftphoto'));
                int c=0;
                for(int i=0;i<MyBadesdocs.length;i++){
                  if(MyBadesdocs[i]==massege.get('gift')){
                    c++;
                    bad.done=true;
                  }
                }
                if(c==int.parse(massege.get('count'))){
                  _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mybadges').doc(massege.id).set({
                    'id':massege.id
                  });
                }
                else{
                  bad.done=false;
                }
                badges.add(bad);
              }
              return Container(
                child: Column(children: [
                  Container(
                    width: screenWidth,
                    height: screenHight * 0.32,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap:(){
                            Allarm(badges[currentIndex]);
                    },
                          child: BadgeInfo(

                              bgImage: 'lib/core/Utils/assets/images/702.png',
                              screenWidth: screenWidth,
                              opacity: 1.0,
                              badgeModel: badges[currentIndex]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.brown.withOpacity(0.6),
                              border: Border.all(color: Colors.brown, width: 2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(
                                    badges.length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          print("hi");
                                          print(index);
                                          print(currentIndex);
                                          currentIndex = index;
                                          print(currentIndex);
                                        });
                                      },
                                      child: BadgesListItem(
                                          bgImage: "lib/core/Utils/assets/images/709.png",
                                          opacity: 0.75,
                                          screenWidth: screenWidth,
                                          badgeModel: badges[index]),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              );
            },
          );
        }
    );
  }
  void Allarm(BadgeModel badgeModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: badgeModel.done?Text("مبرك"):Text("معلومات الشارة"),
              content:badgeModel.done?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("تم الحصول هذه الشارة")
                ],
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  badgeModel.gift!=""?Text("تحتاج الي ارسال هذه الهدية ${badgeModel.count}"):
                  Text("${badgeModel.Giftphoto}${badgeModel.count}"),
                  SizedBox(height: 70,),
                  badgeModel.gift!=""?CachedNetworkImage(imageUrl: badgeModel.Giftphoto):Text("")
                ],
              )
          );
        });
  }
}
