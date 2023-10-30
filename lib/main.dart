import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconnect2/screens/Chat/Camera_Screen.dart';
import 'package:iconnect2/screens/DiamondButton.dart';
import 'package:iconnect2/screens/HomeScreens/find_contact.dart';
import 'package:iconnect2/screens/HomeScreens/home_screen.dart';
import 'package:iconnect2/screens/CreateAccound_Login/login_screen.dart';
import 'package:iconnect2/screens/CreateAccound_Login/main_screen.dart';
import 'package:iconnect2/screens/HomeScreens/profile.dart';
import 'package:iconnect2/screens/setting_screen.dart';
import 'package:iconnect2/screens/CreateAccound_Login/sign_up_screen.dart';

final _auth = FirebaseAuth.instance;
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv().load();
  cameras=await availableCameras();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  IOSInitializationSettings iosInitializationSettings =
  IOSInitializationSettings();
  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  _MyApp createState()=>_MyApp();

}

class _MyApp extends State<MyApp>with WidgetsBindingObserver{
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeMo',
      initialRoute:_auth.currentUser==null? MainScreen.ScreenRoute:HomeScreen.ScreenRoute,
      routes: {
        'login_screen':(context)=>LoginScreen(),
        'sign_up_screen':(context)=>SignUpScreen(),
        'main_screen':(context)=>MainScreen(),
        'home_screen':(context)=>HomeScreen(),
        'findcontact_screen':(context)=>FindContact(),
        'setting_screen':(context)=>SettingScreen(),
        'profile_screen':(context)=>ProfilePage(),
        'DiamondScreen_screen':(context)=>DiamondScreen()
      },
    );
  }

}
