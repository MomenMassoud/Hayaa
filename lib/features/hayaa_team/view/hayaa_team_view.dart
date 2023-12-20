import 'package:flutter/material.dart';
import '../widget/hayaa_team_body.dart';

class HayaaTeamView extends StatefulWidget{
  static const  id ='HayaaTeamView';
  _HayaaTeamView createState()=>_HayaaTeamView();
}

class _HayaaTeamView extends State<HayaaTeamView>{
  @override
  Widget build(BuildContext context) {
    return HayaaTeamBody();
  }
}