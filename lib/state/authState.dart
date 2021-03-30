import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';

import 'appState.dart';

class AuthState extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  String user_id;

  List<UserModel> _profileUserModelList;
  UserModel _userModel;

  UserModel userModel = UserModel();

  UserModel get profileUserModel {
    if (_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    } else {
      return null;
    }
  }

  void removeLastUser() {
    _profileUserModelList.removeLast();
  }

  /// Logout from device
  void logoutCallback() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    user_id = '';
    _userModel = null;
    _profileUserModelList = null;
    if (isSignInWithGoogle) {
      Utility.logEvent('google_logout');
    }
    notifyListeners();
  }

  /// Alter select auth method, login and sign up page
  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    user_id = '';
    notifyListeners();
  }

  databaseInit() {
    try {} catch (error) {
      cprint(error, errorIn: 'databaseInit');
    }
  }

  /// Verify user's credentials for login
  Future<String> signIn(String email, String password,
      {GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      loading = true;
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'signIn');
      customSnackBar(scaffoldKey, error.message);
      // logoutCallback();
      return null;
    }
  }

  /// Create user from `google login`
  /// If user is new then it create a new user
  /// If user is old then it just `authenticate` user and return firebase user data
  Future<UserModel> handleGoogleSignIn() async {
    UserModel u = UserModel();
    return u;
  }

  /// Create user profile from google login
  createUserFromGoogleSignIn(UserModel user) {}

  /// Create new user's profile in db
  Future<String> signUp(UserModel userModel,
      {GlobalKey<ScaffoldState> scaffoldKey, String password}) async {
    return "1";
  }

  /// `Create` and `Update` user
  /// IF `newUser` is true new user is created
  /// Else existing user will update with new values
  createUser(UserModel user, {bool newUser = false}) {
    loading = false;
  }

  /// Fetch current user profile
  Future<UserModel> getCurrentUser() async {
    return UserModel();
  }

  /// Reload user to get refresh user data
  reloadUser() async {
    return UserModel();
  }

  /// Send email verification link to email2
  Future<void> sendEmailVerification(
      GlobalKey<ScaffoldState> scaffoldKey) async {}

  /// Check if user's email is verified
  Future<bool> emailVerified() async {
    return true;
  }

  /// Send password reset link to email
  Future<void> forgetPassword(String email,
      {GlobalKey<ScaffoldState> scaffoldKey}) async {}

  /// `Update user` profile
  Future<void> updateUserProfile(UserModel userModel,
      {File image, File bannerImage}) async {}

  Future<String> _uploadFileToStorage(File file, path) async {
    /// get file storage path from server
    return await "1.com";
  }

  /// `Fetch` user `detail` whoose user_id is passed
  Future<UserModel> getuserDetail(String user_id) async {
    UserModel user;
    return user;
  }

  /// Fetch user profile
  /// If `userProfileId` is null then logged in user's profile will fetched
  getProfileUser({String userProfileId}) {
    try {
      loading = true;
      if (_profileUserModelList == null) {
        _profileUserModelList = [];
      }
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'getProfileUser');
    }
  }

  /// if firebase token not available in profile
  /// Then get token from firebase and save it to profile
  /// When someone sends you a message FCM token is used
  void updateFCMToken() {
    if (_userModel == null) {
      return;
    }
    return getProfileUser();
  }

  /// Follow / Unfollow user
  ///
  /// If `removeFollower` is true then remove user from follower list
  ///
  /// If `removeFollower` is false then add user to follower list
  followUser({bool removeFollower = false}) {}
}
