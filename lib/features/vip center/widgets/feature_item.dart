import 'package:flutter/material.dart';

import '../models/feature_model.dart';


class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.screenWidth,
    required this.featureModel,
  });

  final double screenWidth;
  final FeatureModel featureModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: screenWidth * 0.19,
          width: screenWidth * 0.19,
          decoration: BoxDecoration(
              color: featureModel.active ? Colors.transparent : Colors.black54,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image(image: AssetImage(featureModel.featureIcon)),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(featureModel.featureLable,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
