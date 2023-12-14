import 'package:flutter/material.dart';

import '../widgets/recharge_body.dart';


class RechargeView extends StatefulWidget{
  static const id = 'RechargeView';
  const RechargeView({super.key});
  _RechargeView createState()=>_RechargeView();
}

class _RechargeView extends State<RechargeView>{
  @override
  Widget build(BuildContext context) {
    return const RechargeBody();
  }

}