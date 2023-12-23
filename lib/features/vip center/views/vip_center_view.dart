import 'package:flutter/material.dart';

import '../widgets/vip_center_view_body.dart';

class VipCenterView extends StatelessWidget {
  const VipCenterView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/core/Utils/assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: const VipCenterViewBody(),
      ),
    );
  }
}
