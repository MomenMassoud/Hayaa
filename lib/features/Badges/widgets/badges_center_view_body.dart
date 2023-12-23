import 'package:flutter/material.dart';
import 'activity_tab.dart';

class BadgesCenterViewBody extends StatefulWidget {
  const BadgesCenterViewBody({
    super.key,
  });

  @override
  State<BadgesCenterViewBody> createState() => _BadgesCenterViewBodyState();
}

class _BadgesCenterViewBodyState extends State<BadgesCenterViewBody> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [
          Container(
            color: Colors.black,
            child: const Center(
                child: Text(
              "الانجازات",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          ),
          const ActivityTab(),
        ]),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          bottom: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white)),
              labelColor: Colors.white,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                  color: Colors.amber[100],
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              tabs: const [
                Tab(
                  text: 'الانجاز',
                ),
                Tab(
                  text: 'النشاط',
                ),
              ]),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            "مركز الشارات",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                    color: Colors.brown[100]),
                child: const Center(
                    child: Text(
                  "ارتداء",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
