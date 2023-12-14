import 'package:flutter/material.dart';

import '../widget/vip_body.dart';



class VipView extends StatefulWidget{
  const VipView({super.key});
  static const id = 'VipView';
  _ViPView createState()=>_ViPView();
}


class _ViPView extends State<VipView>{
  @override
  Widget build(BuildContext context) {
    return VipBody();
  }

}