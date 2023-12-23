import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ViewPhoto extends StatefulWidget{
  String photo;
  ViewPhoto(this.photo);
  _ViewPhoto createState()=>_ViewPhoto();
}

class _ViewPhoto extends State<ViewPhoto>{
  String  filename="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            filename="hayaa-${DateTime.now().toString()}.png";
            saveImage();
          }, icon: Icon(Icons.download_for_offline))
        ],
      ),
      body: Center(child: CachedNetworkImage(imageUrl: widget.photo)),
    );
  }
  Future saveImage()async{
    await _requestPermision(Permission.storage);
    String path =
        widget.photo;
    GallerySaver.saveImage(path);
  }
}
Future<bool?>_requestPermision (Permission per)async{
  if(await per.isGranted){
    return true;
  }
  else{
    await per.request();
  }
  return null;
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