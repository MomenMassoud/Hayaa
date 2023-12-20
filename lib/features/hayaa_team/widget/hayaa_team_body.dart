import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';

import '../../../core/Utils/app_colors.dart';
import '../../../models/post_model.dart';

class HayaaTeamBody extends StatefulWidget{
  _HayaaTeamBody createState()=>_HayaaTeamBody();
}

class _HayaaTeamBody extends State<HayaaTeamBody>{
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("فريق Hayaa"),
        flexibleSpace: Container(
          height: screenHight * 0.12,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('hayaa').snapshots(),
        builder: (context,snapshot){
          List<PostModel> posts = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            String ownername=massege.get('owner_name');
            String owneremail=massege.get('owner_email');
            String ownerphoto=massege.get('owner_photo');
            String day=massege.get('day');
            String month=massege.get('month');
            String year=massege.get('year');
            String text=massege.get('text');
            String photo=massege.get('photo');
            PostModel postModel = PostModel(owneremail, ownerphoto, text, photo, day, month, year,true);
            postModel.ownerName=ownername;
            postModel.id=massege.id;
            posts.add(postModel);
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: ListView.builder(
              reverse: true,
              itemCount: posts.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(top: 18.0,right: 20,left: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 20,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(height: 5),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                            AssetImage(AppImages.appPLogo)
                                          ),
                                          SizedBox(width: 20,),
                                          Text(
                                            "Hayaa Team",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(
                                            "${posts[index].Day}/${posts[index].Month}/${posts[index].Year}",style: TextStyle(fontSize: 16),
                                          ),

                                        ],
                                      ),
                                      Container(height: 5),
                                      Text(
                                        posts[index].Text,style: TextStyle(fontSize: 16),
                                      ),
                                      Container(height: 5),

                                      CachedNetworkImage(
                                        imageUrl: posts[index].Photo,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(height: 10),

                                    ],
                                  )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

}