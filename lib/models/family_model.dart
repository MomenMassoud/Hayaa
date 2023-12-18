import 'package:hayaa_main/models/family_user_model.dart';

class FamilyModel {
  String bio;
  String name;
  String id;
  String doc;
  String join;
  String photo;
  List<FamilyUserModel> users=[];
  FamilyModel(this.name,this.id,this.doc,this.bio,this.join,this.photo);
}