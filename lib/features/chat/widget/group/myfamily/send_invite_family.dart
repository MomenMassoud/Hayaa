import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/Utils/app_images.dart';
import '../../../../../models/firends_model.dart';


class SendInviteFamily extends StatefulWidget{
  String family;
  SendInviteFamily(this.family);
  _SendInviteFamily createState()=>_SendInviteFamily();
}

class _SendInviteFamily extends State<SendInviteFamily>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  TextEditingController _searchController = TextEditingController();
  String value="";
  String myID="";
  String myName="";
  String myPhoto="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  void getUser()async{
    await _firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.email).get().then((value){
      setState(() {
        myID=value.docs[0].get('id');
        myName=value.docs[0].get('name');
        myPhoto=value.docs[0].get('photo');
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.family6))
        ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
            title: Text("ارسال دعوة",style: TextStyle(color: Colors.white),),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث باستخدام ID'.tr(args: ['بحث باستخدام ID']),
                    hintStyle: TextStyle(color: Colors.white)
                  ),
                  onChanged: performSearch,
                  style: TextStyle(color: Colors.white),
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
                        if(massege.get('myfamily')==''){
                          searchfriends.add(friend);
                        }
                      }
                    }
                    return searchfriends.length==0?Text("لا توجد بيانات للعرض").tr(args: ['لا توجد بيانات للعرض']):
                    ListView.builder(
                        itemCount: searchfriends.length,
                        itemBuilder: (context,index){
                          if(searchfriends[index].id==myID){
                            return Text("");
                          }
                          else{
                            return ListTile(
                              leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(searchfriends[index].photo),),
                              title: Text(searchfriends[index].name,style: TextStyle(color: Colors.white),),
                              subtitle: Text(searchfriends[index].bio,style: TextStyle(color: Colors.white)),
                              trailing: ElevatedButton(onPressed: ()async{
                                await _firestore.collection('user').doc(searchfriends[index].docID).collection('invite').doc().set({
                                  'sender':myID,
                                  'msg':"User  ${searchfriends[index].name} Send you  Request to join in Family",
                                  'type':"family",
                                  'time':DateTime.now().toString(),
                                  'senderName':myName,
                                  'senderPhoto':myPhoto,
                                  'agent':widget.family
                                });
                                Navigator.pop(context);
                              }, child: Text("اراسل دعوة").tr(args: ['اراسل دعوة'])),
                            );
                          }
                        }
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
  void performSearch(String searchTerm) {
    // Add your search logic here
    print('Searching for: $searchTerm');
    setState(() {
      value=searchTerm;
    });
  }

}