import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_colors.dart';
import '../../../models/firends_model.dart';
import '../../profile/widgets/visitor_profile.dart';

class AddHost extends StatefulWidget{
  String id;
  AddHost(this.id);
  _AddHost createState()=>_AddHost();
}

class _AddHost extends State<AddHost>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: screenHeight * 0.12,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text("اضافة مضيف جديد").tr(args: ['اضافة مضيف جديد']),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث باستخدام ID'.tr(args: ['بحث باستخدام ID']),
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
                    if(massege.get('type')=='normal'){
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
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => VisitorProfile(searchfriends[index])));
                          },
                          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(searchfriends[index].photo),),
                          title: Text(searchfriends[index].name),
                          subtitle: Text(searchfriends[index].bio),
                          trailing: ElevatedButton(onPressed: ()async{
                            await _firestore.collection('user').doc(searchfriends[index].docID).collection('invite').doc().set({
                              'sender':myID,
                              'msg':"User  ${searchfriends[index].name} Send you  Request to join in Agent",
                              'type':"request",
                              'time':DateTime.now().toString(),
                              'senderName':myName,
                              'senderPhoto':myPhoto,
                              'agent':widget.id
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