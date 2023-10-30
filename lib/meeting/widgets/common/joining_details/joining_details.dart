import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';

import '../../../constants/colors.dart';
import '../../../utils/toast.dart';

class JoiningDetails extends StatefulWidget {
  final bool isCreateMeeting;
  final Function onClickMeetingJoin;

  const JoiningDetails(
      {Key? key,
      required this.isCreateMeeting,
      required this.onClickMeetingJoin})
      : super(key: key);

  @override
  State<JoiningDetails> createState() => _JoiningDetailsState();
}

class _JoiningDetailsState extends State<JoiningDetails> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  String _meetingId = "";
  String _displayName = "kkkkkkk";
  String meetingMode = "GROUP";
  List<String> meetingModes = ["ONE_TO_ONE", "GROUP"];
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  chatmodel user =chatmodel("name", "email", "photo", "bio", "gender", "devicetoken");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }
  void getUser() async {
    Map<String, dynamic>? usersMap2;
    await for (var snapshots in _firestore.collection('user').where('email', isEqualTo: _auth.currentUser?.email).snapshots()) {
      usersMap2 = snapshots.docs[0].data();
      setState(() {
        user.email = usersMap2!['email'];
        user.name = usersMap2!['name'];
        user.photo = usersMap2!['photo'];
        user.devicetoken = usersMap2!['devicetoken'];
        user.gender = usersMap2!['gender'];
        user.bio = usersMap2!['bio'];
        user.coin = usersMap2!['coin'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(12), color: black750),
        //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<String>(
        //       value: meetingMode,
        //       icon: const Icon(Icons.arrow_drop_down),
        //       elevation: 16,
        //       style: const TextStyle(
        //         fontWeight: FontWeight.w500,
        //       ),
        //       onChanged: (String? value) {
        //         setState(() {
        //           meetingMode = value!;
        //         });
        //       },
        //       borderRadius: BorderRadius.circular(12),
        //       dropdownColor: black750,
        //       alignment: AlignmentDirectional.centerStart,
        //       isExpanded: true,
        //       items: meetingModes.map<DropdownMenuItem<String>>((String value) {
        //         return DropdownMenuItem<String>(
        //           value: value,
        //           child: Center(
        //             child: Text(
        //               value == "GROUP" ? "Group Call" : "One to One Call",
        //               textAlign: TextAlign.center,
        //             ),
        //           ),
        //         );
        //       }).toList(),
        //     ),
        //   ),
        // ),
        // const VerticalSpacer(16),
        if (!widget.isCreateMeeting)
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: black750),
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
              onChanged: ((value) => _meetingId = value),
              decoration: const InputDecoration(
                  hintText: "Enter meeting code",
                  hintStyle: TextStyle(
                    color: textGray,
                  ),
                  border: InputBorder.none),
            ),
          ),
        // if (!widget.isCreateMeeting) const VerticalSpacer(16),
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(12), color: black750),
        //   child: TextField(
        //     textAlign: TextAlign.center,
        //     style: const TextStyle(
        //       fontWeight: FontWeight.w500,
        //     ),
        //     onChanged: ((value) => _displayName = value),
        //     decoration: const InputDecoration(
        //         hintText: "Enter your name",
        //         hintStyle: TextStyle(
        //           color: textGray,
        //         ),
        //         border: InputBorder.none),
        //   ),
        // ),
        // const VerticalSpacer(16),
        MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: purple,
            child: const Text("Create New Meeting", style: TextStyle(fontSize: 16)),
            onPressed: () {
              setState(() {

                _displayName=user.name;
                print("new Name $_displayName");
              });
              if (_displayName.trim().isEmpty) {
                showSnackBarMessage(
                    message: "Please enter name", context: context);
                return;
              }
              if (!widget.isCreateMeeting && _meetingId.trim().isEmpty) {
                showSnackBarMessage(
                    message: "Please enter meeting id", context: context);
                return;
              }
              widget.onClickMeetingJoin(
                  _meetingId.trim(), meetingMode, _displayName.trim());
            }),
      ],
    );
  }
}
