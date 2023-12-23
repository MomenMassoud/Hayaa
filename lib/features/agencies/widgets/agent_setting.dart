import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../core/Utils/app_colors.dart';

class AgentSetting extends StatefulWidget{
  String id;
  AgentSetting(this.id);
  _AgentSetting createState()=>_AgentSetting();
}


class _AgentSetting extends State<AgentSetting>{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  TextEditingController _namefield = TextEditingController();
  TextEditingController _definefiled = TextEditingController();
  File? imageFile;
  bool _showspinner=false;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: screenHeight * 0.12,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.app3MainColor, AppColors.appMainColor],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text("اعدادات الوكالة"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('agency').where('doc',isEqualTo: widget.id).snapshots(),
        builder: (context,snapshot){
          String photo="";
          String name="";
          String bio="";
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed){
            photo=massege.get('photo');
            name=massege.get('name');
            bio=massege.get('bio');
          }
          return ModalProgressHUD(
            inAsyncCall: _showspinner,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: (){
                          _pickImage(photo);
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: CachedNetworkImageProvider(photo),
                              fit: BoxFit.fill
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 50,),
                      InkWell(
                        onTap: (){
                          Allarm();
                        },
                          child: Text(name,style: TextStyle(fontSize: 22),)),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          Allarm2();
                        },
                          child: Text(bio,style: TextStyle(fontSize: 22,color: Colors.grey),)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  _pickImage(String photo) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile = tempImage;
      _showspinner=true;
    });
    await _storage.refFromURL(photo).delete();
    img.Image image=img.decodeImage(imageFile!.readAsBytesSync())!;
    img.Image compressedImage = img.copyResize(image, width: 800);
    File compressedFile = File('${imageFile!.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(compressedImage));
    final path = "agent/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(compressedFile);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await _firestore.collection('agency').doc(widget.id).update({
      'photo':urlDownload
    }).then((value){
      setState(() {
        _showspinner=false;
      });
    });
  }
  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          _showspinner=false;
          return AlertDialog(
              title: Text("تعديل اسم الوكالة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                TextField(
                 controller: _namefield,
                decoration: InputDecoration(
                    hintText: "Please Enter Name",
                    hintStyle: TextStyle(fontSize: 100 * 0.035)),
                ),
                  SizedBox(height: 15,),
                  ElevatedButton(onPressed: ()async{
                    await _firestore.collection('agency').doc(widget.id).update(
                        {
                          'name':_namefield.text
                        }).then((value){
                          _namefield.clear();
                          Navigator.pop(context);
                    });
                  }, child: Text("حفظ الاسم الجديد"))
                ],
              )
          );
        });
  }
  void Allarm2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          _showspinner=false;
          return AlertDialog(
              title: Text("تعديل تعريف الوكالة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _namefield,
                    decoration: InputDecoration(
                        hintText: "Please Enter Name",
                        hintStyle: TextStyle(fontSize: 100 * 0.035)),
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton(onPressed: ()async{
                    await _firestore.collection('agency').doc(widget.id).update(
                        {
                          'bio':_namefield.text
                        }).then((value){
                      _namefield.clear();
                      Navigator.pop(context);
                    });
                  }, child: Text("حفظ التعريف الجديد"))
                ],
              )
          );
        });
  }

}