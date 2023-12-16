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
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          color: Colors.blueGrey,
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
                    Text("لقد استلمت هدية"),
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