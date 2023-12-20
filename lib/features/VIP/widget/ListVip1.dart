import 'package:flutter/material.dart';
import 'package:hayaa_main/core/Utils/app_images.dart';

class VipList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      child: Container(
        //color: Colors.cyan,
        padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
        height: 220,
        decoration: const BoxDecoration(
          //color: Color(0xa1696868),
            image: DecorationImage(
              image: AssetImage('lib/core/Utils/assets/images/vip5.jpeg'),
              // Replace with your image asset
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                topRight: Radius.circular(100))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            buildImageRows(),
            SizedBox(height: 10),
            buildAdditionalButtons(),
          ],
        ),
      ),
    );
  }
  // Function to display every 3 images with special text in rows
  Widget buildImageRows() {
    // Replace this with your logic to get images from your PC
    List<String> imagePaths = [
      AppImages.vip1,
      AppImages.vip2,
      AppImages.vip3,
      AppImages.vip4,
      AppImages.vip5,
      AppImages.vip6,
      AppImages.vip7,
      AppImages.vip8,
      AppImages.vip9,
      AppImages.vip1,
      AppImages.vip2,
      AppImages.vip3,
      // Add more image paths as needed
    ];

    List<String> imageTexts = [
      'ايقونه vip',
      'برواويز',
      'مؤثرات',
      'سياره',
      'الاصدقاء',
      'متابعه',
      'نص ملون',
      'ايقونه vip',
      'برواويز',
      'مؤثرات',
      'سياره',
      'الاصدقاء',
      'متابعه',      // Add more texts as needed
    ];

    List<Widget> rows = [];
    for (int i = 0; i < imagePaths.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 3 && j < imagePaths.length; j++) {
        rowChildren.add(
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imagePaths[j]),
                  radius: 24,
                ),
                SizedBox(height: 10),
                Text(
                  imageTexts[j],
                  style: TextStyle(
                    color: Color(0xFFC7C3C3),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
    }

    return Column(
      children: rows,
    );
  }

  // Function to build additional buttons and text
  Widget buildAdditionalButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle button 1 press
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
              ),
              child: Text('شراء'),

            ),
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: () {
                // Handle button 2 press
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
              ),
              child: Text('ارسال'),
            ),
          ],
        ),
        Text(
          '500 gold',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 20,
            color: Color(0xFFE0FF02),
          ),
        ),
      ],
    );
  }
}
