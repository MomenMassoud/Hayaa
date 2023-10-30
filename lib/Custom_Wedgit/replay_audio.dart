import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReplayAudio extends StatefulWidget{
  String urll;String time;String type;String img;
  ReplayAudio(this.urll,this.time,this.type,this.img);
  _ReplayAudio createState()=>_ReplayAudio();
}

class _ReplayAudio extends State<ReplayAudio>{
  bool _isplaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final _audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        _isplaying=event==PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration=event;
      });
    });
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        _position=event;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Card(
            color: Colors.blueGrey,
            margin: EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.type=="audio"?CircleAvatar(
                  backgroundImage:AssetImage("Images/sound.png"),
                  radius: 20,
                ):CircleAvatar(
                  backgroundImage:CachedNetworkImageProvider(widget.img),
                  radius: 20,
                ),
                InkWell(
                    onTap: ()async{
                      if(_isplaying){
                        await _audioPlayer.pause();
                      }
                      else{
                        await _audioPlayer.play(UrlSource(widget.urll));
                      }
                    },
                    child: _isplaying?Icon(Icons.pause):Icon(Icons.play_arrow)
                ),
                Slider(
                    min: 0,
                    inactiveColor: Colors.blueGrey,
                    activeColor: Colors.blue,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value)async{
                      final pp = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(pp);
                      await _audioPlayer.resume();
                      if(_duration==Duration.zero){
                        setState(() {
                          _position=Duration.zero;
                        });
                      }
                    }),
                Text("${formatTime(_position)}/${formatTime(_duration-_position)}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTime(Duration position) {
    String twoDigit(int n)=>n.toString().padLeft(2,'0');
    final hour = twoDigit(position.inHours);
    final minitus=twoDigit(position.inMinutes.remainder(60));
    final secound=twoDigit(position.inSeconds.remainder(60));
    return [
      if(position.inHours>0)hour,minitus,secound
    ].join(":");
  }

}