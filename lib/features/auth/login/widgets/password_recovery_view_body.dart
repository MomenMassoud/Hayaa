import 'package:flutter/material.dart';

import '../../../../core/Utils/app_colors.dart';


class PasswordRecoveryViewBody extends StatelessWidget {
  const PasswordRecoveryViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appInformationColors800,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "إسترجاع كلمة المرور",
              style: TextStyle(
                fontFamily: "Questv1",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "  ",
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
