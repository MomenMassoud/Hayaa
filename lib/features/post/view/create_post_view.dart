import 'package:flutter/material.dart';
import '../widget/create_post_body.dart';


class CreatePostView extends StatefulWidget{
  static const id="CreatePostView";
  _CreatePostView createState()=>_CreatePostView();
}

class _CreatePostView extends State<CreatePostView>{
  @override
  Widget build(BuildContext context) {
    return CreatePostBody();
  }

}