import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/profile/widgets/visitor_profile.dart';
import 'package:hayaa_main/models/firends_model.dart';


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
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => VisitorProfile(searchfriends[index])));
                              },
                              leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(searchfriends[index].photo),),
                              title: Text(searchfriends[index].name),
                              subtitle: Text(searchfriends[index].bio),
                              trailing: ElevatedButton(onPressed: ()async{
                                await _firestore.collection('friendreq').doc().set({
                                  'sender':myID,
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