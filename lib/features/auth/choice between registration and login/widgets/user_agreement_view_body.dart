import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/Utils/app_colors.dart';


class UserAgreementViewBody extends StatelessWidget {
  const UserAgreementViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appInformationColors800,
        title: Text(
          "إتفاقيه المستخدم".tr(args: ["إتفاقيه المستخدم"]),
          style: TextStyle(
            fontFamily: "Questv1",
            color: Colors.white,
          ),
        ),
      ),
      body:  Center(
        child: Text(
          "إتفاقيه المستخدم".tr(args: ['إتفاقيه المستخدم']),
          style: TextStyle(
            fontFamily: "Questv1",
            color: Colors.blueGrey,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
