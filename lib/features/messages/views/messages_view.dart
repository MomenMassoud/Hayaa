import 'package:flutter/material.dart';

import '../widgets/messages_view_body.dart';


class MessagesView extends StatelessWidget {
  const MessagesView({super.key});
  static const id = 'MessagesView';

  @override
  Widget build(BuildContext context) {
    return  MessagesViewBody();
  }
}
