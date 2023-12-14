import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/Utils/app_colors.dart';


class PrivacyTermsViewBody extends StatelessWidget {
  const PrivacyTermsViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appInformationColors800,
        title: Text(
          "شروط الخصوصية".tr(args: ["شروط الخصوصية"]),
          style: TextStyle(
            fontFamily: "Questv1",
            color: Colors.white,
          ),
        ),
      ),
      body:  Center(
        child: Text(
          "شروط الخصوصية",
          style: TextStyle(
            fontFamily: "Questv1",
            color: Colors.blueGrey,
            fontSize: 26,
          ),
        ).tr(args: ['شروط الخصوصية']),
      ),
    );
  }
}
