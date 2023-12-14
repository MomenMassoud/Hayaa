import 'package:flutter/material.dart';

class SystemMSG extends StatelessWidget{
  String msg;
  SystemMSG(this.msg);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        elevation: 1,
        color: Color.fromRGBO(241, 243, 255, 1),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Stack(
          children: [
            InkWell(
              child: Text(
                msg,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}