import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';



class SaleryBody extends StatefulWidget{
  _SaleryBody createState()=>_SaleryBody();
}


class _SaleryBody extends State<SaleryBody>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 243, 255, 1),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("دخل",style: TextStyle(fontSize: 16,color: Colors.black),).tr(args: ['دخل']),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 13),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("الالماس المتاح",style: TextStyle(color: Colors.grey),).tr(args: ['الالماس المتاح']),
                  Divider(thickness: 2),
                  ListTile(
                    title: Text("0"),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(AppImages.daimond),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}