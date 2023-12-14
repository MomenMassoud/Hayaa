import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/Utils/app_colors.dart';
import '../../../../core/Utils/app_images.dart';
import '../../../home/views/home_view.dart';
import '../../../splash/widgets/gradient_container.dart';
import '../../choice between registration and login/views/privacy_terms_view.dart';
import '../../choice between registration and login/views/user_agreement_view.dart';
import '../../choice between registration and login/widgets/gradiant_button.dart';
import '../../choice between registration and login/widgets/navigator_text.dart';
import '../../login/widgets/custom_text_form_field.dart';


class SignupViewBody extends StatefulWidget{
  _SignupViewBody createState()=>_SignupViewBody();
}
enum Gender { male, female }
class _SignupViewBody extends State<SignupViewBody>{
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String phoneNum;
  late String password;
  DateTime? _selectedDate;
  bool showSpinner = false;
  bool showPickedFile = false;
  File? imageFile;
  String phone = "";
  String number = "";
  Gender gender = Gender.male;
  String strDate = 'Not Selected';
  TextEditingController _phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GradientContainer(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            colorOne: AppColors.appPrimaryColors800,
            colorTwo: AppColors.appPrimaryColors400,
          ),
          SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                AppImages.waterMarkImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: ListView(
              children: [
               Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   SizedBox(
                     width: screenWidth * 0.45,
                     child: Image.asset(AppImages.appPLogo),
                   ),
                   const SizedBox(
                     height: 40,
                   ),
                   Text(
                     "أهلا ضيفنا",
                     style: TextStyle(
                       fontFamily: "Hayah",
                       color: Colors.white,
                       fontSize: 80,
                     ),
                   ).tr(args: ["أهلا ضيفنا"]),
                   Form(
                     key: formkey,
                     child: Column(
                       children: [
                         GestureDetector(
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
                                   : AssetImage(AppImages.UserImage) as ImageProvider,
                             ),
                           ),
                         ),
                         const SizedBox(
                           height: 10,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             CustomTextFormField(
                               screenWidth: screenWidth,
                               autovalidateMode: autovalidateMode,
                               fieldIcon: const Icon(
                                 Icons.edit,
                               ),
                               fielldRatio: 0.8,
                               hintText: "الاسم".tr(args: ['الاسم']),
                               onSaved: (value) {
                                 password = value!;
                               },
                             ),

                           ],
                         ),
                         const SizedBox(
                           height: 20,
                         ),
                         Padding(
                           padding: EdgeInsets.only(right: 30,left: 30),
                           child: Container(
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(14),
                               shape: BoxShape.rectangle
                             ),
                             child: IntlPhoneField(
                               controller: _phoneNumber,
                               onChanged: (value) {
                                 phone = value.completeNumber;
                                 number = value.number;
                               },
                               decoration: InputDecoration(
                                   labelText: 'رقم الهاتف'.tr(args: ['رقم الهاتف']),
                                   fillColor: Colors.white,
                                   focusColor: Colors.white,
                                   border: OutlineInputBorder(
                                     borderSide: BorderSide(),
                                   )),
                             ),
                           ),
                         ),
                         SizedBox(height: 30,),
                         Padding(
                           padding:EdgeInsets.only(right: 30,left: 30),
                           child: Container(
                             decoration: BoxDecoration(
                               color: Colors.white,
                                 borderRadius: BorderRadius.circular(14),
                                 shape: BoxShape.rectangle
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 Text("ادخل تاريخ الميلاد",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),).tr(args: ['ادخل تاريخ الميلاد']),
                                 Text(strDate),
                                 ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                       primary: Color(0xFFD3AE89),
                                     ),
                                     onPressed: () {
                                       showDatePicker(
                                           context: context,
                                           initialDate: DateTime.now(),
                                           //which date will display when user open the picker
                                           firstDate: DateTime(1950),
                                           //what will be the previous supported year in picker
                                           lastDate: DateTime
                                               .now()) //what will be the up to supported date in picker
                                           .then((pickedDate) {
                                         //then usually do the future job
                                         if (pickedDate == null) {
                                           //if user tap cancel then this function will stop
                                           return;
                                         }
                                         setState(() {
                                           //for rebuilding the ui
                                           _selectedDate = pickedDate;
                                           strDate = _selectedDate.toString().split(' ')[0];
                                         });
                                       });
                                     },
                                     child:Text('ادخال').tr(args: ['ادخال'])),
                               ],
                             ),
                           ),
                         ),
                         const SizedBox(
                           height: 30,
                         ),
                         Row(
                           children: [
                             Text("النوع",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),).tr(args: ['النوع']),
                             Row(
                               children: [
                                 Radio(
                                   value: Gender.male,
                                   hoverColor: Colors.black,
                                   groupValue: gender,
                                   onChanged: (Gender? g) {
                                     setState(() {
                                       gender = g!;
                                     });
                                   },
                                 ),
                                 Text("ذكر",style: TextStyle(color: Colors.white),).tr(args: ['ذكر'])
                               ],
                             ),
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
                                 Text('انثي',style: TextStyle(color: Colors.white),).tr(args: ['انثي']),
                               ],
                             ),
                           ],
                         ),
                         const SizedBox(
                           height: 30,
                         ),
                         Row(
                           children: [
                             ElevatedButton(
                               onPressed: () {
                                 showCountryPicker(
                                   context: context,
                                   exclude: <String>['KN', 'MF'],
                                   favorite: <String>['SE'],
                                   showPhoneCode: true,
                                   onSelect: (Country country) {
                                     print('Select country: ${country.displayName}');
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
                           ],
                         ),
                         SizedBox(
                           height: 30,
                         ),
                         GradiantButton(
                             screenWidth: screenWidth,
                             buttonLabel: "تاكيد رقم الهاتف".tr(args: ["تاكيد رقم الهاتف"]),
                             onPressed: () {
                               Navigator.pushReplacementNamed(
                                   context, HomeView.id);
                             },
                             buttonRatio: 0.6),
                         const SizedBox(
                           height: 10,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             NavigatorText(
                               content: "إتفاقيه المستخدم".tr(args: ['إتفاقيه المستخدم']),
                               onTap: () {
                                 Navigator.pushNamed(
                                     context, UserAgreementView.id);
                               },
                             ),
                             const SizedBox(
                               width: 10,
                             ),
                             const Text(
                               "|",
                               style: TextStyle(
                                 fontFamily: "Questv1",
                                 color: Colors.white,
                                 fontSize: 16,
                               ),
                             ),
                             const SizedBox(
                               width: 10,
                             ),
                             NavigatorText(
                               content: "شروط الخصوصية".tr(args: ['شروط الخصوصية']),
                               onTap: () {
                                 Navigator.pushNamed(context, PrivacyTermsView.id);
                               },
                             )
                           ],
                         ),
                         const SizedBox(
                           height: 10,
                         ),
                       ],
                     ),
                   )
                 ],
               )
              ],
            ),
          )
        ],
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