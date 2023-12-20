import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';
import 'package:hayaa_main/features/agencies/models/agency_model.dart';
import 'package:hayaa_main/features/agencies/views/agency_creation_view.dart';
import 'package:hayaa_main/features/agencies/widgets/agencies_list_item.dart';

import '../../../models/agency_model.dart';

class AgencyJoiningViewBody extends StatefulWidget {
  const AgencyJoiningViewBody({
    super.key,
  });

  @override
  State<AgencyJoiningViewBody> createState() => _AgencyJoiningViewBodyState();
}

class _AgencyJoiningViewBodyState extends State<AgencyJoiningViewBody> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  List<AgencyModel> agencies = [];
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Choose Agency",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('agency').snapshots(),
        builder: (context,snapshot){
          List<AgencyModelS> agency=[];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            agency.add(
              AgencyModelS(massege.id, massege.get('name'), massege.get('photo'), massege.get('bio'))
            );
          }
          return ListView.builder(
            itemCount: agency.length,
            itemBuilder: (context,index){
              if(index==0){
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AgencyCreationView.id);
                        },
                        child: const Text("Create Agency",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AgenciesListItem(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            agencyModel: agency[index])
                    )
                  ],
                );
              }
              else{
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AgenciesListItem(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        agencyModel: agency[index])
                );
              }
            },
          );
        },
      )
    );
  }
}
