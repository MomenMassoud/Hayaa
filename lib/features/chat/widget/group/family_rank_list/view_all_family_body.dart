import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/features/chat/widget/group/family_rank_list/search_family.dart';
import 'package:hayaa_main/models/family_model.dart';
import '../myfamily/my_family_body.dart';
import 'create_family_body.dart';

class ViewAllFamilyBody extends StatefulWidget{
  static const id="ViewAllFamilyBody";
  _ViewAllFamilyBody createState()=>_ViewAllFamilyBody();
}

class _ViewAllFamilyBody extends State<ViewAllFamilyBody>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(AppImages.family6))),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp,color: Colors.white,)),
          title: Text("العائلات",style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, SearchFamily.id);
            }, icon: Icon(Icons.search,color: Colors.white,)),
            IconButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateFamilyBody()));
            }, icon: Icon(Icons.add,color: Colors.white,))
          ],
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('family').snapshots(),
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
            for (var massege in masseges!.reversed){
              final fm=FamilyModel(massege.get('name'), massege.get('idd'), massege.id, massege.get('bio'), massege.get('join'), massege.get('photo'));
              familys.add(fm);
            }
            return ListView.builder(
                itemCount: familys.length,
                itemBuilder: (context,index){
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('family').doc(familys[index].doc).collection('count').snapshots(),
                    builder: (context,snapshot){
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final masseges = snapshot.data?.docs;
                      for (var massege in masseges!.reversed){
                        familys[index].count+=int.parse(massege.get('coin'));
                      }
                      return ListTile(
                        title: Text("${familys[index].name} - ID:${familys[index].id}",style: TextStyle(color: Colors.white),),
                        subtitle: Text("${familys[index].bio} - ${familys[index].count.toString()} coin",style: TextStyle(color: Colors.white),),
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(familys[index].photo),
                          radius: 30,
                        ),
                        trailing: ElevatedButton(
                          onPressed: ()async{
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
                                  Navigator.pushNamed(context, MyFamilyBody.id);
                                });
                              });
                            }
                          },
                          child: Text("Join",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        )
                      );
                    },
                  );
                }
            );

          },
        ),
      ),
    );
  }

}