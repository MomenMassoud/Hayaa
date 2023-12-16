import 'package:flutter/material.dart';
import 'package:hayaa_main/features/store/widget/store_body.dart';


class StoreView extends StatefulWidget{
  static const id = 'StoreView';
  const StoreView({super.key});
  _StoreView createState()=>_StoreView();
}

class _StoreView extends State<StoreView>{
  @override
  Widget build(BuildContext context) {
    return StoreBody();
  }

}