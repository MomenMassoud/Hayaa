import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconnect2/screens/CreateAccound_Login/sign_up_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Custom_Wedgit/my_button.dart';
import '../HomeScreens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String ScreenRoute = 'login_screen';

  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = "";
  String pass = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Background color
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage("assets/logo2.jpg"),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Bibgo',
                          style: TextStyle(
                            fontSize: 60,
                            color: Colors.blue[900],
                            fontFamily: "Signatra",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          cursorColor: Colors.blue[900],
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "برجاء ادخال البريد الالكتروني",
                            filled: true,
                            fillColor: Colors.grey[100], // Change the background color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Colors.blue[900],
                          onChanged: (value) {
                            pass = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: "برجاء ادخال كلمة السر",
                            filled: true,
                            fillColor: Colors.grey[100], // Change the background color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text("نسيت كلمة السر"),
                            ),
                          ],
                        ),
                        MyButton(
                          color: Colors.blue, // Change button color
                          title: 'تسجيل الدخول',
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            final newUser = await _auth.signInWithEmailAndPassword(email: email, password: pass);
                            if (newUser != null) {
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.pushNamed(context, HomeScreen.ScreenRoute);
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, SignUpScreen.ScreenRoute);
                              },
                              child: Text("انشاء حساب جديد"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),

            ),
          ),
        ),
      ),
    );
  }
}
