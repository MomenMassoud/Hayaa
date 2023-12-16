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
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          color: Color(0xffdcf8c6),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 80,
                  top: 9,
                  bottom: 20,
                ),
                child:Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("لقد ارسلت هدية"),
                    type=="svga"?CircleAvatar(
                      child: SVGASimpleImage(
                        resUrl: path,
                      ),
                    ):CircleAvatar(
                      child: CachedNetworkImage(imageUrl: path),
                    ),
                  ],
                )
              ),

            ],
          ),
        ),
      ),
    );
  }

}