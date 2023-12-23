import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/Utils/app_colors.dart';

class OwnMassege extends StatelessWidget{
  String msg;
  String date;
  String id;
  bool group;
  String seen;
  OwnMassege(this.msg,this.date,this.id,this.group,this.seen, {super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(30),
                bottomEnd: Radius.circular(30),
                bottomStart: Radius.circular(30)
              ),
              gradient: LinearGradient(
                colors: [AppColors.app3MainColor, AppColors.appMainColor],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 80,
                    top: 9,
                    bottom: 20,
                  ),
                  child: InkWell(
                    child: Text(
                      msg,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.done_all_rounded,
                        color: seen == "false" ? Colors.grey : Colors.blue,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}