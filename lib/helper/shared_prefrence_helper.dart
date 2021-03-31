import 'dart:convert';

import 'package:iuiuaa/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'link_media_info.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();

  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<String> getUserName() async {
    return (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.UserName.toString());
  }

  Future clearPreferenceValues() async {
    await (SharedPreferences.getInstance())
      ..clear();
  }

  Future<void> saveUserProfile(UserModel user) async {
    return (await SharedPreferences.getInstance()).setString(
        UserPreferenceKey.UserProfile.toString(), json.encode(user.toJson()));
  }

  Future<UserModel> getUserProfile() async {
    final jsonString = (await SharedPreferences.getInstance())
        .getString(UserPreferenceKey.UserProfile.toString());
    if (jsonString == null) return null;
    return UserModel.fromJson(json.decode(jsonString));
  }

  Future<bool> saveLinkMediaInfo(String key, LinkMediaInfo model) async {
    return (await SharedPreferences.getInstance())
        .setString(key, json.encode(model.toJson()));
  }

  Future<LinkMediaInfo> getLinkMediaInfo(String key) async {
    final jsonString = (await SharedPreferences.getInstance()).getString(key);
    if (jsonString == null) {
      return null;
    }
    return LinkMediaInfo.fromJson(json.decode(jsonString));
  }
}

enum UserPreferenceKey { AccessToken, UserProfile, UserName, IsFirstTimeApp }
