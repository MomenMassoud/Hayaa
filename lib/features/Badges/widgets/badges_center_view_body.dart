import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'activity_tab.dart';
import 'badges_done.dart';

class BadgesCenterViewBody extends StatefulWidget {
  const BadgesCenterViewBody({
    super.key,
  });

  @override
  State<BadgesCenterViewBody> createState() => _BadgesCenterViewBodyState();
}

class _BadgesCenterViewBodyState extends State<BadgesCenterViewBody> {
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseFirestore _firestore2=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyBadges();
  }
  void getMyBadges()async{
    List<String> docs=[];
    List<int> counts=[];
    List<bool> dones=[];
   await _firestore.collection('badges').get().then((value){
     for(int i=0;i<value.size;i++){
       docs.add(value.docs[i].id);
       counts.add(int.parse(value.docs[i].get('count')));
     }
   }).then((value){
     _firestore.collection('user').doc(_auth.currentUser!.uid).collection('sendgift').get().then((value){
       for(int i=0;i<docs.length;i++){
         int c=0;
         for(int j=0;j<value.size;j++){
           if(docs[i]==value.docs[j].get('giftid')){
             c++;
           }
         }
         if(c==counts[i]){
           SetBadge(docs[i]);
         }
       }
     });
   });
  }
  void SetBadge(String id)async{
    await _firestore.collection('user').doc(_auth.currentUser!.uid).collection('mybadges').doc(id).set({
      'id':id
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [
          BadgesDone(),
          const ActivityTab(),
        ]),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          bottom: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white)),
              labelColor: Colors.white,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                  color: Colors.amber[100],
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              tabs: const [
                Tab(
                  text: 'الانجاز',
                ),
                Tab(
                  text: 'النشاط',
                ),
              ]),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            "مركز الشارات",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                    color: Colors.brown[100]),
                child: const Center(
                    child: Text(
                  "ارتداء",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
