import 'package:hayaa_main/models/story_model.dart';

import 'family_rank.dart';

class UserModel{
  String bio;
  String birthdate;
  String coin;
  String daimond;
  String devicetoken;
  String country;
  String exp;
  String gender;
  String id;
  String lang;
  String level;
  String name;
  String phonenumber;
  String photo;
  String seen;
  String type;
  String vip;
  String email;
   int sizeFirends=0;
   int sizefans=0;
   int sizevisitors=0;
  int sizefollowing=0;
  late String exp2;
  late String level2;
   String docID="";
  late String myfamily;
  late String familytype;
  List<FamilyRankModel> familyRank=[];
  List<StoryModel> storys=[];
  int valueRank=0;
  String myroom="";
  UserModel(
      this.email,this.name,this.gender,this.photo,this.id,this.phonenumber,this.devicetoken,this.daimond,this.vip,this.bio,this.seen,this.lang,this.country,this.type,this.birthdate,this.coin,this.exp,this.level,
      );
}