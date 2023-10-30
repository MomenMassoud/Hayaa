import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ViewMedia extends StatelessWidget {
  String url;
  String filename="";
  ViewMedia(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
              if(value=="save"){
                filename="${DateTime.now().toString()}.png";
                saveImage();
              }
              if(value=="share"){
                String tt=DateTime.now().toString();
                openFileUrl(url,"$tt.jpg");

              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.save_alt,
                        color: Colors.blue,
                      ),
                      Text("save"),
                    ],
                  ),
                  value: "save",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.blue,
                      ),
                      Text("share"),
                    ],
                  ),
                  value: "share",
                ),
              ];
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(imageUrl: url),
      ),
    );
  }
  Future saveImage()async{
    try{
      await _requestPermision(Permission.storage);
      final file=await downloadFile(url,filename);
      if (file==null) return null;
      print("path : ${file.path}");
      GallerySaver.saveImage(file.path).then((value) {
        print("Save Gallery Success");
      });
    }
    catch(e){
      print(e);
    }

  }
  Future<bool?>_requestPermision (Permission per)async{
    if(await per.isGranted){
      return true;
    }
    else{
      await per.request();
    }
  }
  Future<File?> downloadFile(String url,String Name)async{
    try{
      final appStorage= await getExternalStorageDirectory();
      final file =File('${appStorage?.path}/$Name');
      final response = await Dio().get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          )
      );
      final ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();
      return file;
    }
    catch(e){
      print(e);
      return null;
    }
  }
  Future openFileUrl(String url,String fileName)async{
    try{
      final appStorage= await getExternalStorageDirectory();
      final test =File('${appStorage?.path}/$fileName');
      await _requestPermision(Permission.storage);
      final file=await downloadFile(url,fileName);
      if (file==null) return null;
      print("path : ${file.path}");
      List<XFile> filess = [];
      filess.add(XFile(file.path));
      await Share.shareXFiles(
          filess
      ).then((value) => print("Thank You"));
    }
    catch(e){
      print(e);
    }
  }

}
