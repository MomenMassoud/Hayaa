import 'package:flutter/material.dart';

class VipList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
        height: 220,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.pink,
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Call your function to display every 3 images with special text
            buildImageRows(),
            SizedBox(height: 10),
            // Add the buttons and text
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
      'lib/core/Utils/assets/images/1.png',
      'lib/core/Utils/assets/images/2.png',
      'lib/core/Utils/assets/images/3.png',
      'lib/core/Utils/assets/images/4.png',
      'lib/core/Utils/assets/images/5.png',
      'lib/core/Utils/assets/images/6.png',
      'lib/core/Utils/assets/images/1.png',
      'lib/core/Utils/assets/images/2.png',
      'lib/core/Utils/assets/images/3.png',
      'lib/core/Utils/assets/images/4.png',
      'lib/core/Utils/assets/images/5.png',
      'lib/core/Utils/assets/images/6.png',
      // Add more image paths as needed
    ];

    List<String> imageTexts = [
      'Text 1',
      'Text 2',
      'Text 3',
      'Text 4',
      'Text 5',
      'Text 6',
      'Text 1',
      'Text 2',
      'Text 3',
      'Text 4',
      'Text 5',
      'Text 6',
      // Add more texts as needed
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
                    color: Colors.white,
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
        ElevatedButton(
          onPressed: () {
            // Handle button 1 press
          },
          child: Text('Button 1'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle button 2 press
          },
          child: Text('Button 2'),
        ),
        Text(
          'Right Text',
          style: TextStyle(
            fontFamily: 'Varela',
            fontSize: 12,
            color: Color(0xFFCDCDCD),
          ),
        ),
      ],
    );
  }
}
