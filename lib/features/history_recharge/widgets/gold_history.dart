import 'package:flutter/material.dart';


import '../../../core/Utils/app_images.dart';
import 'history_widget.dart';

class GoldHistory extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HistoryCard("الشهر الماضي", "", "", "", true),
          HistoryCard("مكافئة العملات الذهبية", "12/07/2023 11:16:17", "+400", AppImages.gold_coin, false),
          HistoryCard("مكافئة العملات الذهبية", "12/07/2023 11:16:17", "+300", AppImages.gold_coin, false),
          HistoryCard("مكافئة العملات الذهبية", "12/07/2023 11:16:17", "+20", AppImages.gold_coin, false),
          HistoryCard("الشهر الجاري", "", "", "", true),
          HistoryCard("مكافئة العملات الذهبية", "12/07/2023 11:16:17", "+400", AppImages.gold_coin, false),
          HistoryCard("مكافئة العملات الذهبية", "12/07/2023 11:16:17", "+300", AppImages.gold_coin, false),
          HistoryCard("مكافئة العملات الذهبية", "12/07/2023 11:16:17", "+20", AppImages.gold_coin, false),
        ],
      ),
    );
  }

}