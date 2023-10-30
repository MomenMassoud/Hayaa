import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import 'package:iconnect2/Model/followes_model.dart';
import 'package:image_picker/image_picker.dart';

import '../Follow_Views/follow_screen.dart';
import '../Follow_Views/followers_screen.dart';

class ProfilePage extends StatefulWidget {
  static const String ScreenRoute = 'profile_screen';
  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  chatmodel user = chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");

  @override
  void initState() {
    super.initState();
    getUser();
    getFollow();
    getFollowers();
  }

  void getUser() async {
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore
        .collection('user')
        .where('email', isEqualTo: _auth.currentUser?.email)
        .snapshots()) {
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        user.email = usersMap2!['email'];
        user.name = usersMap2!['name'];
        user.photo = usersMap2!['photo'];
        user.devicetoken = usersMap2!['devicetoken'];
        user.gender = usersMap2!['gender'];
        user.bio = usersMap2!['bio'];
        user.coin = usersMap2!['coin'];
        if (user.gender == "Gender.male") {
          user.gender = "ذكر";
        } else {
          user.gender = "انثى";
        }
      });
    }
  }

  void getFollow()async{
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore
        .collection('follow')
        .where('owner', isEqualTo: _auth.currentUser?.email)
        .snapshots()) {
     for(int i=0;i<snapshots.size;i++){
        usersMap2 = snapshots.docs[i].data();
        String email = usersMap2!['email'];
        String names = usersMap2!['name'];
        String photo = usersMap2!['photo'];
        print("objecttttttttttt");
        Follows follows=Follows(email, names, photo);
        setState(() {
          user.follows.add(follows);
        });
     }
    }
  }
  void getFollowers()async{
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore
        .collection('follow')
        .where('email', isEqualTo: _auth.currentUser?.email)
        .snapshots()) {
      for(int i=0;i<snapshots.size;i++){
        usersMap2 = snapshots.docs[i].data();
        String email = usersMap2!['owner'];
        print("Owner");
        setState(() {
          user.followers.add(email);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                myAlert();
              },
              child: CircleAvatar(
                radius: 75.0,
                backgroundColor: Colors.lightBlue, // Set your desired background color
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                    ),
                    if (user.photo != null)
                      CircleAvatar(
                        radius: 75.0,
                        backgroundImage: CachedNetworkImageProvider(user.photo),
                      )
                    else
                      Icon(
                        Icons.person,
                        size: 90.0,
                        color: Colors.grey[600],
                      ),
                    Positioned(
                      bottom: 10,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.lightBlue, // Set the icon color
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name ?? '',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    myName();
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FollowScreen(user.follows)));
                },
                child: Text("تتابع ${user.follows.length}",style: TextStyle(
                  fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blue
                ),),
              ),
                SizedBox(width: 50,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FollowersScreen(user.followers)));
                  },
                  child: Text("المتابعين ${user.followers.length}",style: TextStyle(
                      fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blue
                  ),),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              user.email ?? '',
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
            SizedBox(height: 16.0),
            Divider(height: 32.0, thickness: 1.0),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.gender ?? '',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'الجنس',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.coin.toString() ?? '',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'العملات',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                myBIO();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.bio.toString() ?? '',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    'الحاله',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void myName() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ادخل الاسم الجديدة"),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  myTextfield(),
                ],
              ),
            ),
          );
        });
  }
  void myBIO() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("تعديل الحالة"),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  myTextfield2(),
                ],
              ),
            ),
          );
        });
  }
  String newName="";
  Widget myTextfield() {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          cursorColor: Colors.blue[900],
          onChanged: (value) {
            newName=value;
            decoration:
            InputDecoration(
              prefixIcon: Icon(Icons.account_circle),
              hintText: "ادخل اسمك",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              Map<String, dynamic>? usersMap;
              String idUser = "";
              await _firestore
                  .collection('user')
                  .where('email', isEqualTo: user.email)
                  .get()
                  .then((value) {
                usersMap = value.docs[0].data();
                idUser = value.docs[0].id;
              });
              final docRef2 = _firestore.collection("user").doc(idUser);
              final updates2 = <String, dynamic>{
                "name": newName,
              };
              docRef2.update(updates2);
              setState(() {
                user.name=newName;
              });
              Navigator.pop(context);
            } catch (e) {}
          },
          child: Text("حفظ التعديل"),
        )
      ],
    );
  }
  Widget myTextfield2() {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          cursorColor: Colors.blue[900],
          onChanged: (value) {
            String newBio="";
            setState(() {
              newBio = value;
            });
            decoration:
            InputDecoration(
              prefixIcon: Icon(Icons.account_circle),
              hintText: "ادخل الحالة الجديدة",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () async {
            String newBio="";
            try {
              Map<String, dynamic>? usersMap;
              String idUser = "";
              await _firestore
                  .collection('user')
                  .where('email', isEqualTo: user.email)
                  .get()
                  .then((value) {
                usersMap = value.docs[0].data();
                idUser = value.docs[0].id;
              });
              final docRef2 = _firestore.collection("user").doc(idUser);
              final updates2 = <String, dynamic>{
                "bio": newBio,
              };
              docRef2.update(updates2);
              Navigator.pop(context);
            } catch (e) {}
            setState(() {
              user.bio = newBio;
            });
          },
          child: Text("حفظ التعديل"),
        )
      ],
    );
  }
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('برجاء اختيار الصورة'),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text("من المعرض"),
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt),
                          Text("التقاط صورة"),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
    String em = "";
    String idUser = "";
    String lastpath = "";
    String lastName = "";
    Map<String, dynamic>? usersMap;
    final path = "profile_photos/${image!.name}";
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : ${urlDownload}");
    await _firestore
        .collection("user")
        .where('email', isEqualTo: _auth.currentUser!.email)
        .get()
        .then((value) {
      usersMap = value.docs[0].data();
      em = usersMap!['email'];
      idUser = value.docs[0].id;
    });
    final docRef = _firestore.collection("user").doc(idUser);
    final updates = <String, dynamic>{
      "photo": urlDownload,
    };
    docRef.update(updates);
    _auth.currentUser?.updatePhotoURL(urlDownload);
    print("Photo Profile Update");
    setState(() {
      user.photo = urlDownload;
    });
  }
}
