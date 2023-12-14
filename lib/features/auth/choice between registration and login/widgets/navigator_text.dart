


import 'package:flutter/material.dart';

class NavigatorText extends StatelessWidget {
  const NavigatorText({
    super.key,  required this.content, required this.onTap,
  });


  final String content;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap ,
      child: Text( content ,
                    style: const TextStyle(
                      fontFamily: "Questv1",
                      color: Colors.white,
                      fontSize: 14,
                    ),),
    );
  }
}
