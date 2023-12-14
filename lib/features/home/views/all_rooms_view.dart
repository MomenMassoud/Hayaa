import 'package:flutter/material.dart';

class AllRoomsView extends StatelessWidget {
  const AllRoomsView({super.key});
  static const id = 'AllRoomsView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("جميع الغرف"),
      ),
    );
  }
}
