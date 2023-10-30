import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:iconnect2/Model/ChatModel.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DiamondScreen extends StatefulWidget {
  @override
  _DiamondScreenState createState() => _DiamondScreenState();
}
chatmodel user=chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
class _DiamondScreenState extends State<DiamondScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();

  }
  void getUser() async{
    Map<String, dynamic>? usersMap2;
    await for(var snapshots in _firestore.collection('user').where('email',isEqualTo: _auth.currentUser?.email).snapshots()){
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        user.email=usersMap2!['email'];
        user.name=usersMap2!['name'];
        user.photo=usersMap2!['photo'];
        user.devicetoken=usersMap2!['devicetoken'];
        user.gender=usersMap2!['gender'];
        user.bio=usersMap2!['bio'];
        user.coin=usersMap2!['coin'];
        user.id=snapshots.docs[0].id;
      });
    }
    setDeviceToken();
  }
  void setDeviceToken()async{
    try{

      String id="";
      await _firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.email).get().then((value){
        id = value.docs[0].id;
      });
      fcm.getToken().then((value){
        final docRef = _firestore.collection("user").doc(id);
        final updates = <String, dynamic>{
          "devicetoken":value,
        };
        user.devicetoken=value.toString();
        docRef.update(updates);
        print('Update Token \n new Token is $value');
      });
    }
    catch(e){
      print(e);
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamonds'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DiamondButton(300, Icons.star, 1 ,user.coin ,user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DiamondButton(600, Icons.star, 2,user.coin ,user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DiamondButton(1200, Icons.star, 4,user.coin,user.email),
            ),
          ],
        ),
      ),
    );
  }
}

class DiamondButton extends StatelessWidget {
  final int diamondCount;
  final IconData iconData;
  final int totalMultiplier;
  final String oldcoin, email;


  DiamondButton(this.diamondCount, this.iconData, this.totalMultiplier,this.oldcoin ,this.email);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Calculate the total based on the entered diamond count and multiplier.
        final int total = diamondCount + totalMultiplier;

        print('$diamondCount Diamonds - Total: $total');

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
                  "total": totalMultiplier.toString(),
                  "currency": "USD",
                  "details": {
                    "subtotal": totalMultiplier.toString(),
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
                      "price": totalMultiplier.toString(),
                      "currency": "USD",
                    },
                  ],
                },
              },
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              print(".................onSuccess...............");
              int oldCoin = int.parse(oldcoin);
              final int updatedCoin = oldCoin + total;
              print("...old dimaond user is $oldcoin ...dimond in chrage is $diamondCount..........final user dimond is $updatedCoin............");
              final docRef = _firestore.collection("user").doc(user.id);
              final updates = <String, dynamic>{
                "coin":updatedCoin.toString(),
              };
              user.coin=updatedCoin.toString();
              docRef.update(updates);

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

      icon: Icon(iconData),
      label: Text('$diamondCount Diamonds'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 18),
        minimumSize: Size(200, 50),
      ),
    );
  }
}
