import 'package:flutter/material.dart';
import 'package:hayaa_main/features/vip%20center/widgets/vip_section_foure.dart';
import 'package:hayaa_main/features/vip%20center/widgets/vip_section_three.dart';
import 'package:hayaa_main/features/vip%20center/widgets/vip_section_two.dart';

import 'vip_section_one.dart';

class VipCenterViewBody extends StatelessWidget {
  const VipCenterViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(children: [
          const VipSectionOne(),
          const VipSectionTwo(),
          const VipSectionThree(),
          const VipSectionFoure(),
        ]),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          bottom: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                color: Colors.white,
              )),
              labelColor: Colors.amber[100],
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                  color: Colors.amber[200],
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              tabs: const [
                Tab(
                  text: 'VIP1',
                ),
                Tab(
                  text: 'VIP2',
                ),
                Tab(
                  text: 'VIP3',
                ),
                Tab(
                  text: 'VIP4',
                ),
              ]),
          backgroundColor: Colors.transparent,
          title: const Text(
            " VIP  مركز",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
