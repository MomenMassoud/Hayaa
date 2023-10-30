import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/comment_model.dart';
import 'package:iconnect2/Model/love_model.dart';
import 'package:iconnect2/screens/DiamondButton.dart';
import 'package:iconnect2/screens/HomeScreens/comment_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Custom_Wedgit/view_media.dart';
import '../../Model/ChatModel.dart';
import '../../Model/daily_model.dart';
import '../../Model/post_model.dart';
import '../Store/ListViewStore.dart';

class PostScreen extends StatefulWidget{
  _PostScreen createState()=>_PostScreen();
}

class _PostScreen extends State<PostScreen>{
  chatmodel source = chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  XFile? image;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore2 = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore3 = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showspinner = false;
  bool see=false;
  int dailyindex=0;
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    _getDailyLogin();
  }
  void _getDailyLogin()async{
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore.collection('daily').where('email', isEqualTo: _auth.currentUser?.email).snapshots()) {
      if(snapshots.size==7){
        usersMap2 = snapshots.docs[6].data();
        String day = usersMap2!['day'];
        DateTime time=DateTime.now();
        if(day!=time.day.toString()){
          for(int i=0;i<snapshots.size;i++){
            usersMap2 = snapshots.docs[i].data();
            deleteAllDaily(snapshots.docs[i].id);
          }
        }
      }
      else{
        for(int i=0;i<snapshots.size;i++){
          usersMap2 = snapshots.docs[i].data();
          String email = usersMap2!['email'];
          String day = usersMap2!['day'];
          DailyLogin dailyLogin=DailyLogin(email, snapshots.docs[i].id, day);
          setState(() {
            source.dailyLogin.add(dailyLogin);
          });
        }
      }

    }
    setState(() {
      dailyindex=user.dailyLogin.length;
    });
  }
  void deleteAllDaily(String id)async{
    final docRef= _firestore.collection('daily').doc(id);
    docRef.delete().then((value) => print("DeleteDaily"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ModalProgressHUD(
          inAsyncCall: _showspinner,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('post').snapshots(),
            builder: (context,snapshot) {
              List<PostModel> posts = [];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed) {
                String ownername=massege.get('owner_name');
                String owneremail=massege.get('owner_email');
                String ownerphoto=massege.get('owner_photo');
                String day=massege.get('day');
                String month=massege.get('month');
                String year=massege.get('year');
                String text=massege.get('text');
                String photo=massege.get('photo');
                bool view=false;
                if(owneremail!=_auth.currentUser!.email.toString()){
                  view=true;
                }
                PostModel postModel = PostModel(owneremail, ownerphoto, text, photo, day, month, year,view);
                postModel.ownerName=ownername;
                postModel.id=massege.id;
                posts.add(postModel);
              }
              return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context,index){

                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore2.collection('post').doc(posts[index].id).collection('like').snapshots(),
                      builder: (context,snapshot){
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                        final masseges = snapshot.data?.docs;
                        int i=0;
                        for (var massege in masseges!.reversed) {
                          String email =massege.get('email');
                          String photo =massege.get('photo');
                          String name =massege.get('name');
                          LoveModel love=LoveModel(email, name, photo);
                          love.id=massege.id;
                          if(source.email==email){
                            posts[index].like=true;
                            posts[index].indexLike=i;
                          }
                          else{
                            posts[index].like=false;
                          }
                          posts[index].likes.add(love);
                          i++;
                        }
                        return StreamBuilder<QuerySnapshot>(
                                stream: _firestore3.collection('post').doc(posts[index].id).collection('comment').snapshots(),
                                builder: (context,snapshot){
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                      ),
                                    );
                                  }
                                  print("HiHI${posts[index].followButton}");
                                  final masseges = snapshot.data?.docs;
                                  for (var massege in masseges!.reversed) {
                                    String email =massege.get('email');
                                    String photo =massege.get('photo');
                                    String name =massege.get('name');
                                    String comment =massege.get('comment');
                                    CommentModel love=CommentModel(email, name, photo,comment);
                                    love.id=massege.id;
                                    posts[index].comments.add(love);
                                  }
                                  return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding:  const EdgeInsets.all(15),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:<Widget> [
                                                    CachedNetworkImage(imageUrl: posts[index].Photo,height: 100,width: 200, fit: BoxFit.cover,),
                                                    Container(width: 20),
                                                    Expanded(child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:<Widget> [
                                                        Container(height: 5),
                                                        posts[index].followButton?Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: ()async{
                                                                try{
                                                                  await _firestore.collection('follow').doc().set({
                                                                    "owner":source.email,
                                                                    "email":posts[index].owner,
                                                                    "name":posts[index].ownerName,
                                                                    "photo":posts[index].Owner_photo
                                                                  });
                                                                }
                                                                catch(e){
                                                                  print(e);
                                                                }
                                                              },
                                                              child: Text(
                                                                "متابعة",
                                                                style: TextStyle(
                                                                  color: Colors.blue,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 2,),
                                                            Text(posts[index].ownerName,
                                                              style:TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 22
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: (){
                                                                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewMedia(posts[index].Owner_photo,)));
                                                              },
                                                              child: CircleAvatar(
                                                                backgroundImage: CachedNetworkImageProvider(posts[index].Owner_photo,scale: 1.0),
                                                              ),
                                                            ),

                                                          ],
                                                        ):Row(
                                                          children: [
                                                            Text(posts[index].ownerName,
                                                              style:TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 22
                                                              ),
                                                            ),
                                                            CircleAvatar(
                                                              backgroundImage: CachedNetworkImageProvider(posts[index].Owner_photo),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(height: 5),
                                                        Text(
                                                          posts[index].Text,
                                                        ),
                                                        Container(height: 10),
                                                        Row(
                                                          children:<Widget> [
                                                            Row(
                                                              children: [
                                                                Text(posts[index].likes.length.toString()),
                                                                IconButton(
                                                                  onPressed: ()async{
                                                                    if(posts[index].like){
                                                                      final docRef= _firestore.collection('post').doc(posts[index].id);
                                                                      docRef.collection("like").doc(posts[index].likes[posts[index].indexLike].id).delete();
                                                                      setState(() {
                                                                        posts[index].likes.elementAt(posts[index].indexLike);

                                                                      });
                                                                    }
                                                                    else{
                                                                      final docRef= _firestore.collection('post');
                                                                      docRef.doc(posts[index].id).collection('like').add({
                                                                        'email':source.email,
                                                                        'photo':source.photo,
                                                                        'name':source.name,
                                                                      });
                                                                    }
                                                                  },
                                                                  icon:posts[index].like? Icon(
                                                                      Icons.favorite_outlined
                                                                  ):Icon(Icons.favorite_outline_sharp),
                                                                  color:posts[index].like?Colors.red: Colors.grey,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(posts[index].comments.length.toString()),
                                                                IconButton(
                                                                  onPressed: (){
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (builder) =>
                                                                                CommentView(source, posts[index].comments,posts[index].id)));
                                                                  },
                                                                  icon: Icon(
                                                                      Icons.comment
                                                                  ),
                                                                  color: Colors.grey,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                },
                              );
              });

            }
          )
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Image.asset("assets/create.png"),
            onPressed: (){
              showModalBottomSheet(
                  backgroundColor:
                  Colors.transparent,
                  context: context,
                  builder: (builder) =>
                      bottomSheet(context));
            },
          ),
          SizedBox(height: 8,),
          FloatingActionButton(
            child: Image.asset("assets/daily.png",fit: BoxFit.fill),
            onPressed: (){
              showModalBottomSheet(
                  backgroundColor:
                  Colors.transparent,
                  context: context,
                  builder: (builder) =>
                      bottomSheets3(context));
            },
          ),
          SizedBox(height: 8,),
          FloatingActionButton(
            child: Image.asset("assets/store.png",fit: BoxFit.fill),
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListViewStore()));
            },
          ),
        ],
      ),
    );
  }
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('برجاء اختيار طريقة رفع الصورة'),
            content: Container(
              height: 130,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery,);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Text("من معرض الصور"),
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
                          Text("التقاط صورة جديدة"),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
  Widget bottomSheet(context) {
    String post="";
    return Container(
      height: 578,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Card(
                child: InkWell(
                    onTap: (){
                      myAlert();
                    },
                    child:Image.asset("assets/upload.jpg",height: 150,width: MediaQuery.of(context).size.width,)
                ),
              ),
              SizedBox(height: 50,),
              TextFormField(
                cursorColor: Colors.blue[900],
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    setState(() {
                      post=value;
                      print(post);
                    });
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.post_add),
                  hintText: "قم بكتباة المنشور",
                  filled: true,
                  fillColor: Colors.grey[100], // Change the background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // side: BorderSide(color: Colors.yellow, width: 5),
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    shadowColor: Colors.lightBlue,
                  ),
                  onPressed: ()async{
                    DateTime time=DateTime.now();
                    String idd="${time.toString()}-${source.email}";
                    await _firestore.collection('post').doc(idd).set({
                      "owner_email":source.email,
                      "owner_photo":source.photo,
                      "owner_name":source.name,
                      "day":time.day.toString(),
                      "month":time.month.toString(),
                      "year":time.year.toString(),
                      "text":_controller.text,
                      "photo":download
                    });
                    _controller.clear();
                    download="";
                    Navigator.pop(context);
                  },
                  child: Text(
                    "انشر",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget bottomSheets2(context,List<CommentModel> comments) {
    return Container(
      height: 578,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context,index){
        if(index==comments.length-1){
          return TextFormField();
        }
        else{
          return Text("data");
        }
      })
    );
  }
  Widget bottomSheets3(context) {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("اليوم الاول"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==0){
                            int newCoin=int.parse(source.coin)+50;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child: Card(
                          child:source.dailyLogin.length>0?Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/Dimonds/1.png"),
                              ),
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/done.png"),
                              ),
                            ],
                          ): CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("50")
                    ],
                  ),
                  Column(
                    children: [
                      Text("اليوم الثاني"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==1 &&source.dailyLogin[0].day!=DateTime.now().day.toString()){
                            int newCoin=int.parse(source.coin)+100;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child: Card(
                          child: source.dailyLogin.length>1?Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/Dimonds/1.png"),
                              ),
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/done.png"),
                              ),
                            ],
                          ):CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("100")
                    ],
                  ),
                  Column(
                    children: [
                      Text("اليوم الثالث"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==2&&source.dailyLogin[1].day!=DateTime.now().day.toString()){
                            int newCoin=int.parse(source.coin)+150;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child: source.dailyLogin.length>2?Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/Dimonds/1.png"),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/done.png"),
                            ),
                          ],
                        ):Card(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("150")
                    ],
                  ),
                  Column(
                    children: [
                      Text("اليوم الرابع"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==3&&source.dailyLogin[2].day!=DateTime.now().day.toString()){
                            int newCoin=int.parse(source.coin)+200;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child: source.dailyLogin.length>3?Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/Dimonds/1.png"),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/done.png"),
                            ),
                          ],
                        ):Card(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("200")
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("اليوم الخامس"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==4&&source.dailyLogin[3].day!=DateTime.now().day.toString()){
                            int newCoin=int.parse(source.coin)+250;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child: source.dailyLogin.length>4?Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/Dimonds/1.png"),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/done.png"),
                            ),
                          ],
                        ):Card(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("250")
                    ],
                  ),
                  Column(
                    children: [
                      Text("اليوم السادس"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==5&&source.dailyLogin[4].day!=DateTime.now().day.toString()){
                            int newCoin=int.parse(source.coin)+300;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child:source.dailyLogin.length>5?Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/Dimonds/1.png"),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/done.png"),
                            ),
                          ],
                        ): Card(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("300")
                    ],
                  ),
                  Column(
                    children: [
                      Text("اليوم السابع"),
                      InkWell(
                        onTap: ()async{
                          if(source.dailyLogin.length==6&&source.dailyLogin[5].day!=DateTime.now().day.toString()){
                            int newCoin=int.parse(source.coin)+350;
                            String idd="${DateTime.now().toString()}-${source.email}";
                            await _firestore.collection("daily").doc(idd).set({
                              'email':source.email,
                              'day':DateTime.now().day.toString()
                            });
                            final docRef2 = _firestore.collection("user").doc(source.id);
                            final updates2 = <String, dynamic>{
                              "coin": newCoin.toString(),
                            };
                            docRef2.update(updates2);
                            print("update");
                          }
                        },
                        child: source.dailyLogin.length>6?Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/Dimonds/1.png"),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/done.png"),
                            ),
                          ],
                        ):Card(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/Dimonds/1.png"),
                          ),
                        ),
                      ),
                      Text("350")
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  final ImagePicker picker = ImagePicker();
  String download="";
  Future getImage(ImageSource media) async {
     var img = await picker.pickImage(source: media);
    setState(() {
      _showspinner=true;
      image = img;
    });
     Map<String, dynamic>? usersMap;
     final path = "post/${image!.name}";
     final file = File(image!.path);
     final ref = FirebaseStorage.instance.ref().child(path);
     final uploadTask = ref.putFile(file);
     final snapshot = await uploadTask!.whenComplete(() {});
     final urlDownload = await snapshot.ref.getDownloadURL();
     print("Download Link : ${urlDownload}");
     download=urlDownload;

     setState(() {
       _showspinner=false;
     });

  }
  void getUser() async {
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore.collection('user').where('email', isEqualTo: _auth.currentUser?.email).snapshots()) {
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        source.email = usersMap2!['email'];
        source.name = usersMap2!['name'];
        source.photo = usersMap2!['photo'];
        source.devicetoken = usersMap2!['devicetoken'];
        source.gender = usersMap2!['gender'];
        source.bio = usersMap2!['bio'];
        source.coin = usersMap2!['coin'];
        source.id=snapshots.docs[0].id;
      });
    }
  }
}


