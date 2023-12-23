import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/post/widget/post_card.dart';
import '../../../models/comment_model.dart';
import '../../../models/love_model.dart';
import '../../../models/post_model.dart';
import 'view_coment_body.dart';

class PostPopular extends StatefulWidget{
  _PostPopular createState()=>_PostPopular();
}

class _PostPopular extends State<PostPopular>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('post').snapshots(),
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
        return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context,index){
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('post')
                    .doc(posts[index].id)
                    .collection('like')
                    .snapshots(),
                builder: (context,snapshot){
                  int likeCounter=0;
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final masseges = snapshot.data?.docs;
                  likeCounter=masseges!.length;
                  int i = 0;
                  for (var massege in masseges!.reversed){
                    String email = massege.get('email');
                    String photo = massege.get('photo');
                    String name = massege.get('name');
                    LoveModel love = LoveModel(email, name, photo);
                    love.id = massege.id;
                    if (_auth.currentUser!.uid == love.id) {
                      posts[index].like = true;
                      posts[index].indexLike = i;
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
                      int commentsCounter=0;
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      commentsCounter=masseges!.length;
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
                      return PostCard(posts[index], commentsCounter, likeCounter);
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