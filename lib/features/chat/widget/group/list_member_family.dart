import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/Utils/app_images.dart';
import '../../../../models/user_model.dart';

class ListMemberFamily extends StatefulWidget{
  String familyID;
  ListMemberFamily(this.familyID);
  _ListMemberFamily createState()=>_ListMemberFamily();
}

class _ListMemberFamily extends State<ListMemberFamily>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String _mytype="";
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.family))
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Family Members",style: TextStyle(color: Colors.white),),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('family').doc(widget.familyID).collection('user').snapshots(),
            builder: (context,snapshot){
              List<UserModel> users=[];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                UserModel us=UserModel("email", "name", "gender", "photo", "massege.id", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
                us.docID=massege.get('user');
                us.familytype=massege.get('type');
                users.add(us);
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context,index){
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('user').where('doc',isEqualTo: users[index].docID).snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      int myidex=0;
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed){
                        users[index].bio=massege.get('bio');
                        users[index].birthdate=massege.get('birthdate');
                        users[index].coin=massege.get('coin');
                        users[index].country=massege.get('country');
                        users[index].daimond=massege.get('daimond');
                        users[index].coin=massege.get('coin');
                        users[index].devicetoken=massege.get('devicetoken');
                        users[index].email=massege.get('email');
                        users[index].exp=massege.get('exp');
                        users[index].gender=massege.get('gender');
                        users[index].id=massege.get('id');
                        users[index].lang=massege.get('lang');
                        users[index].level=massege.get('level');
                        users[index].name=massege.get('name');
                        users[index].phonenumber=massege.get('phonenumber');
                        users[index].photo=massege.get('photo');
                        users[index].seen=massege.get('seen');
                        users[index].type=massege.get('type');
                        users[index].vip=massege.get('vip');
                        users[index].docID=massege.id;
                        users[index].myfamily=massege.get('myfamily');
                        if(users[index].docID==_auth.currentUser!.uid){
                          users[index].name="${users[index].name} (you)";
                          myidex=index;
                          _mytype=users[index].familytype;
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            users[index].docID==_auth.currentUser!.uid?ListTile(
                              title: Text("${users[index].name} - ${users[index].familytype}",style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(users[index].photo),
                              ),
                              subtitle: Text("BIO: ${users[index].bio}  - ID: ${users[index].id}",style: TextStyle(color: Colors.white),),
                            ):
                            _mytype=="normal"?ListTile(
                              title: Text("${users[index].name} - ${users[index].familytype}",style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(users[index].photo),
                              ),
                              subtitle: Text("BIO: ${users[index].bio}  - ID: ${users[index].id}",style: TextStyle(color: Colors.white),),
                            ): _mytype=="owner"?ListTile(
                              title: Text("${users[index].name} - ${users[index].familytype}",style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(users[index].photo),
                              ),
                              subtitle: Text("BIO: ${users[index].bio}  - ID: ${users[index].id}",style: TextStyle(color: Colors.white),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(onPressed: (){}, child: Text("تغير الرتبة")),
                                  ElevatedButton(onPressed: (){}, child: Text("طرد"))
                                ],
                              ),
                            ):_mytype=="admin" && users[index].familytype=="owner"?ListTile(
                              title: Text("${users[index].name} - ${users[index].familytype}",style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(users[index].photo),
                              ),
                              subtitle: Text("BIO: ${users[index].bio}  - ID: ${users[index].id}",style: TextStyle(color: Colors.white),),
                            ):ListTile(
                              title: Text("${users[index].name} - ${users[index].familytype}",style: TextStyle(color: Colors.white),),
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(users[index].photo),
                              ),
                              subtitle: Text("BIO: ${users[index].bio}  - ID: ${users[index].id}",style: TextStyle(color: Colors.white),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(onPressed: (){}, child: Text("تغير الرتبة")),
                                  ElevatedButton(onPressed: (){}, child: Text("طرد"))
                                ],
                              ),
                            ),
                            Divider(thickness: 0.5,)
                          ],
                        ),
                      );
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