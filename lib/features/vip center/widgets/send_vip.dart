import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/firends_model.dart';


class SendVip extends StatefulWidget{
  String vip;
  int vipCoin;
  SendVip(this.vip,this.vipCoin);
  _SendVip createState()=>_SendVip();
}

class _SendVip extends State<SendVip>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  TextEditingController _searchController = TextEditingController();
  String value="";
  String myID="";
  String myName="";
  String myPhoto="";
  int mycoin=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  void getUser()async{
    await _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((value){
      setState(() {
        myID=value.get('id');
        myName=value.get('name');
        myPhoto=value.get('photo');
        mycoin=int.parse(value.get('coin'));
      });
    });
  }
  void performSearch(String searchTerm) {
    // Add your search logic here
    print('Searching for: $searchTerm');
    setState(() {
      value=searchTerm;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ID',
              ),
              onChanged: performSearch,
            ),
          ),
          Container(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream:_firestore.collection('user').where('id',isGreaterThanOrEqualTo:value).where('id',isLessThanOrEqualTo: value + '\uf8ff').snapshots(),
              builder: (context,snapshot){
                List<FriendsModel> searchfriends = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                final masseges = snapshot.data?.docs;
                for (var massege in masseges!.reversed) {
                  String em=massege.get('id');
                  if(em==myID){

                  }
                  else{
                    FriendsModel friend=FriendsModel(
                        massege.get('email'), massege.get('id'), massege.id,massege.get('photo'), massege.get('name'),
                        massege.get('phonenumber'), massege.get('gender'));
                    friend.bio=massege.get('bio');
                    searchfriends.add(friend);
                  }
                }
                return searchfriends.length==0?Text("No Data Found"):
                ListView.builder(
                    itemCount: searchfriends.length,
                    itemBuilder: (context,index){
                      if(searchfriends[index].id==myID){
                        return Text("");
                      }
                      else{
                        return ListTile(
                          onTap: (){
                            Allarm(searchfriends[index]);
                          },
                          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(searchfriends[index].photo),),
                          title: Text(searchfriends[index].name),
                          subtitle: Text(searchfriends[index].bio),
                          trailing: ElevatedButton(onPressed: (){
                            Allarm(searchfriends[index]);
                          }, child: Text("Send")),
                        );
                      }
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void Allarm(FriendsModel friend) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("سوف تقوم ارسال هذا العنصر هل انت متاكد"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        DateTime now=DateTime.now();
                        int month=now.month+1;
                        DateTime end=DateTime(now.year,month,now.day,now.hour,now.minute,now.second,now.millisecond,now.microsecond);
                        if(mycoin>=widget.vipCoin){
                          int newcoin=mycoin-widget.vipCoin;
                          _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                            'coin':newcoin.toString()
                          }).then((value){
                            _firestore.collection('user').doc(_auth.currentUser!.uid).collection('payment').doc().set({
                              'bio':'send ${widget.vip} to ${friend.name}',
                              'date':DateTime.now().toString(),
                              'pay':'out',
                              'type':'coin',
                              'value':widget.vipCoin.toString(),
                            }).then((value){
                              _firestore.collection('user').doc(friend.docID).update({
                                'vip':widget.vip,
                                'vip_end':end.toString(),
                              }).then((value){
                                SendDone();
                              });
                            });
                          });
                        }
                        else{
                          NotSend();
                        }
                      }, child: Text("ارسال")),
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
                  child: Text("تم ارسال العنصر بنجاح"),
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
                  child: Text("ناسف  لا تملك عملات كافية"),
                ),
              )
          );
        });
  }

}