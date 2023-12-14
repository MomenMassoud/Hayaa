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
    // if(widget.type=="vedio"){
    //   setController();
    // }
    //check();
  }
  // void check()async{
  //   final appStorage= await getExternalStorageDirectory();
  //   final test =File('${appStorage?.path}/${widget.time}');
  //   final cc = await test.exists();
  //   print("Test File${test.path}");
  //   if(cc){
  //     setState(() {
  //       downloaded=true;
  //     });
  //   }
  // }
  // void ShareFile()async{
  //   try{
  //     check();
  //     if(downloaded==true){
  //       final appStorage= await getExternalStorageDirectory();
  //       final test =File('${appStorage?.path}/${widget.time}');
  //       List<XFile> filess = [];
  //       filess.add(XFile(test.path));
  //       await Share.shareXFiles(
  //           filess
  //       ).then((value) => print("Thank You"));
  //     }
  //     else{
  //       final appStorage= await getExternalStorageDirectory();
  //       final test =File('${appStorage?.path}/${widget.time}');
  //       await _requestPermision(Permission.storage);
  //       final file=await downloadFile(widget.url,widget.time);
  //       if (file==null) return null;
  //       print("path : ${file.path}");
  //       List<XFile> filess = [];
  //       filess.add(XFile(file.path));
  //       await Share.shareXFiles(
  //           filess
  //       ).then((value) => print("Thank You"));
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }
  void deleteMSG()async{
    try{
      if(widget.group==true){
        final docRef = _firebaseStorage.collection("MassegeGroup").doc(widget.id);
        final updates = <String, dynamic>{
          "Msg": "This MSG deleted!",
          "type":"msg"
        };
        docRef.update(updates);
        print("Delete MSG From Chat Group");
      }
      else{
        final docRef = _firebaseStorage.collection("chat").doc(widget.id);
        final updates = <String, dynamic>{
          "msg": "This MSG deleted!",
          "type":"msg"
        };
        docRef.update(updates);
        print("Delete MSG From Chat One to One");
      }
    }
    catch(e){
      return showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: const Text('Error'),
                content: Text(e.toString()),
                icon:ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Ignore"),
                )

            );
          }
      );
    }
  }
  void myAlert(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose'),
            content: SizedBox(
              height: 130,
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        deleteMSG();
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.delete),
                          Text("Delete MSG"),
                        ],
                      )
                  ),
                  ElevatedButton(
                      onPressed: (){

                      },
                      child: const Row(
                        children: [
                          Icon(Icons.share),
                          Text("Share"),
                        ],
                      )
                  )
                ],
              ),
            ),
          );
        }
    );
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
                child: InkWell(
                  onLongPress: (){
                    myAlert();
                  },
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
                          // final appStorage= await getExternalStorageDirectory();
                          // final test =File('${appStorage?.path}/${widget.time}');
                          // OpenFile.open(test.path);
                        },
                        child: const Text("Open"),
                      ):ElevatedButton(
                        onPressed: ()async{
                          //openFileUrl(widget.url,widget.time);
                        },
                        child: const Text("Download And Open"),
                      )
                    ],
                  ),
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
              color: Colors.green[300]
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
                          onLongPress: (){
                            myAlert();
                          },
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
                      onLongPress: (){
                        myAlert();
                      },
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


