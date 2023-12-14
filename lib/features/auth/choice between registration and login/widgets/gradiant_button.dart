import 'package:flutter/material.dart';

import '../../../../core/Utils/app_colors.dart';

class GradiantButton extends StatelessWidget {
  const GradiantButton({
    Key? key,
    required this.screenWidth,
    required this.buttonLabel,
    required this.onPressed, required this.buttonRatio,
  }) : super(key: key);

  final double screenWidth;
  final String buttonLabel;
  final double buttonRatio;


  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * buttonRatio,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.appPrimaryColors600,
            AppColors.appPrimaryColors300,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the border radius as needed
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            buttonLabel,
            style: TextStyle(
              fontFamily: "Hayah",
              color: Colors.white,
              fontSize: screenWidth * 0.08,
            ),
          ),
        ),
      ),
    );
  }
}






// class GradiantButton extends StatelessWidget {
//   const GradiantButton({
//     super.key,
//     required this.screenWidth,
//     required this.buttonLabel,
//   });

//   final double screenWidth;
//   final String buttonLabel;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(
//                   20.0), // Adjust the border radius as needed
//             ),
//           ),
//         ),
//         onPressed: () {},
//         child: Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: 5),
//           child: Text(
//             buttonLabel,
//             style: TextStyle(fontFamily: "Hayah", fontSize: screenWidth * 0.08),
//           ),
//         ));
//   }
// }
