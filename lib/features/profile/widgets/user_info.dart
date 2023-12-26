import 'package:flutter/material.dart';

class UserInfoo extends StatelessWidget {
   UserInfoo({
    required this.screenWidth,
  });
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: screenWidth * 0.05,
          width: screenWidth * 0.12,
          decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.male,
                color: Colors.white,
                size: 20,
              ),
              Text(
                "20",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          height: screenWidth * 0.05,
          width: screenWidth * 0.12,
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.star,
                color: Colors.white,
                size: 20,
              ),
              Text(
                "6",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          height: screenWidth * 0.05,
          width: screenWidth * 0.12,
          decoration: const BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20,
              ),
              Text(
                "16",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        )
      ],
    );
  }
}
