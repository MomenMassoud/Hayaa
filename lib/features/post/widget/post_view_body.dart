import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hayaa_main/features/post/view/create_post_view.dart';
import 'package:hayaa_main/features/post/widget/post_followers.dart';
import 'package:hayaa_main/features/post/widget/post_friends.dart';
import 'package:hayaa_main/features/post/widget/post_popular.dart';
import 'package:hayaa_main/features/story/view/story_view_screen.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../core/Utils/app_colors.dart';
import '../../agencies/widgets/seperated_text.dart';

class PostViewBody extends StatefulWidget{
  _PostViewBody createState()=>_PostViewBody();
}


class _PostViewBody extends State<PostViewBody>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  TextEditingController _namefield=TextEditingController();
  bool showPickedFile = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  File? imageFile;
  bool _showspinner=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          // height: screenHight * 0.12,
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
        leading: IconButton(onPressed: (){Navigator.pushNamed(context, CreatePostView.id);}, icon: Icon(Icons.add_circle_outline,color: Colors.white,)),
        actions: [
          Row(
            children: [
              TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.white, // Color of the selected tab label// Color of unselected tab labels
                  indicatorColor: Colors.orange,
                  indicatorSize: TabBarIndicatorSize.label,
                  enableFeedback: true,
                  tabs:<Widget> [
                    Tab(child:SizedBox(
                      width: screenWidth * 0.12,
                      child:  Text(
                        "شعبي",
                        style: TextStyle(fontFamily: "Hayah", fontSize: 20,color: Colors.white),
                      ),
                    ),),
                    Tab(child:SizedBox(
                      width: screenWidth * 0.12,
                      child:  Text(
                        "اصدقاء",
                        style: TextStyle(fontFamily: "Hayah", fontSize: 20,color: Colors.white),
                      ),
                    ),),
                    Tab(child:SizedBox(
                      width: screenWidth * 0.12,
                      child:  Text(
                        "متابعين",
                        style: TextStyle(fontFamily: "Hayah", fontSize: 20,color: Colors.white),
                      ),
                    ),),
                  ]
              ),
            ],
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showspinner,
        child: ListView(

          children: [
            Container(
                height: 150,
                child: StoryViewScreen()),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Container(
                height: 600,
                child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      PostPopular(),
                      PostFriends(),
                      PostFollowers()
                    ]
                ),
              ),
            ),
          ],
        ),
      )
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