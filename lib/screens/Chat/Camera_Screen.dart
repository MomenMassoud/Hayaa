import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/Model/ChatModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:path/path.dart' show join;
import 'Camera_View.dart';
import 'Vedio_View.dart';
List<CameraDescription> cameras=[];
class CameraScreen extends StatefulWidget{
  chatmodel user;
  CameraScreen(this.user);
  @override
  _CameraScreen createState()=>_CameraScreen();

}

class _CameraScreen extends State<CameraScreen>{
  late int index;
  int flip=0;
  bool isRecoring=false;
  late CameraController _cameraController;
  bool flash=false;
  late Future <void> cameraValue;
  bool isCameraFront=true;
  double transform=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController=CameraController(cameras[flip], ResolutionPreset.high);
    cameraValue=_cameraController.initialize();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  // Otherwise, display a loading indicator.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 5,bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: (){
                            setState(() {
                              flash=!flash;
                            });
                            flash?_cameraController.setFlashMode(FlashMode.torch):_cameraController.setFlashMode(FlashMode.off);
                          },
                          icon:flash?Icon(Icons.flash_on,size: 25,color: Colors.blue,): Icon(Icons.flash_off,size: 25,color: Colors.blue,)),
                      GestureDetector(
                          onLongPress: () async {
                            await _cameraController.startVideoRecording();
                            setState(() {
                              isRecoring = true;
                            });
                          },
                          onLongPressUp: () async {
                            XFile videopath =
                            await _cameraController.stopVideoRecording();
                            setState(() {
                              isRecoring = false;
                            });
                            print("Hi Videeo");
                            print(videopath.path);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => VideoViewPage(
                                      videopath.path,
                                      videopath.name,
                                      widget.user
                                    )));
                          },
                        onTap: (){
                          if(!isRecoring){
                            takePhoto(context);
                          }

                        },
                        child: isRecoring?Icon(Icons.circle,color: Colors.red,size: 90,):Icon(
                                Icons.panorama_fish_eye,
                                size: 90,
                                color: Colors.blue
                            )
                        ),

                      IconButton(
                          onPressed: ()async{
                            setState(() {
                              isCameraFront=!isCameraFront;
                              transform=transform+pi;
                            });
                            flip= isCameraFront?0:1;
                            _cameraController=CameraController(cameras[flip], ResolutionPreset.high);
                            cameraValue=_cameraController.initialize();
                          },
                          icon: Transform.rotate(
                            angle: transform,
                            child: Icon(
                                Icons.flip_camera_ios_outlined,size: 25,color: Colors.blue
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 80,),
                  Text("Hold To Vedio , Pick To Photo",style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.center,)
                ],
              ),

            ),
    )
          ],
        ),
      )
    );
  }

  void takePhoto(BuildContext context)async{
    try {
      await cameraValue;
      final paths = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      XFile picture = await _cameraController.takePicture();
      picture.saveTo(paths);
      final id =DateTime.now().toString();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraView(paths,id,widget.user),
        ),
      );
    } catch (e) {
      print(e);
    }
  }



}