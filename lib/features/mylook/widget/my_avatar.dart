import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';
import '../../../models/store_model.dart';


class MyAvatar extends StatefulWidget{
  _MyAvatar createState()=>_MyAvatar();
}

class _MyAvatar extends State<MyAvatar>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDead();
  }
  void checkDead()async{
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mylook').where('cat',isEqualTo: 'frame').snapshots()){
      DateTime BuyTime = DateTime.parse(snap.docs[0].get('time'));
      int day=int.parse(snap.docs[0].get('dead'));
      String id=snap.docs[0].get('id');
      day=BuyTime.day.toInt()+day;
      DateTime now=DateTime.now();
      BuyTime =DateTime(BuyTime.year,BuyTime.month,day,BuyTime.hour,BuyTime.minute,BuyTime.second,BuyTime.millisecond,BuyTime.microsecond);
      if(now.isAfter(BuyTime)){
        _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mylook').doc(id).delete().then((value){
          print("Expire");
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .doc(_auth.currentUser!.uid)
            .collection('mylook').where('cat',isEqualTo: 'frame')
            .snapshots(),
        builder: (context, snapshot) {
          List<String> mylookID = [];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            mylookID.add(massege.get('id'));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 18.0,right: 10,left: 10),
            child: mylookID.length>0?GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: mylookID.length,
                itemBuilder: (context,index){
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('store')
                        .where('id', isEqualTo: mylookID[index])
                        .snapshots(),
                    builder: (context,snapshot){
                      late StoreModel store;
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed) {
                        store=
                            StoreModel(massege.get('photo'), massege.get('type'), massege.id, massege.get('price'), massege.get('time'), massege.get('cat'))
                        ;
                      }
                      return _buildCard('\$ ${store.price}',store.photo,store.cat,store.time,context,true,store.docID,store.price,store.type,store);
                    },
                  );
                }
            ):Center(
              child: Text("لا يوجد بيانات"),
            ),
          );
        },
      ),
    );
  }
  Widget _buildCard(String price, String imgPath, String category, String days, BuildContext context, bool buy, String id, String pp, String type, StoreModel ss) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          // Add your onTap logic here
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
              type == "svga"
                  ? CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                child: SVGASimpleImage(
                  resUrl: imgPath,
                ),
              )
                  : CachedNetworkImage(
                imageUrl: imgPath,
                width: 50,
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  color: Color(0xFFEBEBEB),
                  height: 1.0,
                ),
              ),
              // Add the button and days here
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                        'myframe':id
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'ارتداء',
                      style: TextStyle(
                        fontSize: 16, // Set the font size of the text
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
