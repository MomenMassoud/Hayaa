import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Custom_Wedgit/view_media.dart';
import 'package:iconnect2/Custom_Wedgit/view_vedio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';


class ReplayFileCard extends StatefulWidget {
  late VideoPlayerController _controller;
  String url;
  String time;
  String type;
  String nameFile;
  late File ff;
  Widget? image;
  ReplayFileCard(this.url, this.time, this.type,this.nameFile);

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
    if(widget.type=="vedio"){
      setController();
    }
    check();

  }
  void check()async{
    final appStorage= await getExternalStorageDirectory();
    final test =File('${appStorage?.path}/${widget.time}');
    final cc = await test.exists();
    if(cc){
      setState(() {
        downloaded=true;
      });
    }
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
            margin: EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9)
            ),
            child:Column(
              children: [
                Row(
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
                    final appStorage= await getExternalStorageDirectory();
                    final test =File('${appStorage?.path}/${widget.time}');
                    OpenFile.open(test.path);
                  },
                  child: Text("Open"),
                ):ElevatedButton(
                  onPressed: ()async{
                    openFileUrl(widget.url,widget.time);
                  },
                  child: Text("Download And Open"),
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
            margin: EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child:Stack(
              children: [
                widget.type=="vedio"?Stack(
                  children: [
                    AspectRatio(
                        aspectRatio: widget._controller.value.aspectRatio,
                        child: VideoPlayer(widget._controller)
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewVideo(widget.url,)));
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
                ):InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>ViewMedia(widget.url)));
                  },
                  child: CachedNetworkImage(imageUrl: widget.url,fit: BoxFit.fitWidth,)
                )

              ],
            )          ),
      ),
    );
  }

  void setController(){
    setState(() {
      widget._controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    });
  }
  Future openFileUrl(String url,String fileName)async{
    try{
      final appStorage= await getExternalStorageDirectory();
      final test =File('${appStorage?.path}/$fileName');
      final cc = await test.exists();
      if(cc){
        OpenFile.open(test.path);
      }
      else{
        await _requestPermision(Permission.storage);
        final file=await downloadFile(url,fileName);
        if (file==null) return null;
        print("path : ${file.path}");
        setState(() {
          downloaded=true;
        });
        OpenFile.open(file.path);
      }
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
}


