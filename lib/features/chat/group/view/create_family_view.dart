import 'package:flutter/material.dart';
import 'package:hayaa_main/features/chat/widget/group/family_rank_list/create_family_body.dart';

class CreateFamilyView extends StatefulWidget{
  static const id = 'CreateFamilyView';
  const CreateFamilyView({super.key});
  _CreateFamilyView createState()=>_CreateFamilyView();
}


class _CreateFamilyView extends State<CreateFamilyView>{
  @override
  Widget build(BuildContext context) {
    return CreateFamilyBody();
  }

}