import 'package:flutter/material.dart';

import '../widgets/profile_edit_body.dart';



class ProfileEditView extends StatefulWidget{
  const ProfileEditView({super.key});
  static const id = 'ProfileEditView';
  _ProfileEditView createState()=>_ProfileEditView();
}


class _ProfileEditView extends State<ProfileEditView>{
  @override
  Widget build(BuildContext context) {
    return ProfileEditBody();
  }

}