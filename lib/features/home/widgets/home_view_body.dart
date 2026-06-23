import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/rooms/view/create_room_view.dart';
import 'package:hayaa_main/features/rooms/view/room_view.dart';
import 'package:hayaa_main/models/room_model.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../core/Utils/app_images.dart';
import '../../../models/user_model.dart';
import '../../search/view/search_view.dart';
import '../models/room_model.dart';
import 'horezintal_rooms_section.dart';
import 'horizontal_event_slider.dart';
import 'sub_screens_section.dart';
import 'vertical_rooms_list_view_builder.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel userModel = UserModel(
      "email", "name", "gende", "photo", "id", "phonenumber", "devicetoken",
      "daimond", "vip", "bio", "seen", "lang", "country", "type", "birthdate",
      "coin", "exp", "level");

  StreamSubscription? _userSub;

  @override
  void initState() {
    super.initState();
    _listenUser();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  void _listenUser() {
    final user = _auth.currentUser;
    if (user == null) return;
    final query = user.email != null
        ? _firestore.collection('user').where('email', isEqualTo: user.email)
        : _firestore.collection('user').where('phonenumber', isEqualTo: user.phoneNumber);

    _userSub = query.snapshots().listen((snap) {
      if (snap.docs.isEmpty || !mounted) return;
      final d = snap.docs[0];
      setState(() {
        userModel.bio = d.get('bio') ?? '';
        userModel.birthdate = d.get('birthdate') ?? '';
        userModel.coin = d.get('coin') ?? '0';
        userModel.country = d.get('country') ?? '';
        userModel.daimond = d.get('daimond') ?? '0';
        userModel.devicetoken = d.get('devicetoken') ?? '';
        userModel.email = d.get('email') ?? '';
        userModel.exp = d.get('exp') ?? '0';
        userModel.gender = d.get('gender') ?? '';
        userModel.id = d.get('id') ?? '';
        userModel.lang = d.get('lang') ?? 'ar';
        userModel.level = d.get('level') ?? '1';
        userModel.name = d.get('name') ?? '';
        userModel.phonenumber = d.get('phonenumber') ?? '';
        userModel.photo = d.get('photo') ?? '';
        userModel.seen = d.get('seen')?.toString() ?? '';
        userModel.type = d.get('type') ?? '';
        userModel.vip = d.get('vip') ?? '0';
        userModel.myroom = d.get('room') ?? '';
      });
    });
  }
  // images list kept for legacy widget compatibility
  List<String> images = [];
  List<String> countryCodes = Flags.flagsCode;
  List<RoomModel> rooms = [
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage2),
  ];
  List<RoomModel> rooms2 = [
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage2),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage4),
    RoomModel(
        userImage: AppImages.p2, name: "Name", image: AppImages.roomImage),
    RoomModel(
        userImage: AppImages.p3, name: "Name", image: AppImages.roomImage3),
    RoomModel(
        userImage: AppImages.p1, name: "Name", image: AppImages.roomImage3),
  ];
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
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchView.id);
              }, icon: const Icon(Icons.search,color: Colors.white,)),
          IconButton(
              onPressed: () {
                if(userModel.myroom==""){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateRoomView()));
                }
                else{
                  _firestore.collection('room').doc(userModel.myroom).collection('user').doc(_auth.currentUser!.uid).set({
                    'id':userModel.id,
                    'type':'owner'
                  }).then((value){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RoomView(userModel.myroom,true,userModel.name,_auth.currentUser!.uid,),));
                  });
                }
              }, icon:userModel.myroom==""?Icon(Icons.add_home_outlined,color: Colors.white,):
              Icon(Icons.home_filled,color: Colors.white,)
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.19,
                  child: const Text(
                    "مجاورون",
                    style: TextStyle(
                        fontFamily: "Hayah", fontSize: 20, color: Colors.white),
                  ).tr(args: ['مجاورون']),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.12,
                    child: const Text(
                      "شعبي",
                      style: TextStyle(
                          fontFamily: "Hayah",
                          fontSize: 22,
                          color: Colors.white),
                    ).tr(args: ['شعبي']),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: const Text(
                    "متعلق",
                    style: TextStyle(
                        fontFamily: "Hayah", fontSize: 20, color: Colors.white),
                  ).tr(args: ['متعلق']),
                ),
              ),
            ],
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('user').where('doc',isEqualTo: _auth.currentUser!.uid).snapshots(),
        builder: (context,snapshot){
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            userModel.myroom=massege.get('room');
          }
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('event').snapshots(),
            builder: (context,snapshot){
              List<String> img=[];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
              final masseges = snapshot.data?.docs;
              for (var massege in masseges!.reversed){
                img.add(massege.get('photo'));
              }
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('room').where('owner',isNotEqualTo: _auth.currentUser!.uid).snapshots(),
                builder: (context,snapshot){
                  List<RoomModels> roomss=[];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final masseges = snapshot.data?.docs;
                  for (var massege in masseges!.reversed){
                    roomss.add(
                        RoomModels(massege.get('id'), massege.id, massege.get('gift'), massege.get('gifttype'),
                            massege.get('cartype'), massege.get('wallpaper'), massege.get('password'),
                            massege.get('owner'), massege.get('bio'), massege.get('car'), massege.get('seat'),massege.get('photo'))
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: HorizontalEventSlider(
                                screenHight: MediaQuery.of(context).size.height,
                                screenWidth: MediaQuery.of(context).size.width,
                                images: img),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0),
                            child: SubScreensSection(
                              screenHight: MediaQuery.of(context).size.height,
                              screenWidth: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0,right: 8.0,left: 8.0),
                            child: HorezintalSection(
                                screenWidth: MediaQuery.of(context).size.width,
                                screenHight: MediaQuery.of(context).size.height,
                                rooms: rooms),
                          ),
                          ListTile(
                            title: Text("الدول",style: TextStyle(color: Colors.pink.withOpacity(1),fontFamily: "Questv1"),),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Show All",style: TextStyle(color: Colors.pink.withOpacity(1),fontFamily: "Questv1")),
                                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward,color:Colors.pink.withOpacity(1) ,))
                              ],
                            ) ,
                          ),
                          Container(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:8,
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flag.fromString(
                                          countryCodes[index],
                                          height: 40,
                                          width: 60,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          Flag.fromString(
                                            countryCodes[index],
                                            height: 40,
                                            width: 60,
                                          ).country,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0,right: 8.0,left: 8.0,bottom: 8.0),
                            child: VerticalRoomsListViewBuilder(
                                rooms: roomss,
                                screenWidth: MediaQuery.of(context).size.width,
                                screenHight: MediaQuery.of(context).size.height),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 9.0,bottom: 18),
                            child: HorizontalEventSlider(
                                screenHight: MediaQuery.of(context).size.height,
                                screenWidth: MediaQuery.of(context).size.width,
                                images: img),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: VerticalRoomsListViewBuilder(
                                rooms: roomss,
                                screenWidth: MediaQuery.of(context).size.width,
                                screenHight: MediaQuery.of(context).size.height),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      )
    );
  }
  List<Widget> generateFlagsWithCode() {
    List<String> countryCodes = Flags.flagsCode;
    return countryCodes.map((code) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flag.fromString(
              code,
              height: 40,
              width: 60,
            ),
            SizedBox(height: 5),
            Text(
              Flag.fromString(
                code,
                height: 40,
                width: 60,
              ).country,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }
  void CreateRoom() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("تنبيه"),
              content: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("هل تود انشاء غرفتك"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: ()async{
                          String roomID="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                          _firestore.collection('room').doc(roomID).set({
                            'id':userModel.id,
                            'doc':roomID,
                            'owner':_auth.currentUser!.uid
                          }).then((value){
                           _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                             'room':roomID
                           }).then((value){
                             setState(() {
                               userModel.myroom=roomID;
                             });
                             Navigator.pop(context);
                           });
                          });
                        }, child: Text("نعم")),
                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("لا"))
                      ],
                    )
                  ],
                ),
              )
          );
        });
  }
}
