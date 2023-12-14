import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/chat/one_to_one/view/chat_view.dart';
import 'package:hayaa_main/features/chat/widget/one_to_one/chat_body.dart';
import 'package:hayaa_main/features/profile/widgets/visitor_profile.dart';
import 'package:hayaa_main/models/firends_model.dart';
import '../../../models/user_model.dart';

class FriendsBody extends StatefulWidget {
  _FriendsBody createState() => _FriendsBody();
}

class _FriendsBody extends State<FriendsBody> {
  UserModel userModel = UserModel(
      "email",
      "name",
      "gende",
      "photo",
      "id",
      "phonenumber",
      "devicetoken",
      "daimond",
      "vip",
      "bio",
      "seen",
      "lang",
      "country",
      "type",
      "birthdate",
      "coin",
      "exp",
      "level");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: _auth.currentUser!.email == null
          ? _firestore
              .collection('user')
              .where('email', isEqualTo: _auth.currentUser!.phoneNumber)
              .snapshots()
          : _firestore
              .collection('user')
              .where('email', isEqualTo: _auth.currentUser!.email)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final masseges = snapshot.data?.docs;
        for (var massege in masseges!.reversed) {
          userModel.bio = massege.get('bio');
          userModel.birthdate = massege.get('birthdate');
          userModel.coin = massege.get('coin');
          userModel.country = massege.get('country');
          userModel.daimond = massege.get('daimond');
          userModel.coin = massege.get('coin');
          userModel.devicetoken = massege.get('devicetoken');
          userModel.email = massege.get('email');
          userModel.exp = massege.get('exp');
          userModel.gender = massege.get('gender');
          userModel.id = massege.get('id');
          userModel.lang = massege.get('lang');
          userModel.level = massege.get('level');
          userModel.name = massege.get('name');
          userModel.phonenumber = massege.get('phonenumber');
          userModel.photo = massege.get('photo');
          userModel.seen = massege.get('seen');
          userModel.type = massege.get('type');
          userModel.vip = massege.get('vip');
          userModel.docID = massege.id;
        }
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('user')
              .doc(userModel.docID)
              .collection('friends')
              .snapshots(),
          builder: (context, snapshot) {
            List<String> FriendID = [];
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final masseges = snapshot.data?.docs;
            for (var massege in masseges!.reversed) {
              FriendID.add(massege.get('id'));
            }
            return ListView.builder(
                itemCount: FriendID.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('user')
                        .where('id', isEqualTo: FriendID[index])
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<FriendsModel> friendsModels = [];
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed) {
                        FriendsModel ff = FriendsModel(
                            massege.get('email'),
                            massege.get('id'),
                            massege.id,
                            massege.get('photo'),
                            massege.get('name'),
                            massege.get('phonenumber'),
                            massege.get('gender'));
                        ff.bio = massege.get('bio');
                        friendsModels.add(ff);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(friendsModels[index].name),
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                friendsModels[index].photo),
                          ),
                          subtitle: Text(friendsModels[index].bio),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                  onPressed: ()  {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ChatBody(friendsModels[index])));
                                  },
                                  child: Text("دردشة")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => VisitorProfile(friendsModels[index])));
                                  }, child: Text("الحساب"))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
          },
        );
      },
    ));
  }
}
