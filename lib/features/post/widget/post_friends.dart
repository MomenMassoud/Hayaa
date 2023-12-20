import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/user_model.dart';

import '../../../models/comment_model.dart';
import '../../../models/love_model.dart';
import '../../../models/post_model.dart';

class PostFriends extends StatefulWidget{
  _PostFriends createState()=>_PostFriends();
}

class _PostFriends extends State<PostFriends>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('friends').snapshots(),
      builder: (context,snapshot){
        List<UserModel> users=[];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed){
          final us = UserModel("email", "name", "gender", "photo", massege.get('id'), "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
          users.add(us);
        }
        return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context,index) {
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('user').where('id',isEqualTo: users[index].id).snapshots(),
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
                    users[index].docID=massege.id;
                  }
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('post').where('owner_email',isEqualTo: users[index].docID).snapshots(),
                    builder: (context,snapshot){
                      List<PostModel> posts = [];
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed){
                        String ownername = massege.get('owner_name');
                        String owneremail = massege.get('owner_email');
                        String ownerphoto = massege.get('owner_photo');
                        String day = massege.get('day');
                        String month = massege.get('month');
                        String year = massege.get('year');
                        String text = massege.get('text');
                        String photo = massege.get('photo');
                        bool view = false;
                        if (owneremail != _auth.currentUser!.uid.toString()) {
                          view = true;
                        }
                        PostModel postModel = PostModel(owneremail, ownerphoto, text,
                            photo, day, month, year, view);
                        postModel.ownerName = ownername;
                        postModel.id = massege.id;
                        posts.add(postModel);
                      }
                      return Container(
                        height: 800,
                        child: ListView.builder(

                            itemCount: posts.length,
                            itemBuilder: (context,index){
                              return StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('post')
                                    .doc(posts[index].id)
                                    .collection('like')
                                    .snapshots(),
                                builder: (context,snapshot){
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                      ),
                                    );
                                  }
                                  final masseges = snapshot.data?.docs;
                                  int i = 0;
                                  for (var massege in masseges!.reversed){
                                    String email = massege.get('email');
                                    String photo = massege.get('photo');
                                    String name = massege.get('name');
                                    LoveModel love = LoveModel(email, name, photo);
                                    love.id = massege.id;
                                    if (_auth.currentUser!.uid == email) {
                                      posts[index].like = true;
                                      posts[index].indexLike = i;
                                    } else {
                                      posts[index].like = false;
                                    }
                                    posts[index].likes.add(love);
                                    i++;
                                  }
                                  return  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('post')
                                        .doc(posts[index].id)
                                        .collection('comment')
                                        .snapshots(),
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
                                        String email = massege.get('email');
                                        String photo = massege.get('photo');
                                        String name = massege.get('name');
                                        String comment = massege.get('comment');
                                        CommentModel love = CommentModel(
                                            email, name, photo, comment);
                                        love.id = massege.id;
                                        posts[index].comments.add(love);
                                      }
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
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (posts[index]
                                                                        .owner == _auth.currentUser!.uid) {
                                                                      // Navigator.pushNamed(
                                                                      //     context,
                                                                      //     AccountScreen
                                                                      //         .ScreenRoute);
                                                                    } else {
                                                                      // UserModel us = UserModel(
                                                                      //     posts[index]
                                                                      //         .owner,
                                                                      //     posts[index]
                                                                      //         .ownerName,
                                                                      //     "bio",
                                                                      //     "id",
                                                                      //     "gender",
                                                                      //     "devicetoken",
                                                                      //     posts[index]
                                                                      //         .Owner_photo,
                                                                      //     "seen");
                                                                      // Navigator.push(
                                                                      //     context,
                                                                      //     MaterialPageRoute(
                                                                      //         builder: (
                                                                      //             builder) =>
                                                                      //             ViewContactProfile(
                                                                      //                 us)));
                                                                    }
                                                                  },
                                                                  child: CircleAvatar(
                                                                    backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                        posts[index]
                                                                            .Owner_photo),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 20,),
                                                                Text(
                                                                  posts[index].ownerName,
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

                                                            InkWell(
                                                              child: CachedNetworkImage(
                                                                imageUrl: posts[index].Photo,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              onTap: (){
                                                                //Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewMedia(posts[index].Photo)));
                                                              },
                                                            ),
                                                            Container(height: 10),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(posts[index]
                                                                        .likes
                                                                        .length
                                                                        .toString()),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (posts[index]
                                                                            .like) {
                                                                          final docRef = _firestore
                                                                              .collection(
                                                                              'post')
                                                                              .doc(posts[
                                                                          index]
                                                                              .id);
                                                                          docRef
                                                                              .collection(
                                                                              "like")
                                                                              .doc(posts[
                                                                          index]
                                                                              .likes[posts[index]
                                                                              .indexLike]
                                                                              .id)
                                                                              .delete();
                                                                          setState(() {
                                                                            posts[index]
                                                                                .likes
                                                                                .elementAt(
                                                                                posts[index]
                                                                                    .indexLike);
                                                                          });
                                                                        } else {
                                                                          // final docRef =
                                                                          // _firestore
                                                                          //     .collection(
                                                                          //     'post');
                                                                          // docRef.doc(posts[index].id).collection('like').doc(source.id).set({
                                                                          //   'email': source
                                                                          //       .email,
                                                                          //   'photo': source
                                                                          //       .photo,
                                                                          //   'name': source
                                                                          //       .name,
                                                                          // });
                                                                        }
                                                                      },
                                                                      icon: posts[index]
                                                                          .like
                                                                          ? const Icon(Icons
                                                                          .favorite_outlined)
                                                                          : const Icon(Icons
                                                                          .favorite_outline_sharp),
                                                                      color: posts[index]
                                                                          .like
                                                                          ? Colors.red
                                                                          : Colors.grey,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(posts[index]
                                                                        .comments
                                                                        .length
                                                                        .toString()),
                                                                    IconButton(
                                                                      onPressed: () {
                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder: (builder) =>
                                                                        //             ViewComment(posts[index].id)));
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons.comment),
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                        ),
                      );
                    },
                  );
                },
              );
            }    
        );
      },
    );
    }
  }