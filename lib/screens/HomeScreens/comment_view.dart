import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Model/ChatModel.dart';
import '../../Model/comment_model.dart';


class CommentView extends StatefulWidget{
  List<CommentModel> comments;
  chatmodel user;
  String id;
  CommentView(this.user,this.comments,this.id);
  _CommentView createState()=>_CommentView();
}

class _CommentView extends State<CommentView>{
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.comments.length>0?ListView.builder(
          itemCount: widget.comments.length,
          reverse: true,
          itemBuilder: (context,index){
            if(widget.comments.length-1==index){
              return Column(
                children: [
                  ListTile(
                    title: Text(widget.comments[index].name),
                    subtitle: Text(widget.comments[index].comment),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(widget.comments[index].photo),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: _controller,
                        cursorColor: Colors.blue[900],
                        onChanged: (value) {

                        },
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
                                final docRef= _firestore.collection('post');
                                docRef.doc(widget.id).collection('comment').add({
                                  'email':widget.user.email,
                                  'photo':widget.user.photo,
                                  'name':widget.user.name,
                                  'comment':_controller.text
                                });
                                CommentModel cm=CommentModel(widget.user.email, widget.user.name, widget.user.photo, _controller.text);
                                widget.comments.add(cm);
                                _controller.clear();
                              },
                              icon: Icon(Icons.send),
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            else{
              return ListTile(
                title: Text(widget.comments[index].name),
                subtitle: Text(widget.comments[index].comment),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(widget.comments[index].photo),
                ),
              );
            }
          }
      ):
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextFormField(
            controller: _controller,
            cursorColor: Colors.blue[900],
            onChanged: (value) {

            },
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
                  final docRef= _firestore.collection('post');
                  docRef.doc(widget.id).collection('comment').add({
                    'email':widget.user.email,
                    'photo':widget.user.photo,
                    'name':widget.user.name,
                    'comment':_controller.text
                  });
                  CommentModel cm=CommentModel(widget.user.email, widget.user.name, widget.user.photo, _controller.text);
                  setState(() {
                    widget.comments.add(cm);
                  });
                  _controller.clear();
                },
                icon: Icon(Icons.send),
              )
            ),
          )
        ],
      ),
    );
  }

}