import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/chat/widget/group/top_card.dart';
import 'package:hayaa_main/models/family_model.dart';
import '../../../../../core/Utils/app_images.dart';
import '../../../model/group_rand_card.dart';
import '../other_card.dart';


class FamilyNewsBody extends StatefulWidget{
  _FamilyNewsBody createState()=>_FamilyNewsBody();
}

class _FamilyNewsBody extends State<FamilyNewsBody> {
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.brown,
            Colors.blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('user').where('doc',isEqualTo:_auth.currentUser!.uid ).snapshots(),
          builder: (context,snapshot){
            String myfamily="";
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed){
              myfamily=massege.get('myfamily');
            }
            return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('family').snapshots(),
              builder: (context,snapshot){
                List<FamilyModel> familys=[];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed){
                  familys.add(
                      FamilyModel(massege.get('name'), massege.get('idd'), massege.get('id'), massege.get('bio'), massege.get('join'), massege.get('photo'))
                  );
                }
                return ListView.builder(
                  itemCount: familys.length,
                  itemBuilder: (context,index){
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('family').doc(familys[index].doc).collection('count').snapshots(),
                      builder: (context,snapshot){
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                        final masseges = snapshot.data?.docs;
                        for (var massege in masseges!.reversed){
                          familys[index].count+=int.parse(massege.get('coin'));
                        }
                        if(familys[index].doc==myfamily){
                          familys[index].name="${familys[index].name} (your Family)";
                        }
                        if(index==familys.length-1){
                          familys.sort((a, b) => b.count.compareTo(a.count));
                          return Container(
                            height: 600,
                            child: ListView.builder(
                              itemCount: familys.length,
                              itemBuilder: (context,ind){
                                if(ind==0){
                                  return Container();
                                }
                                else if(ind==1){
                                  return Container();
                                }
                                else if(ind==2){
                                  List<GroupRandCard> cards = [
                                    GroupRandCard(
                                        cardImge: AppImages.img3,
                                        rating: 'Top 3',
                                        strokColor: Colors.purpleAccent,
                                        userImge: familys[2].photo,
                                        userName: familys[2].name),
                                    GroupRandCard(
                                        cardImge: AppImages.img1,
                                        rating: 'Top 2',
                                        strokColor: Colors.brown.withOpacity(0.5),
                                        userImge: familys[1].photo,
                                        userName: familys[1].name),
                                    GroupRandCard(
                                        ratingColor: Colors.cyan,
                                        cardImge: AppImages.img2,
                                        rating: 'Top 1',
                                        strokColor: Colors.amber,
                                        userImge: familys[0].photo,
                                        userName: familys[0].name)
                                  ];
                                  List<String> coin = [];
                                  if (familys[2].count < 1000) {
                                    coin.add(familys[2].count.toString());
                                  } else if (familys[2].count >= 10000 &&
                                      familys[index].count < 1000000) {
                                    coin.add(
                                        "${(familys[2].count / 1000).toString()} K");
                                    print(coin);
                                  } else {
                                    coin.add(
                                        "${(familys[2].count / 1000000).toString()} K");
                                  }
                                  print("");
                                  if (familys[1].count < 1000) {
                                    coin.add(familys[1].count.toString());
                                  } else if (familys[1].count >= 10000 &&
                                      familys[index].count < 1000000) {
                                    coin.add(
                                        "${(familys[1].count / 1000).toString()} K");
                                    print(coin);
                                  } else {
                                    coin.add(
                                        "${(familys[1].count / 1000000).toString()} K");
                                  }
                                  print("");
                                  if (familys[0].count < 1000) {
                                    coin.add(familys[0].count.toString());
                                  } else if (familys[0].count >= 10000 &&
                                      familys[index].count < 1000000) {
                                    coin.add(
                                        "${(familys[0].count / 1000).toString()} K");
                                    print(coin);
                                  } else {
                                    coin.add(
                                        "${(familys[0].count / 1000000).toString()} K");
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TopCard(
                                          screenHeight: screenHeight,
                                          screenWidth: screenWidth,
                                          cardModel: cards[1],
                                          coin: coin[1],
                                          coinPic: true,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 100),
                                          child: TopCard(
                                            screenHeight: screenHeight,
                                            screenWidth: screenWidth,
                                            cardModel: cards[2],
                                            coin: coin[2],
                                            coinPic: true,
                                          ),
                                        ),
                                        TopCard(
                                          screenHeight: screenHeight,
                                          screenWidth: screenWidth,
                                          cardModel: cards[0],
                                          coin: coin[0],
                                          coinPic: true,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return OtherCard(familys[ind].name, "${ind+1}", familys[ind].bio, familys[ind].count.toString(),familys[ind].photo);
                                }

                              },
                            ),
                          );
                        }
                        else{
                          return Container();
                        }
                      },
                    );
                  },
                );
              },
            );
          }
      ),
    );
  }
}