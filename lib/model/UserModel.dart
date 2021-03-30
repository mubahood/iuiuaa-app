import 'dart:core';

import 'package:iuiuaa/helper/constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  UserModel();

  String user_id = "";
  String isVerified = "";
  String dob = "";
  String email = "";
  String first_name = "";
  String website = "";
  String last_name = "";
  String campus = "";
  String username = "";
  String reg_number = "";
  String system_id = "";
  String password_plain = "";
  String last_seen = "";
  String approved = "0";
  String reg_date = "";
  String user_type = "";
  String gender = "";
  String nationality = "";
  String occupation = "";
  String programs = "";
  String phone_number = "";
  String location_lat = "";
  String location_long = "";
  String linkedin = "";
  String other_link = "";
  String whatsapp = "";
  String facebook = "";
  String language = "";
  String twitter = "";
  String address = "";
  String cv = "";
  String about = "";
  String fcmToken;
  String profile_photo;
  String profile_photo_id;
  String profile_photo_large;
  String profile_photo_large_id;
  String profile_photo_large_thumb;
  String profile_photo_thumb;

  static String DROP_USER_DATABSE() {
    return 'DROP TABLE  ' + Constants.USERS_TABLE + " IF EXISTS";
  }

  static String CERATE_USER_DATABSE() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        Constants.USERS_TABLE +
        '('
            ' user_id VARCHAR(25) PRIMARY KEY ,'
            ' isVerified VARCHAR(10),'
            ' email VARCHAR(150),'
            ' dob VARCHAR(150),'
            ' display_name VARCHAR(150),'
            ' first_name VARCHAR(150),'
            ' website VARCHAR(150),'
            ' last_name VARCHAR(150),'
            ' campus VARCHAR(150),'
            ' username VARCHAR(150),'
            ' reg_number VARCHAR(150),'
            ' system_id VARCHAR(150),'
            ' last_seen VARCHAR(150),'
            ' password VARCHAR(150),'
            ' approved VARCHAR(150),'
            ' reg_date VARCHAR(150),'
            ' user_type VARCHAR(150),'
            ' gender VARCHAR(150),'
            ' nationality VARCHAR(150),'
            ' occupation VARCHAR(150),'
            ' phone_number VARCHAR(150),'
            ' location_lat VARCHAR(150),'
            ' location_long VARCHAR(150),'
            ' linkedin VARCHAR(150),'
            ' other_link VARCHAR(150),'
            ' whatsapp VARCHAR(150),'
            ' language VARCHAR(150),'
            ' facebook VARCHAR(150),'
            ' address VARCHAR(150),'
            ' twitter VARCHAR(150),'
            ' cv TEXT, '
            ' about TEXT,'
            ' programs TEXT,'
            ' profile_photo TEXT,'
            ' profile_photo_id TEXT,'
            ' profile_photo_large TEXT,'
            ' profile_photo_thumb TEXT,'
            ' profile_photo_large_id TEXT,'
            ' profile_photo_large_thumb TEXT,'
            ' followers VARCHAR(150),'
            ' password_plain VARCHAR(150),'
            ' fcmToken VARCHAR(150)'
            ')';
  }

}
