import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../core/Utils/app_colors.dart';
import '../../agencies/widgets/seperated_text.dart';


class CreatePostBody extends StatefulWidget{
  _CreatePostBody createState()=>_CreatePostBody();
}

class _CreatePostBody extends State<CreatePostBody>{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseStorage _storage=FirebaseStorage.instance;
  bool showPickedFile=false;
  File? imageFile;
  bool _showspinner=false;
  TextEditingController _namefield=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        title: Text("اضافة منشور جديد",style: TextStyle(color: Colors.white,fontFamily: "Hayah"),),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp,color: Colors.white,)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SeperatedText(
              tOne: "نص المنشور",
              tTwo: "*",
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "ادخل نص المنشور",
                  hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
                  controller: _namefield,
            ),
            const SeperatedText(tOne: 'اريفع صورة للمنشور', tTwo: "*"),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () async{
                  await _pickImage();
                },
                child: showPickedFile==false?Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Icon(
                        Icons.add,
                        size: screenWidth * 0.2,
                        color: Colors.blueGrey,
                      )),
                ):Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: FileImage(imageFile!)
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 70,),
            ElevatedButton(onPressed: ()async{
              Navigator.pop(context);
              setState(() {
                _showspinner = true;
              });
              if(imageFile==null){
                String doc="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                await _firestore.collection('post').doc(doc).set({
                  'day':DateTime.now().day.toString(),
                  'month':DateTime.now().month.toString(),
                  'year':DateTime.now().year.toString(),
                  'owner_email':_auth.currentUser!.uid,
                  'owner_photo':_auth.currentUser!.photoURL.toString(),
                  'owner_name':_auth.currentUser!.displayName.toString(),
                  'text':_namefield.text,
                  'photo':"none",
                }).then((value){
                  _namefield.clear();
                  showPickedFile=false;
                  imageFile!.delete();
                  setState(() {
                    _showspinner = false;
                    Navigator.pop(context);
                  });
                });
              }
              else{
                img.Image image=img.decodeImage(imageFile!.readAsBytesSync())!;
                img.Image compressedImage = img.copyResize(image, width: 800);
                File compressedFile = File('${imageFile!.path}_compressed.jpg')
                  ..writeAsBytesSync(img.encodeJpg(compressedImage));
                final path = "post/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
                final ref = FirebaseStorage.instance.ref().child(path);
                final uploadTask = ref.putFile(compressedFile);
                final snapshot = await uploadTask.whenComplete(() {});
                final urlDownload = await snapshot.ref.getDownloadURL();
                print("Download Link : $urlDownload");
                String doc="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                await _firestore.collection('post').doc(doc).set({
                  'day':DateTime.now().day.toString(),
                  'month':DateTime.now().month.toString(),
                  'year':DateTime.now().year.toString(),
                  'owner_email':_auth.currentUser!.uid,
                  'owner_photo':_auth.currentUser!.photoURL.toString(),
                  'owner_name':_auth.currentUser!.displayName.toString(),
                  'text':_namefield.text,
                  'photo':urlDownload
                }).then((value){
                  _namefield.clear();
                  showPickedFile=false;
                  imageFile!.delete();
                  setState(() {
                    _showspinner = false;
                    Navigator.pop(context);
                  });
                });
              }
            }, child: Text("نشر المنشور"))
          ],
        ),
      ),
    );
  }
  _pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile = tempImage;
      showPickedFile = true;
    });
  }

}