import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/comment_model.dart';


class ViewComment extends StatefulWidget{
  String postID;
  ViewComment(this.postID);
  _ViewComment createState()=>_ViewComment();
}


class _ViewComment extends State<ViewComment>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //UserModel user=UserModel("email", "name", "bio", "id", "gender", "devicetoken", "photo", "seen");
  TextEditingController _controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('post').doc(widget.postID).collection('comment').snapshots(),
          builder: (context, snapshot) {
            List<CommentModel> comments=[];
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              String email = massege.get('email');
              String photo = massege.get('photo');
              String name = massege.get('name');
              String comment = massege.get('comment');
              CommentModel love = CommentModel(
                  email, name, photo, comment);
              love.id = massege.id;
              comments.add(love);
            }
            return comments.length>0?ListView.builder(
                itemCount: comments.length,
                reverse: true,
                itemBuilder: (context,index){
                  if(index==0){
                    return Column(
                      children: [
                        ListTile(
                          title: Text(comments[index].name),
                          subtitle: Text(comments[index].comment),
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundImage: CachedNetworkImageProvider(comments[index].photo),
                          ),
                        ),
                        TextFormField(
                          controller: _controller,
                          cursorColor: Colors.blue[900],
                          onChanged: (value) {

                          },
                          style: TextStyle(
                            color:  Colors.black,
                          ),
                          decoration: InputDecoration(
                              hintText: "قم بكتباة التعليق",
                              filled: true,
                              fillColor: Colors.grey[100], // Change the background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                onPressed: ()async{
                                  try{
                                    await _firestore.collection('post').doc(widget.postID).collection('comment').doc().set({
                                      'email':_auth.currentUser!.email,
                                      'photo':_auth.currentUser!.photoURL.toString(),
                                      'name':_auth.currentUser!.displayName,
                                      'comment':_controller.value.text
                                    }).then((value){
                                      setState(() {
                                        _controller.clear();
                                      });
                                    });
                                  }
                                  catch(e){
                                    print(e);
                                  }
                                },
                                icon: Icon(Icons.send),
                              )
                          ),
                        ),

                      ],
                    );
                  }
                  else{
                    return  ListTile(
                      title: Text(comments[index].name),
                      subtitle: Text(comments[index].comment),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundImage: CachedNetworkImageProvider(comments[index].photo),
                      ),
                    );
                  }
                }
            ):Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _controller,
                  cursorColor: Colors.blue[900],
                  onChanged: (value) {

                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: "قم بكتباة التعليق",
                      fillColor: Colors.black, // Change the background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: ()async{
                          try{
                            await _firestore.collection('post').doc(widget.postID).collection('comment').doc().set({
                              'email':_auth.currentUser!.email,
                              'photo':_auth.currentUser!.photoURL.toString(),
                              'name':_auth.currentUser!.displayName,
                              'comment':_controller.value.text
                            }).then((value){
                              setState(() {
                                _controller.clear();
                              });
                            });
                          }
                          catch(e){
                            print(e);
                          }
                        },
                        icon: Icon(Icons.send),
                      )
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}