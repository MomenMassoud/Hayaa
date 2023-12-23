import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_colors.dart';

class AgentRequest extends StatefulWidget {
  String id;
  AgentRequest(this.id);
  _AgentRequest createState() => _AgentRequest();
}

class _AgentRequest extends State<AgentRequest> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: screenHeight * 0.12,
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
        title: Text("طلبات الانضمام"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('agency').doc(widget.id).collection('req').snapshots(),
        builder: (context,snapshot){
          List<String> docs=[];
          List<String> names=[];
          List<String> photos=[];
          List<String> ids=[];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            docs.add(massege.id);
            names.add(massege.get('name'));
            photos.add(massege.get('photo'));
            ids.add(massege.get('doc'));
          }
          return docs.length>0?ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context,index){
              return ListTile(
                title: Text(names[index],style: TextStyle(fontSize: 20),),
                subtitle: Text("I Will Join!"),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(photos[index]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: ()async{
                        await _firestore.collection('user').doc(ids[index]).update({
                          'type':'host',
                          'myagent':widget.id
                        }).then((value){
                          _firestore.collection('agency').doc(widget.id).collection('users').doc(ids[index]).set({
                            'userid':ids[index],
                            'type':'host',
                            'time':DateTime.now().toString(),
                          }).then((value){
                            _firestore.collection('agency').doc(widget.id).collection('req').doc(docs[index]).delete();
                          });
                        });
                      }, child: Icon(Icons.done)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: ()async{
                        await _firestore.collection('agency').doc(widget.id).collection('req').doc(docs[index]).delete();
                      }, child: Icon(Icons.remove_circle_outline)),
                    )
                  ],
                ),
              );
            },
          ):Center(
            child: Text("لا يوجد طلبات انضمام",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
          );
        },
      ),
    );
  }
}
