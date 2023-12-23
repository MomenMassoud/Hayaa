import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/Utils/app_images.dart';



class SaleryBody extends StatefulWidget{
  _SaleryBody createState()=>_SaleryBody();
}


class _SaleryBody extends State<SaleryBody>{
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  String coin="";
  String number="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 243, 255, 1),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("دخل",style: TextStyle(fontSize: 16,color: Colors.black),).tr(args: ['دخل']),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppImages.gold_coin),
                radius: 12,
              ),
              Text(coin,style: TextStyle(fontSize: 19),)
            ],
          )
        ],
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream:_auth.currentUser!.email==null? _firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.phoneNumber).snapshots():_firestore.collection('user').where('email',isEqualTo: _auth.currentUser!.email).snapshots(),
        builder: (context,snapshot){
          String daimond="";
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final masseges = snapshot.data?.docs;
          for (var massege in masseges!.reversed) {
            daimond=massege.get('daimond');
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 13),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("الالماس المتاح",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),).tr(args: ['الالماس المتاح']),
                      SizedBox(height: 30,),
                      CircleAvatar(
                        backgroundImage: AssetImage(AppImages.daimond),
                        radius: 60,
                      ),
                      Text(daimond,style: TextStyle(fontSize: 22),),
                      SizedBox(height: 30,),
                      Text("100 Diamond => 70 coin"),
                      SizedBox(height: 30,),
                      Card(
                        margin: const EdgeInsets.only(
                            left: 7, right: 7, bottom: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: TextField(
                          onChanged: (value){
                            if(value==null){
                              number="";
                            }
                            else if(value==""){
                              number="";
                            }
                            else{
                              number="$value";
                              print(number);
                            }
                          },
                          controller: _controller,
                          textAlignVertical: TextAlignVertical.center,
                          maxLines: 1,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                            hintText: "Minimum 1000 Diamond to change to coins",
                            hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.all(8)
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: ()async{
                        if(number!=""){
                          double value=double.parse(number);
                          if(value>=1000){
                            double coinValue = value; // Initial value of the coin
                            double discountPercentage = 30.0; // Discount percentage
                            double discount = (discountPercentage / 100) * coinValue;
                            double discountedValue = coinValue - discount;
                            double newCoinValue = discountedValue;
                            int mycoins=int.parse(coin);
                            mycoins=mycoins+newCoinValue.toInt();
                            int newDaimont = int.parse(daimond)-int.parse(number);
                            Allarm(newCoinValue.toInt(),int.parse(number),mycoins,newDaimont);
                          }
                          else{
                            NotSend();
                          }
                        }
                        else{
                          NotSend();
                        }
                      }, child: Text("تحويل",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),))
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      )
    );
  }
  void getCoin()async{
    await for(var snap in  _firestore.collection('user').doc(_auth.currentUser!.uid).snapshots()){
      setState(() {
        coin=snap.get('coin');
      });
    }
  }
  double calculateDiscount(double originalValue, double discountPercentage) {
    if (originalValue <= 0 || discountPercentage < 0 || discountPercentage > 100) {
      throw ArgumentError('Invalid input values');
    }

    double discount = (discountPercentage / 100) * originalValue;
    double discountedValue = originalValue - discount;

    return discountedValue;
  }
  void Allarm(int coin,int Daimond,int newCoin,int newDaimond) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ملحوظة"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("هل انت متاكد من تحويل $Daimond ماسة الي $coin عملة ذهبية"),
                  SizedBox(height: 70,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: ()async{
                        if(newDaimond<0){
                          NotSend();
                        }
                        else{
                          await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
                            'coin':newCoin.toString(),
                            'daimond':newDaimond.toString(),
                          }).then((value){
                            _controller.clear();
                            Navigator.pop(context);
                            SendDone();
                          });
                        }
                      }, child: Text("تحويل")),
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
  void SendDone() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("مبروك"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("تم التحويل بنجاح"),
                ),
              )
          );
        });
  }
  void NotSend() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("ناسف"),
              content: Container(
                height: 120,
                child: Center(
                  child: Text("برجاء مراجعة الحد الادني للتحويل و رصيد الجواهر"),
                ),
              )
          );
        });
  }
}