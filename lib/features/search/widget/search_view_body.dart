import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/profile/widgets/visitor_profile.dart';
import 'package:hayaa_main/models/firends_model.dart';

import '../../../core/Utils/app_images.dart';
import '../../profile/views/visitor_.view.dart';


class SearchViewBody extends StatefulWidget{
  _SearchViewBody createState()=>_SearchViewBody();
}

class _SearchViewBody extends State<SearchViewBody>{
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
            height: 350,
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
                        massege.get('vip'), massege.get('level2'));
                    friend.bio=massege.get('level');
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
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => VistorView(searchfriends[index].photo,searchfriends[index].docID)));
                              },
                              leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(searchfriends[index].photo),),
                              title: Text(searchfriends[index].name),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                        int.parse(searchfriends[index].bio)>=1 && int.parse(searchfriends[index].bio)<20?AppImages.wealth1to19:
                                        int.parse(searchfriends[index].bio)>=20 &&int.parse(searchfriends[index].bio)<40?AppImages.wealth20to39:
                                        int.parse(searchfriends[index].bio)>=40 && int.parse(searchfriends[index].bio)<50?AppImages.wealth40to49:
                                        int.parse(searchfriends[index].bio)>=50 && int.parse(searchfriends[index].bio)<60?AppImages.wealth50to59:
                                        int.parse(searchfriends[index].bio)>=60 && int.parse(searchfriends[index].bio)<70?AppImages.wealth60to69:
                                        int.parse(searchfriends[index].bio)>=70 && int.parse(searchfriends[index].bio)<80?AppImages.wealth70to79:
                                        int.parse(searchfriends[index].bio)>=80 && int.parse(searchfriends[index].bio)<90?AppImages.wealth80to89:
                                        int.parse(searchfriends[index].bio)>=90&&int.parse(searchfriends[index].bio)<100?AppImages.wealth90to99:
                                        int.parse(searchfriends[index].bio)>=100 && int.parse(searchfriends[index].bio)<126?AppImages.wealth100to125:
                                        AppImages.wealth126to150
                                    ),
                                    Center(child: Text(searchfriends[index].bio),)
                                  ],
                                ),
                                  Stack(
                                    children: [
                                      Image.asset(
                                          int.parse(searchfriends[index].gender)>=1 && int.parse(searchfriends[index].gender)<20?AppImages.charm1to19:
                                          int.parse(searchfriends[index].gender)>=20 &&int.parse(searchfriends[index].gender)<40?AppImages.charm20to39:
                                          int.parse(searchfriends[index].gender)>=40 && int.parse(searchfriends[index].gender)<50?AppImages.charm40to49:
                                          int.parse(searchfriends[index].gender)>=50 && int.parse(searchfriends[index].gender)<60?AppImages.charm50to59:
                                          int.parse(searchfriends[index].gender)>=60 && int.parse(searchfriends[index].gender)<70?AppImages.charm60to69:
                                          int.parse(searchfriends[index].gender)>=70 && int.parse(searchfriends[index].gender)<80?AppImages.charm70to79:
                                          int.parse(searchfriends[index].gender)>=80 && int.parse(searchfriends[index].gender)<90?AppImages.charm80to89:
                                          int.parse(searchfriends[index].gender)>=90&&int.parse(searchfriends[index].gender)<100?AppImages.charm90to99:
                                          int.parse(searchfriends[index].gender)>=100 && int.parse(searchfriends[index].gender)<126?AppImages.charm100to125:
                                          AppImages.charm126to150
                                      ),
                                      Center(child: Text(searchfriends[index].gender),)
                                    ],
                                  ),
                                  int.parse(searchfriends[index].phonenumber)!=0?Stack(
                                    children: [
                                      Image.asset(
                                          int.parse(searchfriends[index].phonenumber)==1?AppImages.VIP1Badge:
                                          int.parse(searchfriends[index].phonenumber)==2 ?AppImages.VIP2Badge:
                                          int.parse(searchfriends[index].phonenumber)==3 ?AppImages.VIP3Badge:
                                          AppImages.VIP4Badge
                                      ),
                                      Center(child: Text(searchfriends[index].phonenumber),)
                                    ],
                                  ):Container(),
                                ],
                              ),
                              trailing: ElevatedButton(onPressed: ()async{
                                await _firestore.collection('friendreq').doc().set({
                                  'sender':_auth.currentUser!.uid,
                                  'owner':searchfriends[index].id,
                                  'msg':"User  ${searchfriends[index].name} Send you Friend Request",
                                  'type':"request",
                                  'time':DateTime.now().toString(),
                                  'senderName':myName,
                                  'senderPhoto':myPhoto,
                                });
                                Navigator.pop(context);
                              }, child: Text("Add Friend")),
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