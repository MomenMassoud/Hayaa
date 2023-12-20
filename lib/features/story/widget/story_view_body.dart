import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/story/widget/view_story_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/story_model.dart';
import '../../../models/user_model.dart';
import 'add_story.dart';

class StoryViewBody extends StatefulWidget{
  _StoryViewBody createState()=>_StoryViewBody();
}

class _StoryViewBody extends State<StoryViewBody>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage=FirebaseStorage.instance;
  final ImagePicker picker=ImagePicker();
  XFile? image;
  DateTime now=DateTime.now();
  UserModel us=UserModel("email", "name", "gender", "photo", "id", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyData();
  }
  void getMyData()async{
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).snapshots()){
      us.bio=snap.get('bio');
      us.birthdate=snap.get('birthdate');
      us.coin=snap.get('coin');
      us.country=snap.get('country');
      us.daimond=snap.get('daimond');
      us.coin=snap.get('coin');
      us.devicetoken=snap.get('devicetoken');
      us.email=snap.get('email');
      us.exp=snap.get('exp');
      us.gender=snap.get('gender');
      us.id=snap.get('id');
      us.lang=snap.get('lang');
      us.level=snap.get('level');
      us.name=snap.get('name');
      us.phonenumber=snap.get('phonenumber');
      us.photo=snap.get('photo');
      us.seen=snap.get('seen');
      us.type=snap.get('type');
      us.vip=snap.get('vip');
      us.docID=snap.id;
      us.myfamily=snap.get('myfamily');
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('storys').where('owner',isEqualTo: _auth.currentUser!.uid).snapshots(),
      builder: (context,snapshot){
        List<StoryModel> MystoryWedgites=[];
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final MYstorysStream = snapshot.data?.docs;
        for(var mystory in MYstorysStream!){
          var storyid= mystory.id;
          var storyMedia = mystory.get('Media');
          var storyday = mystory.get('day');
          var storymonth = mystory.get('month');
          var storyowner = mystory.get('owner');
          var storyownerName = mystory.get('ownerName');
          var storytext = mystory.get('text');
          var storytime = mystory.get('time');
          var storytype = mystory.get('type');
          var storyyear = mystory.get('year');
          if(storyyear==now.year.toString()){
            int dd = int.parse(storyday);
            int mm = int.parse(storymonth);
            int hh = int.parse(storytime);
            if(mm==now.month){
              if(dd==now.day){
                StoryModel ss = StoryModel(storyowner, storyownerName, storyMedia, storytext, storyyear, storymonth, storyday, storytime, storytype);
                ss.id=storyid;
                MystoryWedgites.add(ss);
              }
              else{
                if(hh<=now.hour){
                  StoryModel ss = StoryModel(storyowner, storyownerName, storyMedia, storytext, storyyear, storymonth, storyday, storytime, storytype);
                  ss.id=storyid;
                  MystoryWedgites.add(ss);
                }
                else{
                  if(storytype=="photo" || storytype=="vedio"){
                    firebaseStorage.refFromURL(storyMedia).delete();
                  }
                  _firestore.collection("storys").doc(storyid).delete().then(
                        (doc) => {},
                    onError: (e) => {},
                  );
                }
              }
            }
            else{
              if(storytype=="photo" || storytype=="vedio"){
                firebaseStorage.refFromURL(storyMedia).delete();
              }
              _firestore.collection("storys").doc(storyid).delete().then(
                    (doc) => {},
                onError: (e) => {},
              );
            }
          }
        }
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('friends').snapshots(),
          builder: (context,snapshot){
            List<UserModel> myfriends=[];
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            final MyFriendsData = snapshot.data?.docs;
            for(var mystory in MyFriendsData!){
              final uss = UserModel("email", "", "gender","", "", "phonenumber", "devicetoken", "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate", "coin", "exp", "level");
              uss.id=mystory.id;
              myfriends.add(uss);
            }
            return myfriends.length>0?ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: myfriends.length,
              itemBuilder: (context,index){
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('user').where('id',isEqualTo: myfriends[index].id).snapshots(),
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
                      myfriends[index].bio=massege.get('bio');
                      myfriends[index].birthdate=massege.get('birthdate');
                      myfriends[index].coin=massege.get('coin');
                      myfriends[index].country=massege.get('country');
                      myfriends[index].daimond=massege.get('daimond');
                      myfriends[index].coin=massege.get('coin');
                      myfriends[index].devicetoken=massege.get('devicetoken');
                      myfriends[index].email=massege.get('email');
                      myfriends[index].exp=massege.get('exp');
                      myfriends[index].gender=massege.get('gender');
                      myfriends[index].id=massege.get('id');
                      myfriends[index].lang=massege.get('lang');
                      myfriends[index].level=massege.get('level');
                      myfriends[index].name=massege.get('name');
                      myfriends[index].phonenumber=massege.get('phonenumber');
                      myfriends[index].photo=massege.get('photo');
                      myfriends[index].seen=massege.get('seen');
                      myfriends[index].type=massege.get('type');
                      myfriends[index].vip=massege.get('vip');
                      myfriends[index].docID=massege.id;
                      myfriends[index].myfamily=massege.get('myfamily');
                    }
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('storys').where('owner',isEqualTo:myfriends[index].docID).snapshots(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData){
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                        final masseges = snapshot.data?.docs;
                        for (var massege in masseges!.reversed){
                          var storyid= massege.id;
                          var storyMedia = massege.get('Media');
                          var storyday = massege.get('day');
                          var storymonth = massege.get('month');
                          var storyowner = massege.get('owner');
                          var storyownerName = massege.get('ownerName');
                          var storytext = massege.get('text');
                          var storytime = massege.get('time');
                          var storytype = massege.get('type');
                          var storyyear = massege.get('year');
                          if(storyyear==now.year.toString()){
                            int dd = int.parse(storyday);
                            int mm = int.parse(storymonth);
                            int hh = int.parse(storytime);
                            if(mm==now.month){
                              if(dd==now.day){
                                StoryModel ss = StoryModel(storyowner, storyownerName, storyMedia, storytext, storyyear, storymonth, storyday, storytime, storytype);
                                myfriends[index].storys.add(ss);
                              }
                              else{
                                if(dd<now.day-1) {
                                  firebaseStorage.refFromURL(storyMedia).delete();

                                  _firestore.collection("storys").doc(storyid)
                                      .delete()
                                      .then(
                                        (doc) =>{},
                                    onError: (e) =>{},
                                  );
                                }
                                else if(hh<=now.hour){
                                  StoryModel ss = StoryModel(storyowner, storyownerName, storyMedia, storytext, storyyear, storymonth, storyday, storytime, storytype);
                                  myfriends[index].storys.add(ss);
                                }
                                else{
                                  if(storytype=="photo" || storytype=="vedio"){
                                    firebaseStorage.refFromURL(storyMedia).delete();
                                  }
                                  _firestore.collection("storys").doc(storyid).delete().then(
                                        (doc) =>{},
                                    onError: (e) =>{},
                                  );
                                }
                              }
                            }
                            else{
                              if(storytype=="photo" || storytype=="vedio"){
                                firebaseStorage.refFromURL(storyMedia).delete();
                              }
                              _firestore.collection("storys").doc(storyid).delete().then(
                                    (doc) =>{},
                                onError: (e) =>{},
                              );
                            }
                          }
                        }
                        if(index==0){
                          print("myfriends[index].photo   ${myfriends[index].photo}");
                          return myfriends[index].storys.isNotEmpty?Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  if(MystoryWedgites.isEmpty){
                                    Allarm();
                                  }
                                  else{
                                    us.storys=MystoryWedgites;
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewStoryScreen(us)));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade300,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(_auth.currentUser!.photoURL.toString())
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(myfriends[index].storys.isEmpty){
                                  }
                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewStoryScreen(myfriends[index])));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(myfriends[index].photo)
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ):
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: (){
                                  if(MystoryWedgites.isEmpty){
                                    Allarm();
                                  }
                                  else{
                                    us.storys=MystoryWedgites;
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewStoryScreen(us)));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(_auth.currentUser!.photoURL.toString())
                                        )
                                      ),
                                  ),
                                ),
                              ),
                              MystoryWedgites.isEmpty ?Text("Add Story",style: TextStyle(color: Colors.black),):Text('View Your Story')
                            ],
                          );
                        }
                        else{
                          if(myfriends[index].storys.isNotEmpty){
                            return InkWell(
                              onTap: (){
                                if(myfriends[index].storys.isEmpty){
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewStoryScreen(myfriends[index])));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(myfriends[index].photo)
                                      )
                                  ),
                                ),
                              ),
                            );
                          }
                          else{
                            return Container();
                          }
                        }
                      },
                    );
                  },
                );
              },
            ):InkWell(
              onTap: (){
                if(MystoryWedgites.isEmpty){
                  Allarm();
                }
                else{
                  us.storys=MystoryWedgites;
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewStoryScreen(us)));
                }
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(_auth.currentUser!.photoURL.toString())
                              )
                          ),
                        ),
                        MystoryWedgites.isNotEmpty?Text("Tab to view"):Text("Tab to Add Story")
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("اضافة حالة جديد"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                 ElevatedButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (builder)=>const AddStory()));
                 }, child: Text("نص")),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  }, child: Text("صورة")),
                ],
              )
          );
        });
  }
  Future getImage(ImageSource media) async{
    var img = await picker.pickImage(source:media);
    setState(() {
      image=img;
    });
    final path="story/photos/${image!.name}";
    final file =File(image!.path);
    final ref=FirebaseStorage.instance.ref().child(path);
    final uploadTask=ref.putFile(file);
    final snapshot=await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : $urlDownload");
    final id =DateTime.now().toString();
    String idd="$id-${_auth.currentUser!.uid}";
    await _firestore.collection('storys').doc(idd).set({
      'ownerName':_auth.currentUser!.displayName.toString(),
      'owner':_auth.currentUser!.uid,
      'Media':urlDownload,
      'text':"",
      'day':now.day.toString(),
      'time':now.hour.toString(),
      'month':now.month.toString(),
      'year':now.year.toString(),
      'type':'photo'
    });
  }

}