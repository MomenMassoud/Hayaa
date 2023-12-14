import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReplayLink extends StatelessWidget{
  String msg;
  String date;
  String id;
  ReplayLink(this.msg,this.date,this.id, {super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width-45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22)
          ),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 80,top: 9,bottom: 20),
                child: InkWell(
                    onLongPress: (){
                      final Uri url = Uri.parse(msg);
                      openurl(url);
                    },
                    child: Text(
                      msg,style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue
                    ),
                    )
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(date,style: const TextStyle(fontSize: 13,color: Colors.grey),),
                    const SizedBox(width: 5,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> openurl(Uri url)async{
    await launchUrl(
        url,
        mode: LaunchMode.platformDefault
    );
  }

}