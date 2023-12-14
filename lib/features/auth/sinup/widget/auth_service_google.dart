import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceGoogle{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  Random random = new Random();
  signInWithGoogle()async{
    //interactive SignIn
    final GoogleSignInAccount? gUser =await GoogleSignIn().signIn();
    // auth request
    final GoogleSignInAuthentication gAuth=await gUser!.authentication;
    //credaintial
    final credential=GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );
    //let signin
    return await FirebaseAuth.instance.signInWithCredential(credential).then((value){
      String id="";
      _firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.email).get().then((value){
        if(value.size==0){
          for(int i=0;i<8;i++){
            int randomNumber = random.nextInt(10);
            id="$id$randomNumber";
          }
          _firestore.collection('user').doc(_auth.currentUser!.uid).set({
            'name': _auth.currentUser?.displayName,
            'email': _auth.currentUser?.email,
            'gender': "male",
            'bio': "Hi,I Use Hayaa",
            'photo': _auth.currentUser?.photoURL,
            'seen': 'online',
            'devicetoken': '',
            'country':"US",
            'lang':'en',
            'coin':'250',
            'vip':'0',
            'level':'0',
            'birthdate':'',
            'phonenumber':'',
            'type':'normal',
            'id':id,
            'exp':'0',
            'daimond':'0'
          });
        }
      });
    });
  }
}