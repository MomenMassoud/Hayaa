import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/models/store_model.dart';

class WallpaperStore extends StatefulWidget {
  _WallpaperStore createState() => _WallpaperStore();
}

class _WallpaperStore extends State<WallpaperStore> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int coins=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoins();
  }
  void getCoins()async{
    await for(var snap in _firestore.collection('user').doc(_auth.currentUser!.uid).snapshots()){
      setState(() {
        coins = int.parse(snap.get('coin'));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('store')
            .where('cat', isEqualTo: 'wallpaper')
            .snapshots(),
        builder: (context, snapshot) {
          List<StoreModel> store=[];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            store.add(
              StoreModel(massege.get('photo'), massege.get('type'), massege.id, massege.get('price'), massege.get('time'), massege.get('cat'))
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 18.0,right: 10,left: 10),
            child:store.length>0? GridView.builder(
                itemCount: store.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context,index){
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mylook').where('id',isEqualTo: store[index].docID).snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData) {
                        return _buildCard('${store[index].price}',store[index].photo,store[index].cat,store[index].time,context,false,store[index].docID,store[index].price);
                      }
                      final masseges = snapshot.data?.docs;
                      if(masseges!.isEmpty){
                        return _buildCard('${store[index].price}',store[index].photo,store[index].cat,store[index].time,context,false,store[index].docID,store[index].price);
                      }
                      else{
                        return _buildCard(' ${store[index].price}',store[index].photo,store[index].cat,store[index].time,context,true,store[index].docID,store[index].price);
                      }
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
  Widget _buildCard(String price, String imgPath, String category, String days, BuildContext context, bool buy, String id, String pp) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          // Add your onTap logic here
        },
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
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
                    days == "always" ? days : "$days Day",
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
                Hero(
                  tag: imgPath,
                  child: Container(
                    height: 75.0,
                    width: 75.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imgPath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 7.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: Color(0xFFCC8053),
                        fontFamily: 'Varela',
                        fontSize: 14.0,
                      ),

                    ),
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: AssetImage(AppImages.gold_coin),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    color: Color(0xFFEBEBEB),
                    height: 1.0,
                  ),
                ),
                // Add the button and days here
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        bool always = false;
                        if (days == "always") {
                          always = true;
                        }
                        Allarm(id, imgPath, days, always,
                            DateTime.now().toString(), pp);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade300,
                        onPrimary: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    // You can replace '30 Days' with your desired text
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void Allarm(String id,String path,String dead,bool always,String time,String price) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("سوف تقوم بشراء هذا العنصر هل انت متاكد"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        if(coins>=int.parse(price)){
                          await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mylook').doc(id).set({
                            'photo':path,
                            'id':id,
                            'dead':dead,
                            'always':always.toString(),
                            'cat':'wallpaper',
                            'time':DateTime.now().toString(),
                          }).then((value){
                            Navigator.pop(context);
                            SendDone();
                          });
                        }
                        else{
                          Navigator.pop(context);
                          NotSend();
                        }
                      }, child: Text("شراء")),
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("الغاء")),
                    ],
                  )
                ],
              )
          );
        });
  }
  void SendDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("مبروك"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("تم شراء العنصر بنجاح"),
                ),
              )
          );
        });
  }
  void NotSend() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ناسف"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("ناسف برجاء لا تملك عملات كافية"),
                ),
              )
          );
        });
  }
}
