import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/agencies/views/agency_agent_view.dart';
import 'package:hayaa_main/features/agencies/widgets/custom_image_picker.dart';
import 'package:hayaa_main/features/agencies/widgets/seperated_text.dart';
import 'package:hayaa_main/features/auth/choice%20between%20registration%20and%20login/widgets/gradiant_button.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../core/Utils/app_images.dart';
import '../../../core/Utils/supabase_helper.dart';

class AgencyCreationViewBody extends StatefulWidget {
  const AgencyCreationViewBody({super.key});

  @override
  State<AgencyCreationViewBody> createState() => _AgencyCreationViewBodyState();
}

class _AgencyCreationViewBodyState extends State<AgencyCreationViewBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;
  File? imageFile2;
  File? imageFile3;
  String mycountry = "";
  bool showPickedFile = false;
  bool showPickedFile2 = false;
  bool showPickedFile3 = false;
  TextEditingController _namefield = TextEditingController();
  TextEditingController _definefiled = TextEditingController();
  TextEditingController _mainemail = TextEditingController();
  Random random = new Random();
  bool _showspinner = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Hayaa", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showPickedFile == false
                    ? CustomImagePicker(
                        screenWidth: screenWidth,
                        onTap: () { _pickImage(); },
                      )
                    : InkWell(
                        onTap: () { _pickImage(); },
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: FileImage(imageFile!),
                        ),
                      ),
                const SeperatedText(tOne: "Agency Name ", tTwo: "*"),
                const SizedBox(height: 10),
                TextField(
                  controller: _namefield,
                  decoration: InputDecoration(
                    hintText: "Please Enter Name",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
                const SizedBox(height: 30),
                const SeperatedText(tOne: "Definition Of Agency ", tTwo: "*"),
                const SizedBox(height: 10),
                TextField(
                  controller: _definefiled,
                  style: const TextStyle(fontSize: 22),
                  maxLength: 300,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Please Define Your Agency",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
                const SeperatedText(tOne: "Mean Of Communication ", tTwo: "*"),
                const SizedBox(height: 10),
                TextField(
                  controller: _mainemail,
                  decoration: InputDecoration(
                    hintText: "Please Enter Your E-mail",
                    hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
                const SizedBox(height: 30),
                const SeperatedText(tOne: "A Photo Of The ID Card ", tTwo: "*"),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      showPickedFile2 == false
                          ? GestureDetector(
                              onTap: () { _pickImage2(); },
                              child: Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(Icons.add, size: screenWidth * 0.2, color: Colors.blueGrey),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () { _pickImage2(); },
                              child: CircleAvatar(
                                radius: 75,
                                backgroundImage: FileImage(imageFile2!),
                              ),
                            ),
                      showPickedFile3 == false
                          ? GestureDetector(
                              onTap: () { _pickImage3(); },
                              child: Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(Icons.add, size: screenWidth * 0.2, color: Colors.blueGrey),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () { _pickImage3(); },
                              child: CircleAvatar(
                                radius: 75,
                                backgroundImage: FileImage(imageFile3!),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const SeperatedText(tOne: "Country", tTwo: "*"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    showCountryPicker(
                      context: context,
                      exclude: <String>['KN', 'MF'],
                      favorite: <String>['SE'],
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        mycountry = country.toString().split(" ")[3].split(")")[0];
                      },
                      countryListTheme: CountryListThemeData(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
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
                        searchTextStyle: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    );
                  },
                  child: Text('اختار دولتك').tr(args: ['اختار دولتك']),
                ),
                const SizedBox(height: 30),
                GradiantButton(
                  screenWidth: screenWidth,
                  buttonLabel: "Create Agency ",
                  onPressed: () async {
                    if (imageFile == null) {
                      AllarmError("برجاء اختيار صورة للوكالة");
                    } else if (_namefield.text == "") {
                      AllarmError("برجاء ادخال اسم للوكالة");
                    } else if (_definefiled.text == "") {
                      AllarmError("برجاء ادخال تعريف للوكالة");
                    } else if (_mainemail.text == "") {
                      AllarmError("برجاء ادخال بريد للوكالة");
                    } else if (imageFile2 == null) {
                      AllarmError("برجاء رفع وجه البطاقة الشخصية");
                    } else if (imageFile3 == null) {
                      AllarmError("برجاء رفع ظهر البطاقة الشخصية");
                    } else if (mycountry == "") {
                      AllarmError("برجاء ادخال الدولة");
                    } else {
                      Allarm();
                    }
                  },
                  buttonRatio: 0.8,
                ),
                const SizedBox(height: 30),
              ],
            ),
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
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() { _showspinner = true; });
                      try {
                        String idd = "";
                        for (int i = 0; i < 8; i++) {
                          idd = "$idd${random.nextInt(10)}";
                        }

                        File compressed1 = _compressImage(imageFile!);
                        File compressed2 = _compressImage(imageFile2!);
                        File compressed3 = _compressImage(imageFile3!);

                        final urlDownload  = await SupabaseHelper.uploadImage(compressed1);
                        final urlDownload2 = await SupabaseHelper.uploadImage(compressed2);
                        final urlDownload3 = await SupabaseHelper.uploadImage(compressed3);

                        print("✅ صورة 1: $urlDownload");
                        print("✅ صورة 2: $urlDownload2");
                        print("✅ صورة 3: $urlDownload3");

                        String doc = "${DateTime.now().toString()}-${_auth.currentUser!.uid}";
                        await _firestore.collection('agency').doc(doc).set({
                          'bio': _definefiled.text,
                          'name': _namefield.text,
                          'doc': doc,
                          'photo': urlDownload,
                          'id': idd,
                          'photo2': urlDownload2,
                          'photo3': urlDownload3,
                          'country': mycountry,
                          'email': _mainemail.text,
                        });

                        await _firestore.collection('agency').doc(doc).collection('users').doc().set({
                          'userid': _auth.currentUser!.uid,
                          'type': 'agent',
                          'time': DateTime.now().toString(),
                        });

                        await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                          'myagent': doc,
                          'type': 'agent',
                        });

                        setState(() { _showspinner = false; });
                        CreateDone();
                      } catch (e) {
                        setState(() { _showspinner = false; });
                        AllarmError("حدث خطأ: $e");
                      }
                    },
                    child: Text("انشاء"),
                  ),
                  ElevatedButton(
                    onPressed: () { Navigator.pop(context); },
                    child: Text("الغاء"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  File _compressImage(File file) {
    img.Image image = img.decodeImage(file.readAsBytesSync())!;
    img.Image compressed = img.copyResize(image, width: 800);
    File result = File('${file.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(compressed));
    return result;
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, AgencyAgentView.id);
                  },
                  child: Text("مشاهدة الوكالة"),
                ),
              ],
            ),
          ),
        );
      },
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
              SizedBox(height: 70),
              ElevatedButton(
                onPressed: () { Navigator.pop(context); },
                child: Text("تعديل"),
              ),
            ],
          ),
        );
      },
    );
  }

  _pickImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    setState(() { imageFile = File(xFile.path); showPickedFile = true; });
  }

  _pickImage2() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    setState(() { imageFile2 = File(xFile.path); showPickedFile2 = true; });
  }

  _pickImage3() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    setState(() { imageFile3 = File(xFile.path); showPickedFile3 = true; });
  }
}
