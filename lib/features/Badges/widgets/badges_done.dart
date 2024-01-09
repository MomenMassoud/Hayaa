import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/badge_model.dart';
import 'badges_list_item.dart';


class BadgesDone extends StatefulWidget{
  _BadgesDone createState()=>_BadgesDone();
}

class _BadgesDone extends State<BadgesDone>{
  int currentIndex = 0;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckNewBadge();
  }
  void CheckNewBadge()async{
    await for(var snap in _firestore.collection('badges').snapshots()){
      print("Start");
      for(int i=0;i<snap.docs.length;i++){
        String badgegiftphoto=snap.docs[i].get('giftphoto');
        int count=int.parse(snap.docs[i].get('count'));
        String badgegift=snap.docs[i].get('gift');
        String badgedoc=snap.docs[i].id;
        if(badgegift=="") {
          if (badgegiftphoto == "receve daimond") {
            getBadgeDaiomond(badgedoc, count);
          }
          else {
            getBadgeCoin(badgedoc, count);
          }
        }
        else{
          getBadgeGift(badgedoc, count,badgegift);
        }
      }
    }
  }
  void getBadgeDaiomond(String badgedoc ,int target)async{
    int c=0;
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).collection('Mygifts').snapshots()){
      for(int i=0;i<snap.docs.length;i++){
        await for(var snap2 in _firestore.collection('gifts').doc(snap.docs[i].get('id')).snapshots()){
          c+=int.parse(snap2.get('price'));
          if(c>=target){
            _firestore.collection("user").doc(_auth.currentUser!.uid).collection("mybadges").doc(badgedoc).set({
              'id':badgedoc,
            });
          }
        }
      }
    }
  }
  void getBadgeCoin(String badgedoc,int target)async{
    int c=0;
    await for(var snap in  _firestore.collection('user').doc(_auth.currentUser!.uid).collection('sendgift').snapshots()){
      for(int i=0;i<snap.docs.length;i++){
        String giftid=snap.docs[i].get('giftid');
        await for(var snap2 in _firestore.collection('gifts').doc(giftid).snapshots()){
          c+=int.parse(snap2.get('price'));
          if(c>=target){
            _firestore.collection("user").doc(_auth.currentUser!.uid).collection("mybadges").doc(badgedoc).set({
              'id':badgedoc,
            });
          }
        }
      }
    }
  }
  void getBadgeGift(String badgedoc,int target,String giftgoc)async{
    int c=0;
    await for(var snap in  _firestore.collection('user').doc(_auth.currentUser!.uid).collection('sendgift').snapshots()){
      for(int i=0;i<snap.docs.length;i++){
        String giftid=snap.docs[i].get('giftid');
        if(giftid==giftgoc){
          c++;
          if(c>=target){
            _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mybadges').doc(badgedoc).set({
              'id':badgedoc
            });
          }
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mybadges').snapshots(),
      builder: (context,snapshot){
        List<String> badgesdoc=[];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed){
          badgesdoc.add(massege.get('id'));
          print(massege.get('id'));
        }
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('badges').snapshots(),
          builder: (context,snapshot){
            List<BadgeModel> mybadges=[];
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed){
              if(badgesdoc.contains(massege.id)){
                print("yes");
                mybadges.add(
                    BadgeModel(badgeImage: massege.get('photo'),
                        badgeName: massege.get('name'), count: massege.get('count'),
                        gift: massege.get('gift'), Giftphoto: massege.get('giftphoto'))
                );
              }
            }
            return Container(
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHight * 0.32,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BadgeInfo(
                            bgImage: 'lib/core/Utils/assets/images/702.png',
                            screenWidth: screenWidth,
                            opacity: 1.0,
                            badgeModel: mybadges[currentIndex]),
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
                                    mybadges.length, (index) {
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
                                          badgeModel: mybadges[index]),
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
                ],
              ),
            );
          },
        );
      },
    );
  }
}