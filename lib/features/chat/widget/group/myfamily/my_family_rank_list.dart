import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/family_model.dart';
import '../../../../../core/Utils/app_images.dart';
import '../../../model/group_rand_card.dart';
import '../top_card.dart';


class MyFamilyRankList extends StatefulWidget{
  String id;
  MyFamilyRankList(this.id);
  _MyFamilyRankList createState()=>_MyFamilyRankList();
}

class _MyFamilyRankList extends State<MyFamilyRankList>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.family))
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text("ترتيب العائلات",style: TextStyle(fontSize: 20,color: Colors.white),),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('family').snapshots(),
            builder: (context,snapshot){
              List<FamilyModel> familys=[];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                familys.add(
                    FamilyModel(
                        massege.get('name'),
                        massege.get('idd'),
                        massege.get('id'),
                        massege.get('bio'),
                        massege.get('join'),
                        massege.get('photo'))
                );
              }
              return ListView.builder(
                itemCount: familys.length,
                itemBuilder: (context,index){
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('family').doc(familys[index].doc).collection('count').snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed){
                        familys[index].count+=int.parse(massege.get('coin'));
                      }
                      if(index==familys.length-1){
                        familys.sort((a, b) => b.count.compareTo(a.count));
                        return Container(
                          height: 400,
                          child: ListView.builder(
                              itemCount: familys.length,
                              itemBuilder: (context,ind){
                                if(familys.length<4){
                                  if(familys.length==1){
                                    String coin="";
                                   final card= GroupRandCard(
                                        ratingColor: Colors.cyan,
                                        cardImge: AppImages.img2,
                                        rating: 'Top 1',
                                        strokColor: Colors.amber,
                                        userImge: familys[0].photo,
                                        userName:familys[0].name);
                                    if(familys[0].count<1000){
                                      coin=familys[0].count.toString();
                                    }
                                    else if(familys[0].count>=10000 && familys[0].count<1000000){
                                      coin="${(familys[0].count /1000).toString()} K";
                                      print(coin);
                                    }
                                    else{
                                      coin="${(familys[0].count/1000000).toString()} K";
                                    }
                                    return TopCard(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        cardModel: card,coin: coin,coinPic: true);
                                  }
                                  else if(familys.length==2){
                                    List<GroupRandCard> cards = [
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
                                          userName:familys[0].name)
                                    ];
                                    List<String> coin=[];
                                    if(familys[0].count<1000){
                                      coin.add(familys[0].count.toString());
                                    }
                                    else if(familys[0].count>=10000 && familys[0].count<1000000){
                                      coin.add("${(familys[0].count /1000).toString()} K");
                                      print(coin);
                                    }
                                    else{
                                      coin.add("${(familys[0].count/1000000).toString()} K");
                                    }
                                    print("");
                                    if(familys[0].count<1000){
                                      coin.add(familys[0].count.toString());
                                    }
                                    else if(familys[0].count>=10000 && familys[0].count<1000000){
                                      coin.add("${(familys[0].count /1000).toString()} K");
                                      print(coin);
                                    }
                                    else{
                                      coin.add("${(familys[0].count/1000000).toString()} K");
                                    }
                                    if(ind==0){
                                      return Container();
                                    }
                                    else{
                                      return Padding(
                                        padding:  EdgeInsets.only(top: 60),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center, children: [
                                          TopCard(
                                              screenHeight: screenHeight,
                                              screenWidth: screenWidth,
                                              cardModel: cards[1],coin:coin[1],coinPic: true),
                                          TopCard(
                                              screenHeight: screenHeight,
                                              screenWidth: screenWidth,
                                              cardModel: cards[0],coin: coin[0],coinPic: true),
                                        ],
                                        ),
                                      );
                                    }
                                  }
                                  else{

                                  }
                                }
                                else{

                                }
                              }
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
          ),
        )
    );
  }

}