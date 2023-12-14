import 'package:flutter/material.dart';

import '../widgets/history_recharge_body.dart';

class HistoryRechargeView extends StatefulWidget{
  static const id = 'HistoryRechargeView';
  const HistoryRechargeView({super.key});
  _HistoryRechargeView createState()=>_HistoryRechargeView();
}

class _HistoryRechargeView extends State<HistoryRechargeView>{
  @override
  Widget build(BuildContext context) {
    return HistoryRechargeBody();
  }

}