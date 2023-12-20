import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/models/invite_model.dart';
import '../../../core/Utils/app_colors.dart';


class InviteBody extends StatefulWidget{
    static const id="InviteBody";
  _InviteBody createState()=>_InviteBody();
}

class _InviteBody extends State<InviteBody>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        title: Text('قائمة الدعاوي'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('invite').snapshots(),
        builder: (context,snapshot){
          List<InviteModel> invites=[];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            invites.add(
              InviteModel(massege.id, massege.get('agent'), massege.get('msg'), massege.get('type'), massege.get('time'), massege.get('sender'), massege.get('senderName'), massege.get('senderPhoto'))
            );
          }
          return invites.length>0?ListView.builder(
            itemCount: invites.length,
            itemBuilder: (context,index){
              return Column(
                children: [
                  ListTile(
                    title: Text(invites[index].sendername,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    subtitle: Text(invites[index].msg),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(invites[index].senderphoto),
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: ()async{
                            await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('invite').doc(invites[index].doc).delete();
                          }, child: Icon(Icons.do_not_disturb_on_outlined)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: ()async{
                            await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                              'myagent':invites[index].agent,
                              'type':'host'
                            }).then((value){
                              _firestore.collection('agency').doc(invites[index].agent).collection('users').doc().set({
                                'userid':_auth.currentUser!.uid.toString(),
                                'type':'host',
                                'time':DateTime.now().toString(),
                              }).then((value){
                                _firestore.collection('user').doc(_auth.currentUser!.uid).collection('invite').doc(invites[index].doc).delete();
                              });
                            });
                          }, child: Icon(Icons.done)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Divider(thickness: 0.2,),
                  )
                ],
              );
            },
          ):Center(
            child: Text("لا توجد دعوات",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
          );
        },
      ),
    );
  }

}