import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedModel.g.dart';

@JsonSerializable()
class FeedModel {
  String post_id = "";
  String description = "";
  String post_by = "";
  String view_count = "";
  String createdAt = "";
  String post_thumbnail_small;
  String post_thumbnail;
  String post_category;
  String tags;
  UserModel user = new UserModel();

  static String CREATE_CHAT_DATABSE() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        Constants.POSTS_TABLE +
        '('
            ' post_id VARCHAR(100) PRIMARY KEY ,'
            ' post_by VARCHAR(100),'
            ' description TEXT,'
            ' view_count VARCHAR(10),'
            ' createdAt VARCHAR(10),'
            ' post_thumbnail_small TEXT,'
            ' post_thumbnail TEXT,'
            ' post_category VARCHAR(50),'
            ' tags VARCHAR(100)'
            ')';
  }

  FeedModel();

  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);
}
