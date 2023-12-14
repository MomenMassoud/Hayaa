import 'package:flutter/material.dart';

import '../../widget/group/family_body.dart';


class FamilyView extends StatefulWidget{
  static const id = 'FamilyView';
  const FamilyView({super.key});
  _FamilyView createState()=>_FamilyView();
}

class _FamilyView extends State<FamilyView>{
  @override
  Widget build(BuildContext context) {
    return FamilyBody();
  }

}