import 'package:flutter/material.dart';
class MyTextField extends StatefulWidget{
  String varible;
  String hinttext;
  Icon icon;
  bool pass;
  MyTextField(this.varible,this.hinttext,this.icon,this.pass);
  _MyTextField createState()=>_MyTextField();
}
class _MyTextField extends State<MyTextField>{

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      cursorColor: Colors.blue[900],
      onChanged: (value){
        widget.varible=value;
      },
      obscureText: widget.pass,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        hintText: widget.hinttext,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            )

        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue[700]!,
                width: 1
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.orange,
                width: 2
            ),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
      ),
    );
  }

}