import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/friend_list/widget/friend_requset.dart';
import 'package:hayaa_main/features/hayaa_team/view/hayaa_team_view.dart';
import 'package:hayaa_main/features/search/view/search_view.dart';
import 'package:hayaa_main/models/firends_model.dart';
import 'package:hayaa_main/models/friends_card_model.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../models/user_model.dart';
import '../../chat/widget/one_to_one/chat_body.dart';
import '../../friend_list/widget/friend_list_body.dart';
import 'invite_body.dart';

class MessagesViewBody extends StatefulWidget {
  _MessagesViewBody createState()=>_MessagesViewBody();
}

class _MessagesViewBody extends State<MessagesViewBody>{
  UserModel userModel=UserModel("email", "name", "gende", "photo", "id", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  int count=0;
  int InviteCount=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInviteCount();
  }
  getInviteCount()async{
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).collection('invite').snapshots()){
      setState(() {
        InviteCount=snap.size;
      });
    }
  }
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
        title:GestureDetector(
          onTap: () {},
          child: SizedBox(
            child: Text(
              "الدردشة",
              style: TextStyle(fontFamily: "Hayah", fontSize: 22,color: Colors.white),
            ).tr(args: ['الدردشة']),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FriendListBody(userModel)));
              }, icon: const Icon(Icons.people_outlined,color: Colors.white,)),
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, SearchView.id);
              },
              icon: Icon(Icons.search,color: Colors.white,)),
          InviteCount==0?IconButton(
              onPressed: (){
                Navigator.pushNamed(context, InviteBody.id);
              },
              icon: Icon(Icons.mail,color: Colors.white,)
          ):Stack(
            children: [
              IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, InviteBody.id);
                  },
                  icon: Icon(Icons.mail,color: Colors.white,)
              ),
              CircleAvatar(
                radius: 5,
                backgroundColor: Colors.red,
                child: Text(InviteCount.toString()),
              )
            ],
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('user').where('doc',isEqualTo: _auth.currentUser!.uid).snapshots(),
        builder: (context,snapshot){
          String myID="";
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            myID=massege.get('id');
          }
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('friendreq').where('owner',isEqualTo: myID).snapshots(),
            builder: (context,snapshot){
              int friendreqCount=0;
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              friendreqCount=masseges!.length;
              for (var massege in masseges!.reversed){}
              return StreamBuilder<QuerySnapshot>(
                stream:_firestore.collection('contacts').where('owner',isEqualTo: _auth.currentUser!.uid).snapshots(),
                builder: (context,snapshot){
                  List<FriendsCardModel> friendIDs=[];
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final masseges = snapshot.data?.docs;
                  for (var massege in masseges!.reversed){
                    friendIDs.add(FriendsCardModel(massege.get('mycontact'), massege.get('type'), massege.get('time'), massege.get('lastmsg')));
                  }
                  return friendIDs.length>0?ListView.builder(
                      itemCount: friendIDs.length,
                      itemBuilder: (context,index){
                        return StreamBuilder<QuerySnapshot>(
                          stream: _firestore.collection('user').where('doc',isEqualTo: friendIDs[index].docID).snapshots(),
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
                              friendIDs[index].photo=massege.get('photo');
                              friendIDs[index].name=massege.get('name');
                            }
                            if(index==0){
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage("lib/core/Utils/assets/images/logo.png"),
                                    ),
                                    title: Text("فريق Hayaa"),
                                    subtitle: Text("اضغط لمعرفة اخر الاخبار"),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: (){
                                      Navigator.pushNamed(context, HayaaTeamView.id);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person_add_alt_1_sharp,color: Colors.blue,),
                                    title: Text("طلبات الصداقة"),
                                    subtitle: Text("اضغط لمعرفة من ارسل لك طلب صداقة"),
                                    trailing: friendreqCount==0? Icon(Icons.arrow_forward_ios_rounded):Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.red,
                                          child: Text(friendreqCount.toString()),
                                        ),
                                        Icon(Icons.arrow_forward_ios_rounded)
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.pushNamed(context, FriendReuest.id);
                                    },
                                  ),
                                  Divider(thickness: 0.4,),
                                  ListTile(
                                    title: Text(friendIDs[index].name),
                                    subtitle: Text(friendIDs[index].lastmsg),
                                    leading: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(friendIDs[index].photo),
                                    ),
                                    trailing: Text(friendIDs[index].time),
                                    onTap: (){
                                      FriendsModel ff= FriendsModel("email", "id", "docID", "photo", "name", "phonenumber", "gender");
                                      ff.photo=friendIDs[index].photo;
                                      ff.docID=friendIDs[index].docID;
                                      ff.name=friendIDs[index].name;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => ChatBody(ff)));
                                    },
                                  ),
                                ],
                              );
                            }
                            else{
                              return ListTile(
                                onTap: (){
                                  FriendsModel ff= FriendsModel("email", "id", "docID", "photo", "name", "phonenumber", "gender");
                                  ff.photo=friendIDs[index].photo;
                                  ff.docID=friendIDs[index].docID;
                                  ff.name=friendIDs[index].name;
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => ChatBody(ff)));
                                },
                                title: Text(friendIDs[index].name),
                                subtitle: Text(friendIDs[index].lastmsg),
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(friendIDs[index].photo),
                                ),
                                trailing: Text(friendIDs[index].time),
                              );
                            }
                          },
                        );
                      }
                  ):Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("lib/core/Utils/assets/images/logo.png"),
                        ),
                        title: Text("فريق Hayaa"),
                        subtitle: Text("اضغط لمعرفة اخر الاخبار"),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        onTap: (){
                          Navigator.pushNamed(context, HayaaTeamView.id);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add_alt_1_sharp,color: Colors.blue,),
                        title: Text("طلبات الصداقة"),
                        subtitle: Text("اضغط لمعرفة من ارسل لك طلب صداقة"),
                        trailing:friendreqCount==0? Icon(Icons.arrow_forward_ios_rounded):Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.red,
                              child: Text(friendreqCount.toString()),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, FriendReuest.id);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      )
    );
  }
}
