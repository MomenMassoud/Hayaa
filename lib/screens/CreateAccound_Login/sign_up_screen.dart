import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Custom_Wedgit/my_button.dart';

class SignUpScreen extends StatefulWidget {
  static const String ScreenRoute = 'sign_up_screen';

  _SignUpScreen createState() => _SignUpScreen();
}

enum Gender { male, female }

class _SignUpScreen extends State<SignUpScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showPickedFile = false;
  File? imageFile;
  Gender gender = Gender.male;
  String name = "", email = "", password = "", confirmPassword = "";
  bool showSpinner = false;
  late var link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("انشاء حساب جديد"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: ModalProgressHUD(
          color: Colors.yellow,
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeIn,
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: showPickedFile ? Colors.transparent : Colors.blue,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: showPickedFile
                            ? FileImage(imageFile!)
                            : AssetImage('assets/user.jpeg') as ImageProvider,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blue[900],
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                    hintText: "ادخل اسمك بالكامل",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blue[900],
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "ادخل البريد الالكتروني",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blue[900],
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    hintText: "ادخل كلمة السر",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  cursorColor: Colors.blue[900],
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    hintText: "تأكيد كلمة السر",
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: Gender.male,
                          groupValue: gender,
                          onChanged: (Gender? g) {
                            setState(() {
                              gender = g!;
                            });
                          },
                        ),
                        Text('ذكر'),
                      ],
                    ),
                    SizedBox(width: 50),
                    Row(
                      children: [
                        Radio(
                          value: Gender.female,
                          groupValue: gender,
                          onChanged: (Gender? g) {
                            setState(() {
                              gender = g!;
                            });
                          },
                        ),
                        Text('أنثى'),
                      ],
                    ),
                  ],
                ),
                MyButton(
                  color: Colors.blue,
                  title: 'انشاء الحساب',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    Create();
                  },
                ),
              ],
            ),
          ),
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

  void Create() async {
    try {
      final path = "profile_photos/NewAccountIconnect-${DateTime.now().toString()}.jpg";
      final file = File(imageFile!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      link = urlDownload;
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.updateDisplayName(name);
      if (imageFile != null) {
        await _firestore.collection('user').doc(_auth.currentUser!.uid).set({
          'name': name,
          'email': email,
          'gender': gender.toString(),
          'bio': "Hi, I use MeMo",
          'photo': link,
          'seen': 'online',
          'coin': '100',
          'devicetoken': '',
        });
      } else {
        await _firestore.collection('user').doc(_auth.currentUser!.uid).set({
          'name': name,
          'email': email,
          'gender': gender.toString(),
          'bio': "Hi, I use MeMo",
          'photo': "",
          'seen': 'online',
          'coin': '100',
          'devicetoken': '',
        });
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }
}
