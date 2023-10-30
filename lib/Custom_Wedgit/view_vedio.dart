import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget{
  late VideoPlayerController _controller;
  String url;
  String filename="";
  ViewVideo(this.url);
  _ViewVideo createState()=>_ViewVideo();
}

class _ViewVideo extends State<ViewVideo>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget._controller.closedCaptionFile;
    widget._controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async{
              print(value);
              if(value=="save"){
                widget.filename="${DateTime.now().toString()}.mp4";
                saveImage();
              }
              if(value=="share"){
                String tt=DateTime.now().toString();
                openFileUrl(widget.url,"$tt.mp4");

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
      body: Stack(
        children: [
          AspectRatio(
              aspectRatio:widget._controller.value.aspectRatio,
              child: VideoPlayer(widget._controller)
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget._controller.value.isPlaying
                      ? widget._controller.pause()
                      : widget._controller.play();
                });
              },
              child: CircleAvatar(
                radius: 33,
                backgroundColor: Colors.black38,
                child: Icon(
                  widget._controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void setController(){
    setState(() {
      widget._controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
        setState(() {});
      });
    });
  }
  Future saveImage()async{
    try{
      await _requestPermision(Permission.storage);
      final file=await downloadFile(widget.url,widget.filename);
      if (file==null) return null;
      print("path : ${file.path}");
      GallerySaver.saveVideo(file.path).then((value) {
        print("Save Video Success");
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