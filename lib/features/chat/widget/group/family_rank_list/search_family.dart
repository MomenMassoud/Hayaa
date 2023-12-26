import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../core/Utils/app_images.dart';
import '../../../../../models/family_model.dart';
import '../myfamily/my_family_body.dart';

class SearchFamily extends StatefulWidget{
  static const id="SearchFamily";
  _SearchFamily createState()=>_SearchFamily();
}


class _SearchFamily extends State<SearchFamily>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  String value="";
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
          title: Text("Search Family",style: TextStyle(color: Colors.white),),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp,color: Colors.white,)),
          backgroundColor: Colors.transparent,
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
                  hintText: 'Search by ID',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: performSearch,
              ),
            ),
            Container(
              height: 500,
              child: StreamBuilder<QuerySnapshot>(
                stream:_firestore.collection('family').where('idd',isGreaterThanOrEqualTo:value).where('idd',isLessThanOrEqualTo: value + '\uf8ff').snapshots(),
                builder: (context,snapshot){
                  List<FamilyModel> familys=[];
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final masseges = snapshot.data?.docs;
                  for (var massege in masseges!.reversed) {
                    final fm=FamilyModel(massege.get('name'), massege.get('idd'), massege.id, massege.get('bio'), massege.get('join'), massege.get('photo'));
                    familys.add(fm);
                  }
                  return familys.length==0?Text("No Data Found"):
                  ListView.builder(
                      itemCount: familys.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(familys[index].photo),),
                          title: Text(familys[index].name,style: TextStyle(color: Colors.white),),
                          subtitle: Text(familys[index].bio,style: TextStyle(color: Colors.white),),
                          trailing: ElevatedButton(onPressed: ()async{
                            if(familys[index].join=="close"){
                              await _firestore.collection('family').doc(familys[index].doc).collection('req').doc(_auth.currentUser!.uid).set({
                                'id':_auth.currentUser!.uid,
                                'name':_auth.currentUser!.displayName,
                                'photo':_auth.currentUser!.photoURL.toString()
                              }).then((value){
                                Navigator.pop(context);
                              });
                            }
                            else{
                              await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                                'myfamily':familys[index].doc,
                              }).then((value){
                                _firestore.collection('family').doc(familys[index].doc).collection('user').doc().set({
                                  'type':'member',
                                  'user':_auth.currentUser!.uid,
                                }).then((value){
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, MyFamilyBody.id);
                                });
                              });
                            }
                          }, child: Text("Join")),
                        );
                      }
                  );
                },
              ),
            ),
          ],
        ),
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