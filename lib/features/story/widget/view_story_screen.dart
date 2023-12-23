import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import '../../../models/user_model.dart';

class ViewStoryScreen extends StatefulWidget{
  UserModel user;
  ViewStoryScreen(this.user, {super.key});
  @override
  _ViewStoryScreen createState()=>_ViewStoryScreen();

}
class _ViewStoryScreen extends State<ViewStoryScreen>{
  int ii=0;
  final _auth =FirebaseAuth.instance;
  final StoryController controller = StoryController();
  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItemss = [];
    for(int i=0;i<widget.user.storys.length;i++){
      StoryItem s;
      if(widget.user.storys[i].type=="text"){
        s = StoryItem.text(title: widget.user.storys[i].text, backgroundColor: Colors.black,roundedTop: true);
      }
      else if(widget.user.storys[i].type=="vedio"){
        s = StoryItem.pageVideo(widget.user.storys[i].media, controller: controller,caption: widget.user.storys[i].text);
      }
      else{
        s = StoryItem.pageImage(url: widget.user.storys[i].media, controller: controller,caption: widget.user.storys[i].text);
      }
      storyItemss.add(s);
    }
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.lightBlueAccent,
          leadingWidth: 70,
          title: Text(widget.user.name),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    widget.user.photo==""?const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("Images/pop.jpg"),
                    ):CircleAvatar(
                      radius: 20,
                      backgroundImage:CachedNetworkImageProvider(widget.user.photo),
                    )
                  ]
              )
          )
      ),
      body: widget.user.email==_auth.currentUser!.email?SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StoryView(
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
          controller: controller,
          inline: true,
          onComplete: () {
            Navigator.pop(context);
          },
          storyItems: storyItemss,
        ),
      ):StoryView(
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
        indicatorColor: Colors.white,
        controller: controller,
        inline: true,
        onComplete: () {
          Navigator.pop(context);
        },
        storyItems: storyItemss,
      ),
    );
  }

}