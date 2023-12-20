import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_colors.dart';
import 'package:hayaa_main/models/agency_model.dart';

class AgenciesListItem extends StatelessWidget {
   AgenciesListItem({super.key, required this.screenWidth, required this.screenHeight, required this.agencyModel});
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final double screenWidth;
  final double screenHeight;
  final AgencyModelS agencyModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.1,
      decoration: const BoxDecoration(),
      child: Center(
          child: Row(
        children: [
          Container(
            width: screenWidth * 0.2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(agencyModel.photo))),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                agencyModel.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.app3MainColor),
              onPressed: () async{
                await _firestore.collection('agency').doc(agencyModel.doc).collection('req').doc().set({
                  'name':_auth.currentUser!.displayName.toString(),
                  'photo':_auth.currentUser!.photoURL.toString(),
                  'doc':_auth.currentUser!.uid,
                });
                Navigator.pop(context);
              },
              child:  Text(
                "انضمام",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ).tr(args: ['انضمام']))
        ],
      )),
    );
  }
}
