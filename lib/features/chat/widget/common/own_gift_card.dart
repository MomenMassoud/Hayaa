import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';


class OwnGiftCard extends StatelessWidget{
  String path;
  String type;
  OwnGiftCard(this.path,this.type);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:type=="svga"?CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: SVGASimpleImage(
                  resUrl: path,
                ),
              ):Container(
                height: 80,
                  width: 80,
                  child: CachedNetworkImage(imageUrl: path)
              ),
            ),
          ],
        ),
      ),
    );
  }

}