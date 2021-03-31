import 'package:iuiuaa/model/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedModel.g.dart';

@JsonSerializable()
class FeedModel {
  String post_id = "";
  String description= "";
  String post_by= "";
  String view_count= "";
  String createdAt= "";
  String post_thumbnail_small;
  String post_thumbnail;
  String post_category;
  String tags;
  UserModel user = new UserModel();

  FeedModel();

  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);
}
