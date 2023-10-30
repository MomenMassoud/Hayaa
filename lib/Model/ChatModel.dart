import 'daily_model.dart';
import 'followes_model.dart';

class chatmodel{
  String name;
  String gender;
  String email;
  String bio;
  String photo;
  String devicetoken;
  String coin="";
  String seen="";
  String id="";
  String vip="0";
  List<Follows> follows=[];
  List<String> followers=[];
  List<DailyLogin> dailyLogin =[];
  chatmodel(this.name,this.email,this.photo,this.bio,this.gender,this.devicetoken);
}