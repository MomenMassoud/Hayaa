import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/agencies/views/agency_agent_view.dart';
import 'package:hayaa_main/features/agencies/widgets/custom_image_picker.dart';
import 'package:hayaa_main/features/agencies/widgets/seperated_text.dart';
import 'package:hayaa_main/features/auth/choice%20between%20registration%20and%20login/widgets/gradiant_button.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../../../core/Utils/app_images.dart';

class AgencyCreationViewBody extends StatefulWidget {
  const AgencyCreationViewBody({
    super.key,
  });

  @override
  State<AgencyCreationViewBody> createState() => _AgencyCreationViewBodyState();
}

class _AgencyCreationViewBodyState extends State<AgencyCreationViewBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? imageFile;
  File? imageFile2;
  File? imageFile3;
  String mycountry="";
  bool showPickedFile = false;
  bool showPickedFile2 = false;
  bool showPickedFile3 = false;
  TextEditingController _namefield = TextEditingController();
  TextEditingController _definefiled = TextEditingController();
  TextEditingController _mainemail = TextEditingController();
  Random random = new Random();
  bool _showspinner=false;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text("Hayaa", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showPickedFile == false
                  ? CustomImagePicker(
                      screenWidth: screenWidth,
                      onTap: () {
                        _pickImage();
                      },
                    )
                  : InkWell(
                      onTap: () {
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
                tOne: "Agency Name ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _namefield,
                decoration: InputDecoration(
                    hintText: "Please Enter Name",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "Definition Of Agency ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _definefiled,
                style: const TextStyle(fontSize: 22),
                maxLength: 300,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Please Define Your Agency",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SeperatedText(
                tOne: "Mean Of Communication ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _mainemail,
                decoration: InputDecoration(
                    hintText: "Please Enter Your E-mail",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "A Photo Of The ID Card ",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    showPickedFile2==false?GestureDetector(
                      onTap: () {
                        _pickImage2();
                      },
                      child: Container(
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
                      ),
                    ):InkWell(
                      onTap: (){
                        _pickImage();
                      },
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: showPickedFile2
                            ? FileImage(imageFile2!)
                            : AssetImage(AppImages.UserImage) as ImageProvider,
                      ),
                    ),
                    showPickedFile3==false?GestureDetector(
                      onTap: () {
                        _pickImage3();
                      },
                      child: Container(
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
                      ),
                    ):InkWell(
                      onTap: (){
                        _pickImage();
                      },
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: showPickedFile3
                            ? FileImage(imageFile3!)
                            : AssetImage(AppImages.UserImage) as ImageProvider,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SeperatedText(
                tOne: "Country",
                tTwo: "*",
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    exclude: <String>['KN', 'MF'],
                    favorite: <String>['SE'],
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      mycountry=country.toString().split(" ")[3].split(")")[0];
                      print('Select country: ${mycountry}');
                    },
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      // Optional. Styles the search field.
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                      searchTextStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                child:Text('اختار دولتك').tr(args: ['اختار دولتك']),
              ),
              const SizedBox(
                height: 30,
              ),
              GradiantButton(
                  screenWidth: screenWidth,
                  buttonLabel: "Create Agency ",
                  onPressed: () async{
                    if(imageFile==null){
                      AllarmError("برجاء اختيار صورة للوكالة");
                    }
                    else if(_namefield.text==""){
                      AllarmError("برجاء ادخال اسم للوكالة");
                    }
                    else if(_definefiled.text==""){
                      AllarmError("برجاء ادخال تعريف للوكالة");
                    }
                    else if(_mainemail.text==""){
                      AllarmError("برجاء ادخال بريد للوكالة");
                    }
                    else if(imageFile2==null){
                      AllarmError("برجاء رفع وجه البطاقة الشخصية");
                    }
                    else if(imageFile3==null){
                      AllarmError("برجاء رفع ظهر البطاقة الشخصية");
                    }
                    else if(mycountry==""){
                      AllarmError("برجاء ادخال الدولة");
                    }
                    else{
                      Allarm();
                    }
                    //Navigator.pushNamed(context, AgencyAgentView.id);
                  },
                  buttonRatio: 0.8),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
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
                  Text("هل انت متاكد من انشاء هذه الوكالة"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        Navigator.pop(context);
                        setState(() {
                          _showspinner = true;
                        });
                        String idd="";
                        for(int i=0;i<8;i++){
                          int randomNumber = random.nextInt(10);
                          idd="$idd$randomNumber";
                        }
                        img.Image image=img.decodeImage(imageFile!.readAsBytesSync())!;
                        img.Image compressedImage = img.copyResize(image, width: 800);
                        File compressedFile = File('${imageFile!.path}_compressed.jpg')
                          ..writeAsBytesSync(img.encodeJpg(compressedImage));
                        final path = "agent/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
                        final ref = FirebaseStorage.instance.ref().child(path);
                        final uploadTask = ref.putFile(compressedFile);
                        final snapshot = await uploadTask.whenComplete(() {});
                        final urlDownload = await snapshot.ref.getDownloadURL();
                        print("Download Link : $urlDownload");
                        img.Image image2=img.decodeImage(imageFile2!.readAsBytesSync())!;
                        img.Image compressedImage2 = img.copyResize(image2, width: 800);
                        File compressedFile2 = File('${imageFile2!.path}_compressed.jpg')
                          ..writeAsBytesSync(img.encodeJpg(compressedImage2));
                        final path2 = "agent/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
                        final ref2 = FirebaseStorage.instance.ref().child(path2);
                        final uploadTask2 = ref2.putFile(compressedFile2);
                        final snapshot2 = await uploadTask2.whenComplete(() {});
                        final urlDownload2 = await snapshot2.ref.getDownloadURL();
                        print("Download Link : $urlDownload2");
                        img.Image image3=img.decodeImage(imageFile3!.readAsBytesSync())!;
                        img.Image compressedImage3 = img.copyResize(image3, width: 800);
                        File compressedFile3 = File('${imageFile3!.path}_compressed.jpg')
                          ..writeAsBytesSync(img.encodeJpg(compressedImage3));
                        final path3 = "agent/photos/${_auth.currentUser!.uid}-${DateTime.now().toString()}.jpg";
                        final ref3 = FirebaseStorage.instance.ref().child(path3);
                        final uploadTask3 = ref3.putFile(compressedFile3);
                        final snapshot3 = await uploadTask3.whenComplete(() {});
                        final urlDownload3 = await snapshot3.ref.getDownloadURL();
                        print("Download Link : $urlDownload3");
                        String doc="${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                        await _firestore.collection('agency').doc(doc).set({
                          'bio':_definefiled.text,
                          'name':_namefield.text,
                          'photo':urlDownload,
                          'id':idd,
                          'photo2':urlDownload2,
                          'photo3':urlDownload3,
                          'country':mycountry,
                          'email':_mainemail.text
                        }).then((value){
                          _firestore.collection('agency').doc(doc).collection('users').doc().set({
                            'userid':_auth.currentUser!.uid,
                            'type':'agent',
                            'time':DateTime.now.toString(),
                          }).then((value){
                            _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                              'myagent':doc,
                              'type':'agent'
                            }).then((value){
                              setState(() {
                                _showspinner = false;
                                CreateDone();
                              });
                            });
                          });
                        });
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
                      Text("تم انشاء الوكالة"),
                      ElevatedButton(onPressed: (){
                        Navigator.popAndPushNamed(context, AgencyAgentView.id);
                      }, child: Text("مشاهدة الوكالة"))
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

  _pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile = tempImage;
      showPickedFile = true;
    });
  }
  _pickImage2() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile2 = tempImage;
      showPickedFile2 = true;
    });
  }
  _pickImage3() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      imageFile3 = tempImage;
      showPickedFile3 = true;
    });
  }
}
