import 'package:flutter/material.dart';

import '../widgets/games_view_body.dart';

class GamesView extends StatelessWidget {
  const GamesView({super.key});
  static const id = 'GamesView';

  @override
  Widget build(BuildContext context) {
    return GamesViewBody();
  }
}
