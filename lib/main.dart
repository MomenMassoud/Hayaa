import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'core/Utils/app_routes.dart';
import 'features/splash/views/splash_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  ZegoUIKit().initLog().then((value){
    runApp(
        EasyLocalization(
            supportedLocales: [
              Locale('en','US'),
              Locale('ar','DZ'),
            ],
            path: 'lib/core/Utils/assets/lang',
            child: const MyApp()
        )
    );
  });

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
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused){
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      firestore.collection("user").doc(auth.currentUser!.uid).update({
        "seen":FieldValue.serverTimestamp(),
      });
      print("object");
    }
    else if(state == AppLifecycleState.inactive){
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      firestore.collection("user").doc(auth.currentUser!.uid).update({
        "seen":FieldValue.serverTimestamp(),
      });
      print("object");
    }
    else{
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      firestore.collection("user").doc(auth.currentUser!.uid).update({
        "seen":"online",
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: appRoutes,
      initialRoute: SplashView.id,

    );
  }
}
