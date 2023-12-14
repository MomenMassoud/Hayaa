import 'package:flutter/material.dart';

import '../widget/salery_body.dart';


class SaleryView extends StatefulWidget{
  const SaleryView({super.key});
  static const id = 'SaleryView';
  _SaleryView createState()=>_SaleryView();
}

class _SaleryView extends State<SaleryView>{
  @override
  Widget build(BuildContext context) {
    return SaleryBody();
  }

}