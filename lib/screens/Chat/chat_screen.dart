import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iconnect2/Custom_Wedgit/own_msg.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import 'package:image_picker/image_picker.dart';
import '../../Custom_Wedgit/ownFilesCard.dart';
import '../../Custom_Wedgit/own_audio.dart';
import '../../Custom_Wedgit/own_vediocard.dart';
import '../../Custom_Wedgit/replayFileCard.dart';
import '../../Custom_Wedgit/replay_audio.dart';
import '../../Custom_Wedgit/replay_vediocard.dart';
import '../../Custom_Wedgit/reply-card.dart';
import '../../Model/massege_model.dart';
import '../../Model/record_model.dart';
import 'Camera_Page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget{
  chatmodel source,target;
  ChatScreen(this.source,this.target);
  _ChatScreen createState()=>_ChatScreen();
}

class _ChatScreen extends State<ChatScreen>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  bool type=false;
  XFile? image;
  String path = "";
  bool _showspinner = false;
  bool emojiShowing = false;
  bool IsRecording=false;
  String chatroomID="";
  String msg="";
  final ImagePicker picker = ImagePicker();
  FilePickerResult? _result;
  String? _FileName;
  PlatformFile? pickfile;
  File? filetoDisplay;
  final audioPlayer = AudioPlayer();
  final TextEditingController _controller = TextEditingController();
  final recordMethod = Recorder();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getContactData();
    setChatRoom();
  }
  void setChatRoom(){
    String id1=widget.source.email;
    String id2=widget.target.email;
    if (id1.toLowerCase().codeUnits[0] >
        id2.toLowerCase().codeUnits[0]) {
      chatroomID = "$id1$id2";
    } else {
      chatroomID = "$id2$id1";
    }
  }
  void getUser() async{
    Map<String, dynamic>? usersMap2;
    await for(var snapshots in _firestore.collection('user').where('email',isEqualTo: _auth.currentUser?.email).snapshots()){
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        widget.source.email=usersMap2!['email'];
        widget.source.name=usersMap2!['name'];
        widget.source.photo=usersMap2!['photo'];
        widget.source.devicetoken=usersMap2!['devicetoken'];
        widget.source.gender=usersMap2!['gender'];
        widget.source.bio=usersMap2!['bio'];
        widget.source.coin=usersMap2!['coin'];
      });
    }
  }
  void getContactData()async{
    Map<String, dynamic>? usersMap2;
    await for(var snapshots in _firestore.collection('user').where('email',isEqualTo: widget.target.email).snapshots()){
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        widget.target.email=usersMap2!['email'];
        widget.target.name=usersMap2!['name'];
        widget.target.photo=usersMap2!['photo'];
        widget.target.devicetoken=usersMap2!['devicetoken'];
        widget.target.gender=usersMap2!['gender'];
        widget.target.bio=usersMap2!['bio'];
        widget.target.coin=usersMap2!['coin'];
      });
    }
  }
  void sendMassege()async{
    try {
      final id = DateTime.now().toString();
      String idd = "$id-$chatroomID";
      await _firestore.collection('chat').doc(idd).set({
        'chatroom': chatroomID,
        'sender': widget.source.email,
        'type': 'msg',
        'time': DateTime.now().toString().substring(10, 16),
        'msg': msg,
        'seen': "false",
        "delete1": "false",
        "delete2": "false"
      });
      print(msg);
      print('Target =${widget.target.devicetoken}');
      sendNotification(
          widget.target.devicetoken,
          widget.source.name,
          msg
      );
      print("Massege Send");
    }
    catch(e){
      print(e);
    }
  }
  Future<void> sendNotification(String deviceToken, String title, String body) async {

    String serverKey = 'AAAAo-47Z9o:APA91bGtyEtGyWDb14CG3tZ1qngfbOowpx5nm-3UrTbWkf62BJeadhI9T9_zLQqMn5AKKpXir_U5D7wRFpg52MIamFA9x2oHsIc-1_W3Tbu8rNm7VDmCoLghNDydQPAgutZZ2vrN8wwt';
    String url = 'https://fcm.googleapis.com/fcm/send';
    // Create the JSON payload for the notification
    Map<String, dynamic> notification = {
      'title': title,
      'body': body,
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    };
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'message': body,
      'action': 'view',
    };
    Map<String, dynamic> payload = {
      'notification': notification,
      'data': data,
      'to': deviceToken
    };

    // Send the HTTP request
    await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(payload),
    );
  }
  void update()async{
    try{
      // String id = "${widget.source.email}${widget.target.email}";
      // final docRef=_firestore.collection('contact').doc(id);
      // final updates = <String, dynamic>{
      //   "seen": "true",
      // };
      // docRef.update(updates);
      // id = "${widget.target.email}${widget.source.email}";
      // final docRef2=_firestore.collection('contact').doc(id);
      // final updates2 = <String, dynamic>{
      //   "seen": "true",
      // };
      // docRef2.update(updates2);
    }
    catch(e){
      print(e);
    }
  }
  void UpdateSeen(MessageModel msg) async {
    try {
      final docRef = _firestore.collection("chat").doc(msg.id);
      final updates = <String, dynamic>{
        "seen": "true",
      };
      docRef.update(updates);
      print("Update Seen");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var IsRecording = recordMethod.isRecording;
    recordMethod.useremail = widget.source.email;
    recordMethod.target = widget.target.email;
    recordMethod.isGroup = false;
    void checkCoins()async{
      int coins=int.parse(widget.source.coin);
      String id="";
      if(coins>6){
        setState(() {
          coins=coins-6;
        });
        await _firestore.collection('user').where('email',isEqualTo: widget.source.email).get().then((value){
          id=value.docs[0].id;
        });
        try{
          final docRef = _firestore.collection("user").doc(id);
          final updates = <String, dynamic>{
            "coin": coins.toString(),
          };
          docRef.update(updates);
        }
        catch(e){
          print(e);
        }
        sendMassege();
      }
      else{
        return showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text('خطاء'),
                  content: Text("لا تملك عملات كافية لارسال اي رسائل برجاء الشحن"),
                  icon:ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("اغلاق"),
                  )

              );
            }
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF21BFBD),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.target.photo!=""?CircleAvatar(
              radius: 19,
              backgroundImage: NetworkImage(widget.target.photo),
            ):CircleAvatar(
              radius: 19,
              backgroundImage: AssetImage("assets/user.jpeg"),
            ),
            SizedBox(width: 5,),
            Text(widget.target.name)
          ],
        ),
        actions: [
          Icon(Icons.currency_bitcoin,color: Colors.yellow,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.source.coin,style: TextStyle(fontSize: 25),)
            ],
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 160,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('chat').where('chatroom', isEqualTo: chatroomID).snapshots(),
                builder: (context,snapshot){
                  List<MessageModel> massegeWidget = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final masseges = snapshot.data?.docs;
                  for (var massege in masseges!.reversed) {
                    final massegeText = massege.get('msg');
                    final massegetype = massege.get('type');
                    final massegetime = massege.get('time');
                    final sender = massege.get('sender');
                    final seen = massege.get('seen');
                    final MessageModel massegeWidgetdata = MessageModel(
                        massegeText, massegetype, massegetime);
                    if (sender == widget.source.email) {
                      massegeWidgetdata.type = "source";
                    } else {
                      massegeWidgetdata.type = "destination";
                    }
                    massegeWidgetdata.typemsg = massegetype;
                    massegeWidgetdata.id = massege.id;
                    massegeWidgetdata.seen = seen;
                    massegeWidget.add(massegeWidgetdata);
                  }
                  return ListView.builder(
                    itemCount: massegeWidget.length,
                      reverse: true,
                      itemBuilder: (context,index){
                        if(massegeWidget[index].typemsg=="msg"){
                          if (massegeWidget[index].type == "source") {
                            return OwnMSG(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                massegeWidget[index].id,
                                false,
                                massegeWidget[index].seen);
                          } else {
                            if (massegeWidget[index].seen == "false") {
                              UpdateSeen(massegeWidget[index]);
                            }
                            return ReplyCard(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                false,
                                "",
                                massegeWidget[index].id);
                          }
                        }
                        else if (massegeWidget[index].typemsg ==
                            "photo") {
                          if (massegeWidget[index].type == "source") {
                            return OwnFileCard(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                "photo",
                                "",
                                false,
                                massegeWidget[index].id);
                          } else {
                            if (massegeWidget[index].seen == "false") {
                              UpdateSeen(massegeWidget[index]);
                            }
                            return ReplayFileCard(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                "photo",
                                "");
                          }
                        } else if (massegeWidget[index].typemsg ==
                            "vedio") {
                          if (massegeWidget[index].type == "source") {
                            return OwnVedioCard(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                "vedio",
                                false,
                                massegeWidget[index].id);
                          } else {
                            if (massegeWidget[index].seen == "false") {
                              UpdateSeen(massegeWidget[index]);
                            }
                            return ReplayVedioCard(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                "vedio");
                          }
                        }
                        else if (massegeWidget[index].typemsg ==
                            "record") {
                          if (massegeWidget[index].type == "source") {
                            return OwnAudio(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                "record",
                                widget.source.photo,
                                false,
                                massegeWidget[index].id);
                          } else {
                            if (massegeWidget[index].seen == "false") {
                              UpdateSeen(massegeWidget[index]);
                            }
                            return ReplayAudio(
                                massegeWidget[index].message,
                                massegeWidget[index].time,
                                "record",
                                widget.target.photo);
                          }
                        }
                        else{
                          return Text("");
                        }
                  }
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 55,
                    child: Card(
                      margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        controller: _controller,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (value){
                          setState(() {
                            if (value == null) {
                              type = false;
                            } else if (value == "") {
                              type = false;
                            } else {
                              type = true;
                            }
                            msg = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "اكتب الرسالة هنا",

                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        backgroundColor:
                                        Colors.transparent,
                                        context: context,
                                        builder: (builder) =>
                                            bottomSheet());
                                  },
                                  icon: Icon(Icons.attach_file)),
                            ],
                          ),
                            contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                  type
                      ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, right: 3, left: 2),
                    child: CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () {
                          checkCoins();
                          setState(() {
                            type = false;
                            _controller.clear();
                          });
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, right: 3, left: 2),
                    child: CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () async {
                          await recordMethod.toggleRecording();
                          recordMethod.ChatRoomID = chatroomID;
                          setState(() {
                            IsRecording = recordMethod.isRecording;
                          });
                        },
                        icon: IsRecording
                            ? Icon(
                          Icons.stop_circle,
                          color: Colors.red,
                        )
                            : Icon(Icons.mic_none),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: _controller,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (defaultTargetPlatform ==
                                TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text(
                          'No Recents',
                          style:
                          TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        loadingIndicator: const SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                        checkPlatformCompatibility: true,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget bottomSheet() {
    return Container(
      height: 162,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.video_library, "فيديوهات", Colors.redAccent),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.photo, "صور", Colors.pinkAccent),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData ics, String Name, Color cs) {
    return InkWell(
      onTap: () async {
        if (Name == "صور") {
          getImage(ImageSource.gallery, widget.source.email, widget.target.email);
        }
        if (Name == "فيديوهات") {
          getVedioSend(
              ImageSource.gallery, widget.source.email, widget.target.email);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(
              ics,
              size: 29,
            ),
            backgroundColor: cs,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            Name,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
  Future getImage(ImageSource media, String sourceId, String targetId) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      _showspinner = true;
      image = img;
    });
    final path = "chat/photos/${image!.name}";
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : ${urlDownload}");
    final id = DateTime.now().toString();
    String idd = "$id-$sourceId";
    print("Massege Send");
    await _firestore.collection('chat').doc(idd).set({
      'chatroom': chatroomID,
      'sender': widget.source.email,
      'type': 'photo',
      'time': DateTime.now().toString().substring(10, 16),
      'msg': urlDownload,
      'seen': "false",
    });
    setState(() {
      Navigator.pop(context);
      _showspinner = false;
    });
    sendNotification(
        widget.target.devicetoken,
        widget.source.name,
        image!.name
    );
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
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');

      if (message.notification != null && message.notification!.title != null && message.notification!.body != null) {
        print('Message also contained a notification: ${message.notification}');
      }

    });
    await for(var massege in FirebaseMessaging.onMessage){
      print('Got a message whilst in the foreground!');
      print('Message data: ${massege.data}');
      if (massege.notification != null && massege.notification!.title != null && massege.notification!.body != null) {
        print('Message also contained a notification: ${massege.notification}');
        showNotification(massege.notification!.title!, massege.notification!.body!);
      }
    }
  }
  Future<void> showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
      'channelId', 'channelName', 'channelDescription',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker',);
    var iosDetails = IOSNotificationDetails();
    var platformDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformDetails,
        payload: 'item x');
  }
  Future getVedioSend(
      ImageSource media, String sourceId, String targetId) async {
    var img = await picker.pickVideo(source: media);
    setState(() {
      _showspinner = true;
      image = img;
    });
    final path = "chat/vedios/${image!.name}";
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link : ${urlDownload}");
    final id = DateTime.now().toString();
    String idd = "$id-$sourceId";
    print("Massege Send");
    await _firestore.collection('chat').doc(idd).set({
      'chatroom': chatroomID,
      'sender': widget.source.email,
      'type': 'vedio',
      'time': DateTime.now().toString().substring(10, 16),
      'msg': urlDownload,
      'seen': "false",
    });
    setState(() {
      Navigator.pop(context);
      _showspinner = false;
    });
    sendNotification(
        widget.target.devicetoken,
        widget.source.name,
        image!.name
    );
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    audioPlayer.stop();
  }
  void sendcallAudio() async {
    try {
      final id = DateTime.now().toString();
      String idd = "$id-${widget.source.email}";
      await _firestore.collection("callhistory").doc(idd).set({
        'profileIMG': widget.target.photo,
        'time': DateTime.now().toString().substring(10, 16),
        'myemail': widget.source.email,
        'mycontactemail': widget.target.email,
        'type': 'audiocall',
        'sendtype': 'outline',
        'mycontactname': widget.target.name,
        'callid': chatroomID,
      });
    } catch (e) {
      print(e);
    }
    try {
      final id = DateTime.now().toString();
      String idd = "$id-${widget.target.email}";
      await _firestore.collection("callhistory").doc(idd).set({
        'profileIMG': widget.source.photo,
        'time': DateTime.now().toString().substring(10, 16),
        'myemail': widget.target.email,
        'mycontactemail': widget.source.email,
        'type': 'audiocall',
        'sendtype': 'incoming',
        'mycontactname': widget.source.name,
        'callid': chatroomID,
      });
    } catch (e) {
      print(e);
    }
  }

}