import 'comment_model.dart';
import 'love_model.dart';

class PostModel{
  late String id;
  late String ownerName;
  String owner;
  String Owner_photo;
  String Day;
  String Month;
  String Year;
  String Text;
  String Photo;
  List<LoveModel> likes=[];
  List<CommentModel> comments=[];
  bool like=false;
  late int indexLike;
  bool followButton;
  PostModel(this.owner,this.Owner_photo,this.Text,this.Photo,this.Day,this.Month,this.Year,this.followButton);
}