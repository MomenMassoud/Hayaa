import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/chat/widget/common/view_photo.dart';
import 'package:hayaa_main/features/post/widget/view_coment_body.dart';
import 'package:hayaa_main/features/profile/views/visitor_.view.dart';
import 'package:hayaa_main/models/post_model.dart';

class PostCard extends StatefulWidget{
  PostModel post;
  int commentCounter;
  int likeCounter;
  PostCard(this.post,this.commentCounter,this.likeCounter);
  _PostCard createState()=>_PostCard();
}

class _PostCard extends State<PostCard>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VistorView(widget.post.Owner_photo,widget.post.owner)));
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.post.Owner_photo),
                  radius: 20,
                ),
                SizedBox(width: 10,),
                Text(widget.post.ownerName,style: TextStyle(fontSize: 18),),
                SizedBox(width: 100,),
                Text("${widget.post.Day}/${widget.post.Month}/${widget.post.Year}")
              ],
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text(widget.post.Text,style: TextStyle(fontSize: 20,color: Colors.black),),
            ],
          ),
          SizedBox(height: 8,),
          widget.post.Photo=="none"?Container():InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ViewPhoto(widget.post.Photo)));
            },
            child: Container(
              height: 130,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(12),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.post.Photo,
                    ),
                    fit: BoxFit.cover
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(widget.likeCounter.toString()),
              IconButton(onPressed: (){
                AddLike();
              }, icon: Icon(
                Icons.recommend,
                color:widget.post.like?Colors.red: Colors.grey,)),
              IconButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            ViewComment(widget.post.id)));
              }, icon: Icon(Icons.comment_rounded,color: Colors.grey,)),
              Text(widget.commentCounter.toString()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(thickness: 0.4,),
          ),
        ],
      ),
    );
  }
  void AddLike()async{
    if(widget.post.like==true){
      await _firestore.collection('post').doc(widget.post.id).collection('like').doc(_auth.currentUser!.uid).delete();
      print("delete");
      setState(() {
        widget.post.like=false;
      });
    }
    else{
      await _firestore.collection('post').doc(widget.post.id).collection('like').doc(_auth.currentUser!.uid).set({
        'email':_auth.currentUser!.email,
        'name':_auth.currentUser!.displayName,
        'photo':_auth.currentUser!.photoURL.toString(),
      });
      setState(() {
        widget.post.like=true;
      });
      print("add");
    }
  }
}