import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/chat/widget/group/myfamily/my_family_body.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../core/Utils/app_images.dart';
import '../../../../agencies/widgets/custom_image_picker.dart';
import '../../../../agencies/widgets/seperated_text.dart';

class CreateFamilyBody extends StatefulWidget{
  _CreateFamilyBody createState()=>_CreateFamilyBody();
}

enum Setting { open, close }
class _CreateFamilyBody extends State<CreateFamilyBody>{
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  Setting setting = Setting.close;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  File? imageFile;
  bool showPickedFile = false;
  TextEditingController _namefield = TextEditingController();
  TextEditingController _definefiled = TextEditingController();
  bool _showspinner=false;
  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("انشاء عائلة"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: [
              showPickedFile==false?CustomImagePicker(
                screenWidth: screenWidth,
                onTap: () {
                  _pickImage();
                },
              ):InkWell(
                onTap: (){
                  _pickImage();
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: showPickedFile
                      ? FileImage(imageFile!)
                      : AssetImage(AppImages.UserImage) as ImageProvider,
                ),
              ),
              const SeperatedText(
                tOne: "اسم العائلة ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "ادخل اسم العائلة",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
                controller: _namefield,
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "Definition Of Family",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(fontSize: 22),
                maxLength: 300,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Please Define Your family",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
                controller: _definefiled,
              ),
              const SizedBox(
                height: 10,
              ),
              const SeperatedText(
                tOne: "Setting of Family",
                tTwo: "*",
              ),
              Row(
                children: [
                  Radio(
                    value: Setting.close,
                    hoverColor: Colors.black,
                    groupValue: setting,
                    onChanged: (Setting? g) {
                      setState(() {
                        setting = g!;
                      });
                    },
                  ),
                  Text("الموافقة مطلوبة للانضمام للعائلة",style: TextStyle(color: Colors.black),).tr(args: ['ذكر'])
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: Setting.open,
                    hoverColor: Colors.black,
                    groupValue: setting,
                    onChanged: (Setting? g) {
                      setState(() {
                        setting = g!;
                      });
                    },
                  ),
                  Text("لا توجد موافقة مطلوبة للانضمام للعائلة",style: TextStyle(color: Colors.black),).tr(args: ['ذكر'])
                ],
              ),
              SizedBox(height: 25,),
              ElevatedButton(onPressed: (){
                if(imageFile==null){
                  AllarmError("رجاء رفع صورة العائلة");
                }
                else if(_namefield.text==""){
                  AllarmError("رجاء ادخال الاسم");
                }
                else if(_definefiled.text==""){
                  AllarmError("رجاء ادخال تعريف العائلة");
                }
                else{
                  Allarm();
                }
              }, child: Text("انشاء العائلة 10000 ماسة"))
            ],
          ),
        ),
      ),
    );
  }
  void AllarmError(String error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(error),
                  SizedBox(height: 70,),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("تعديل")),
                ],
              )
          );
        });
  }
  void Allarm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("هل انت متاكد من انشاء هذه العائلة"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        int diamond=0;
                        await _firestore.collection('user').doc(_auth.currentUser!.uid).get().then((value){
                          diamond=int.parse(value.get('daimond'));
                        });
                        if(diamond>=10000){
                          setState(() {
                            _showspinner = true;
                            Navigator.pop(context);

                          });
                          diamond=diamond-10000;
                          String idd="";
                          for(int i=0;i<8;i++){
                            int randomNumber = random.nextInt(10);
                            idd="$idd$randomNumber";
                          }
                          img.Image image=img.decodeImage(imageFile!.readAsBytesSync())!;
                          img.Image compressedImage = img.copyResize(image, width: 800);
                          File compressedFile = File('${imageFile!.path}_compressed.jpg')
                            ..writeAsBytesSync(img.encodeJpg(compressedImage));
                          final path = "family/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
                          final ref = FirebaseStorage.instance.ref().child(path);
                          final uploadTask = ref.putFile(compressedFile);
                          final snapshot = await uploadTask.whenComplete(() {});
                          final urlDownload = await snapshot.ref.getDownloadURL();
                          print("Download Link : $urlDownload");
                          String id="${DateTime.now()}-${_auth.currentUser!.uid}";
                          _firestore.collection('family').doc(id).set({
                            'name':_namefield.text,
                            'bio':_definefiled.text,
                            'photo':urlDownload,
                            'join':setting.name,
                            'id':id,
                            'idd':idd,
                            'level':'0'
                          }).then((value){
                            _firestore.collection('family').doc(id).collection('user').doc().set({
                              'user':_auth.currentUser!.uid,
                              'type':'owner'
                            }).then((value){
                              _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                                'daimond':diamond.toString(),
                                'myfamily':id
                              }).then((value){
                                setState(() {
                                  _showspinner = false;
                                });
                                CreateDone();
                              });
                            });
                          });
                        }
                        else{
                          CreateCancell();
                        }
                      }, child: Text("انشاء")),
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("الغاء")),
                    ],
                  )
                ],
              )
          );
        });
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
  void CreateDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("مبروك"),
              content: Container(
                height: 120,
                child: Column(
                  children: [
                    Text("تم انشاء العائلة"),
                    ElevatedButton(onPressed: (){
                      Navigator.popAndPushNamed(context, MyFamilyBody.id);
                    }, child: Text("مشاهدة العائلة"))
                  ],
                )
              )
          );
        });
  }
  void CreateCancell() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ناسف"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("لا تملك عدد كافي من الماس"),
                ),
              )
          );
        });
  }

}