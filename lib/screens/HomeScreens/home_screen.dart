import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import 'package:iconnect2/Model/daily_model.dart';
import 'package:iconnect2/screens/HomeScreens/find_contact.dart';
import 'package:iconnect2/screens/CreateAccound_Login/main_screen.dart';
import 'package:iconnect2/screens/HomeScreens/post_screen.dart';
import 'package:iconnect2/screens/setting_screen.dart';
import 'package:iconnect2/screens/HomeScreens/voice_room.dart';
import '../Store/ListViewStore.dart';
import 'game_screen.dart';
import 'profile.dart';
import '../call_history.dart';
import 'contact_chat_page.dart';

class HomeScreen extends StatefulWidget {
  chatmodel source = chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  static const String ScreenRoute = 'home_screen';
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  chatmodel user = chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  int _selectedIndex = 5;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final flutterloacl =FlutterLocalNotificationsPlugin();
  int countNotification = 0;
  @override
  void initState() {
    super.initState();
    getUser();
    CheckVip();
    _getPermesion();
    initInfo();
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
        showNotification(message.notification!.title!, message.notification!.body!);
      }
    });

  }
  Future<void> showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iosDetails = IOSNotificationDetails();
    var platformDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformDetails,
        payload: 'item x');
  }

  void getUser() async {
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore.collection('user').where('email', isEqualTo: _auth.currentUser?.email).snapshots()) {
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        user.email = usersMap2!['email'];
        user.name = usersMap2!['name'];
        user.photo = usersMap2!['photo'];
        user.devicetoken = usersMap2!['devicetoken'];
        user.gender = usersMap2!['gender'];
        user.bio = usersMap2!['bio'];
        user.coin = usersMap2!['coin'];
      });
    }
    setDeviceToken();
  }
  void CheckVip()async{
    try{
      Map<String, dynamic>? usersMap;
      String idUser="";
      int day=0;int month=0;int year=0;
      await _firestore.collection('Vip').where('email',isEqualTo: user.email).get().then((value){
        usersMap = value.docs[0].data();
        idUser = value.docs[0].id;
        day=int.parse(usersMap!['day']);
        month=int.parse(usersMap!['month']);
        year=int.parse(usersMap!['year']);
      });
      DateTime time=DateTime.now();
      if(time.year==year){
        if(time.day<day+15 || time.month==month){
          user.vip="1";
        }
        else{
          user.vip="0";
          _firestore.collection("Vip").doc(idUser).delete().then(
                (doc) => {},
            onError: (e) => {},
          );
        }
      }
      else{
        user.vip="0";
        _firestore.collection("Vip").doc(idUser).delete().then(
              (doc) => {},
          onError: (e) => {},
        );
      }
    }
    catch(e){
      print(e);
    }
  }

  void setDeviceToken() async {
    try {
      String id = "";
      await _firestore.collection('user').where('email', isEqualTo: _auth.currentUser!.email).get().then((value) {
        id = value.docs[0].id;
      });
      fcm.getToken().then((value) {
        final docRef = _firestore.collection("user").doc(id);
        final updates = <String, dynamic>{
          "devicetoken": value,
        };
        user.devicetoken = value.toString();
        docRef.update(updates);
        print('Update Token \n new Token is $value');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ProfilePage(),
      GameScreenList(),
      VoiceRoom(),
      FindContact(),
      ChatPage(user),
      PostScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BIBGO",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontFamily: "Signatra",
          ),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.currency_bitcoin, color: Colors.yellow),
            onPressed: () {
              Navigator.pushNamed(context, "DiamondScreen_screen");
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.coin,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == "logout") {
                await _auth.signOut();
                Navigator.popAndPushNamed(context, MainScreen.ScreenRoute);
              }
              if (value == "setting") {
                Navigator.pushNamed(context, ProfilePage.ScreenRoute);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      Text("حول التطبيق"),
                    ],
                  ),
                  value: "New Group",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      Text("تسجيل الخروج"),
                    ],
                  ),
                  value: "logout",
                ),
              ];
            },
          ),
          // Add the "Upgrade to VIP2" button here
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckout(
                  sandboxMode: true,
                  clientId: "Ad8og4bw29PPgCJ7hxwrZDPOO62wn0mbC_bJsSh9hWeFKZcf1vGKWfnTYId-hiHLiryIJESJ_ARK_1A-",
                  secretKey: "EJUyARqnZY6KXdvY0wpJZD0gL9VCqeaoW8Bjjg7HYgWBqG5Hb4LxcEuGnHqDQPMY54C980ctg5-Sh40T",
                  returnURL: "success.snippetcoder.com",
                  cancelURL: "cancel.snippetcoder.com",
                  transactions: [
                    {
                      "amount": {
                        "total": "50",
                        "currency": "USD",
                        "details": {
                          "subtotal": "50",
                          "shipping": '0',
                          "shipping_discount": '0',
                        }
                      },
                      "description": "The payment transaction description.",
                      "item_list": {
                        "items": [
                          {
                            "name": "Diamonds",
                            "quantity": 1,
                            "price": "50",
                            "currency": "USD",
                          },
                        ],
                      },
                    },
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    DateTime now = DateTime.now();
                    _firestore.collection('Vip').doc().set({
                      'email':'$user.email',
                      'day':now.day,
                      'month':now.month,
                      'year':now.year,
                    });
                    print("onSuccess: $params");
                    print(".................onSuccess...............");
                  },
                  onError: (error) {
                    print("onError: $error");
                    Navigator.pop(context);
                    print("...............failed..............");
                  },
                  onCancel: () {
                    print('Cancelled');
                  },
                ),
              ));
            },
            child: Text(
              "VIP2",
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF21BFBD),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        enableFeedback: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ادارة الحساب',
            activeIcon: Image(image: AssetImage("assets/profile.png"),height: 50,isAntiAlias: true),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'الالعاب',
            activeIcon: Image(image: AssetImage("assets/game.jpg"),height: 50,isAntiAlias: true),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.multitrack_audio),
            label: 'غرفة الصوتية',
            activeIcon: Image(image: AssetImage("assets/audio.png"),height: 50,isAntiAlias: true),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'البحث',
            activeIcon: Image(image: AssetImage("assets/search.png"),height: 50,isAntiAlias: true),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              grade: 6,
            ),
            activeIcon: Image(image: AssetImage("assets/chato.png"),height: 50,isAntiAlias: true),
            label: 'صفحة الدردشة',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              grade: 6,
            ),
            activeIcon: Image(image: AssetImage("assets/home.png"),height: 50,isAntiAlias: true),
            label: 'الصفحة الرئيسية',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
  void notificationSettings()async{
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
