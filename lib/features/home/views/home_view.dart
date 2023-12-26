import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/Utils/app_colors.dart';
import '../../games/views/games_view.dart';
import '../../messages/views/messages_view.dart';
import '../../post/widget/post_view_body.dart';
import '../../profile/views/profile_view.dart';
import '../widgets/home_view_body.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const id = 'HomeView';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 2;
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final flutterloacl =FlutterLocalNotificationsPlugin();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
    @override
  void initState() {
    super.initState();
    _getPermesion();
    initInfo();
    setDeviceToken();
  }
  void setDeviceToken() async {
    try {
      fcm.getToken().then((value) {
        final docRef = _firestore.collection("user").doc(_auth.currentUser!.uid);
        final updates = <String, dynamic>{
          "devicetoken": value,
        };
        docRef.update(updates);
        print('Update Token \n new Token is $value');
      });
    } catch (e) {
      print(e);
    }
  }
  void _getPermesion()async{
    NotificationSettings settings =  await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("User Granted Permesion");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print("User Granted Provisional ");
    }
    else{
      print("User Declind");
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');

      if (message.notification != null && message.notification!.title != null && message.notification!.body != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null && message.notification!.title != null && message.notification!.body != null) {
        print('Message also contained a notification: ${message.notification}');
        showNotification(
          0,
            message.notification!.title!, message.notification!.body!);
      }
    });

  }
  int generateUniqueId() {
    return Random().nextInt(100000); // Replace this with your preferred unique ID generation logic
  }

  Future<void> showNotification(int id,String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iosDetails = IOSNotificationDetails();
    var platformDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(generateUniqueId(), title, body, platformDetails,
        payload: 'item x');
  }

  void initInfo(){
    var androidinti=const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosinit=const IOSInitializationSettings();
    var initSetting=InitializationSettings(android: androidinti,iOS: iosinit);
    flutterloacl.initialize(initSetting,onSelectNotification: (String ? payload)async{
      try{
        if(payload != null && payload.isNotEmpty){

        }
        else{

        }
      }
      catch(e){
        print(e);
      }
    });
  }


  List<Widget> views = [
     ProfileView(),
     MessagesView(),
     HomeViewBody(),
     GamesView(),
     PostViewBody(),
  ];
  List<Icon> iconList = [
    Icon(Icons.menu, color: Colors.white, size: 60),
    Icon(Icons.message_rounded, color: Colors.white, size: 60),
    Icon(Icons.home_outlined, color: Colors.white, size: 60),
    Icon(Icons.games, color: Colors.white, size: 60),
    Icon(Icons.groups, color: Colors.white, size: 60),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: views[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8E24AA), Color(0xFF673AB7)], // Example gradient colors
          ),
        ),
        child: CurvedNavigationBar(
            height: 60,
            key: _bottomNavigationKey,
            letIndexChange: (index) => true,
            index: currentIndex,
            animationCurve: Curves.easeInOut,
            color:AppColors.appInformationColors400,
            buttonBackgroundColor:AppColors.appPrimaryColors500,
            backgroundColor:Colors.white,
            animationDuration: Duration(milliseconds: 400),
                    onTap: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
            items: [
              getIcon(0),
              getIcon(1),
              getIcon(2),
              getIcon(3),
              getIcon(4),
            ],
        ),
      ),
    );

  }
  Widget getIcon(int index) {
    return Icon(
      iconList[index].icon,
      size: currentIndex == index ? 40 : 20,
      color:iconList[index].color ,
    );
  }

}
