import 'package:flutter/material.dart';
import 'package:hayaa_main/features/games/widgets/sub_games.dart';



class SubGameList extends StatelessWidget{
  List<SubGames> games;
  SubGameList(this.games);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: games[index],
      );
    });
  }

}