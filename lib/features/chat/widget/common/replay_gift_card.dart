import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/player.dart';


class ReplayGiftCard extends StatelessWidget{
  String path;
  String type;
  ReplayGiftCard(this.path,this.type);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 80,
                top: 9,
                bottom: 20,
              ),
              child:type=="svga"?SVGASimpleImage(
                resUrl: path,
              ):Container(
                  height: 80,
                  width: 80,
                  child: CachedNetworkImage(imageUrl: path)),
            ),
          ],
        ),
      ),
    );
  }

}