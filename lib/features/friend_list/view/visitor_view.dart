import 'package:flutter/material.dart';

import '../widget/visitor_body.dart';



class VisitorView extends StatefulWidget{
  static const id = 'VisitorView';
  const VisitorView({super.key});
  _VisitorView createState()=>_VisitorView();
}

class _VisitorView extends State<VisitorView>{
  @override
  Widget build(BuildContext context) {
    return VisitorBody();
  }

}