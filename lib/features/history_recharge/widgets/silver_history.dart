import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';
import 'history_widget.dart';


class SilverHistory extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HistoryCard("الشهر الماضي", "", "", "", true),
          HistoryCard("مكافئة العملات الفضية", "12/07/2023 11:16:17", "+400", AppImages.silver_coin, false),
          HistoryCard("مكافئة العملات الفضية", "12/07/2023 11:16:17", "+300", AppImages.silver_coin, false),
          HistoryCard("مكافئة العملات الفضية", "12/07/2023 11:16:17", "+20", AppImages.silver_coin, false),
          HistoryCard("الشهر الجاري", "", "", "", true),
          HistoryCard("مكافئة العملات الفضية", "12/07/2023 11:16:17", "+400", AppImages.silver_coin, false),
          HistoryCard("مكافئة العملات الفضية", "12/07/2023 11:16:17", "+300", AppImages.silver_coin, false),
          HistoryCard("مكافئة العملات الفضية", "12/07/2023 11:16:17", "+20", AppImages.silver_coin, false),
        ],
      ),
    );
  }

}