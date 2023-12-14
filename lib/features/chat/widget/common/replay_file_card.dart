import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ReplayFileCard extends StatefulWidget {
  String url;
  String time;
  String type;
  String nameFile;
  late File ff;
  Widget? image;
  ReplayFileCard(this.url, this.time, this.type,this.nameFile, {super.key});

  @override
  _ReplayFileCard createState()=>_ReplayFileCard();
}
class _ReplayFileCard extends State<ReplayFileCard>{
  String? pp;
  bool downloaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.type=="file"? Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Card(
          margin: const EdgeInsets.all(3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9)
          ),
          child:Column(
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage:AssetImage("Images/files.png"),
                    radius: 20,
                  ),
                ],
              ),
              Text(widget.time),
              downloaded?ElevatedButton(
                onPressed: ()async{

                },
                child: const Text("Open"),
              ):ElevatedButton(
                onPressed: ()async{
                },
                child: const Text("Download And Open"),
              )
            ],
          ),
        ),
      ),
    ):Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: MediaQuery.of(context).size.height/2.3,
        width: MediaQuery.of(context).size.width/1.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey
        ),
        child: Card(
            margin: const EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child:Stack(
              children: [
                InkWell(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewMedia(widget.url)));
                    },
                    child: CachedNetworkImage(imageUrl: widget.url,fit: BoxFit.fitWidth,)
                )

              ],
            )          ),
      ),
    );
  }
}


