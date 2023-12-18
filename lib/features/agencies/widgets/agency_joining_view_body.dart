import 'package:flutter/material.dart';

class AgencyJoiningViewBody extends StatelessWidget {
  const AgencyJoiningViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Choose Agency",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
