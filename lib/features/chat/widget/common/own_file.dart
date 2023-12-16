import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OwnFileCard extends StatefulWidget {
  String url;
  String time;
  String type;
  String nameFile;
  String id;
  late File ff;
  bool group;
  Widget? image;
  OwnFileCard(this.url, this.time, this.type,this.nameFile,this.group,this.id, {super.key});

  @override
  _OwnFileCard createState()=>_OwnFileCard();
}
class _OwnFileCard extends State<OwnFileCard>{
  final FirebaseFirestore _firebaseStorage=FirebaseFirestore.instance;
  String? pp;
  bool downloaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.type=="file"? Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green[300]
              ),
              child: Card(
                margin: const EdgeInsets.all(3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)
                ),
                child: Column(
                  children: [
                    const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage:AssetImage("Images/files.png"),
                            radius: 30,
                          ),
                        ]
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
          ),
        )
    )
        :Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height/2.3,
          width: MediaQuery.of(context).size.width/1.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
          ),
          child: Card(
              margin: const EdgeInsets.all(3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              child:Stack(
                children: [
                  widget.type=="vedio"?Stack(
                    fit:StackFit.expand,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewVideo(widget.url,)));
                          },
                          child: const CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ):InkWell(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewMedia(widget.url,)));
                      },
                      child: CachedNetworkImage(imageUrl: widget.url,fit: BoxFit.fitHeight)),

                ],
              )          ),
        ),
      ),
    );
  }
  // Future openFileUrl(String url,String fileName)async{
  //   try{
  //     final appStorage= await getExternalStorageDirectory();
  //     final test =File('${appStorage?.path}/$fileName');
  //     final cc = await test.exists();
  //     if(cc){
  //       OpenFile.open(test.path);
  //     }
  //     else{
  //       await _requestPermision(Permission.storage);
  //       final file=await downloadFile(url,fileName);
  //       if (file==null) return null;
  //       setState(() {
  //         downloaded=true;
  //       });
  //       print("path : ${file.path}");
  //       OpenFile.open(file.path);
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }
  // Future<bool?>_requestPermision (Permission per)async{
  //   if(await per.isGranted){
  //     return true;
  //   }
  //   else{
  //     await per.request();
  //   }
  //   return null;
  // }
  // Future<File?> downloadFile(String url,String Name)async{
  //   try{
  //     final appStorage= await getExternalStorageDirectory();
  //     final file =File('${appStorage?.path}/$Name');
  //     final response = await Dio().get(
  //         url,
  //         options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //         )
  //     );
  //     final ref = file.openSync(mode: FileMode.write);
  //     ref.writeFromSync(response.data);
  //     await ref.close();
  //     return file;
  //   }
  //   catch(e){
  //     print(e);
  //     return null;
  //   }
  // }
}


