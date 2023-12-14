import 'package:flutter/material.dart';

import '../../../core/Utils/app_images.dart';



class CustomCardGame extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle
      ),
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Image
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.ludo), // Replace with your game image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Game Details
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ludo',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Developer: Game Developer',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Release Date: January 1, 2023',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            // View Game Button
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement the action to view the game
                  print('View Game button pressed');
                },
                child: Text('View Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}