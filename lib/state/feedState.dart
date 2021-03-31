import 'dart:async';
import 'dart:io';

import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/appState.dart';
// import 'authState.dart';

class FeedState extends AppState {
  bool isBusy = false;
  Map<String, List<FeedModel>> tweetReplyMap = {};
  FeedModel _tweetToReplyModel;

  FeedModel get tweetToReplyModel => _tweetToReplyModel;

  set setTweetToReply(FeedModel model) {
    _tweetToReplyModel = model;
  }

  List<FeedModel> _commentlist;

  List<FeedModel> _feedlist;
  List<FeedModel> _tweetDetailModelList;
  List<String> _userfollowingList;

  List<String> get followingList => _userfollowingList;

  List<FeedModel> get tweetDetailModel => _tweetDetailModelList;

  /// `feedlist` always [contain all tweets] fetched from firebase database
  List<FeedModel> get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist.reversed);
    }
  }

  /// contain tweet list for home page
  List<FeedModel> getTweetList(UserModel userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel> list;

    if (!isBusy && feedlist != null && feedlist.isNotEmpty) {
      list = feedlist.where((x) {
        /// If Tweet is a comment then no need to add it in tweet list

        /// Only include Tweets of logged-in user's and his following user's
        if (x.user.user_id == userModel.user_id ||
            ([] != null && [].contains(x.user.user_id))) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  /// set tweet for detail tweet page
  /// Setter call when tweet is tapped to view detail
  /// Add Tweet detail is added in _tweetDetailModelList
  /// It makes `Fwitter` to view nested Tweets
  set setFeedModel(FeedModel model) {
    if (_tweetDetailModelList == null) {
      _tweetDetailModelList = [];
    }

    /// [Skip if any duplicate tweet already present]
    if (_tweetDetailModelList.length >= 0) {
      _tweetDetailModelList.add(model);
      cprint(
          "Detail Tweet added. Total Tweet: ${_tweetDetailModelList.length}");
      notifyListeners();
    }
  }

  /// `remove` last Tweet from tweet detail page stack
  /// Function called when navigating back from a Tweet detail
  /// `_tweetDetailModelList` is map which contain lists of commment Tweet list
  /// After removing Tweet from Tweet detail Page stack its commnets tweet is also removed from `_tweetDetailModelList`
  void removeLastTweetDetail(String tweetKey) {
    if (_tweetDetailModelList != null && _tweetDetailModelList.length > 0) {
      // var index = _tweetDetailModelList.in
      FeedModel removeTweet =
          _tweetDetailModelList.lastWhere((x) => x.post_id == tweetKey);
      _tweetDetailModelList.remove(removeTweet);
      tweetReplyMap.removeWhere((post_id, value) => post_id == tweetKey);
      cprint(
          "Last Tweet removed from stack. Remaining Tweet: ${_tweetDetailModelList.length}");
    }
  }

  /// [clear all tweets] if any tweet present in tweet detail page or comment tweet
  void clearAllDetailAndReplyTweetStack() {
    if (_tweetDetailModelList != null) {
      _tweetDetailModelList.clear();
    }
    if (tweetReplyMap != null) {
      tweetReplyMap.clear();
    }
    cprint('Empty tweets from stack');
  }

  /// [Subscribe Tweets] firebase Database
  Future<bool> databaseInit() {
    try {
      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  /// get [Tweet list] from firebase realtime database
  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// get [Tweet Detail] from firebase realtime kDatabase
  /// If model is null then fetch tweet from firebase
  /// [getpostDetailFromDatabase] is used to set prepare Tweetr to display Tweet detail
  /// After getting tweet detail fetch tweet coments from firebase
  void getpostDetailFromDatabase(String postID, {FeedModel model}) async {}

  /// Fetch `Retweet` model from firebase realtime kDatabase.
  /// Retweet itself  is a type of `Tweet`
  Future<FeedModel> fetchTweet(String postID) async {
    FeedModel _tweetDetail;

    /// If tweet is availabe in feedlist then no need to fetch it from firebase
    if (feedlist.any((x) => x.post_id == postID)) {
      _tweetDetail = feedlist.firstWhere((x) => x.post_id == postID);
    }

    return _tweetDetail;
  }

  /// create [New Tweet]
  createTweet(FeedModel model) {
    ///  Create tweet in [Firebase kDatabase]
    isBusy = true;
    notifyListeners();
    try {} catch (error) {
      cprint(error, errorIn: 'createTweet');
    }
    isBusy = false;
    notifyListeners();
  }

  ///  It will create tweet in [Firebase kDatabase] just like other normal tweet.
  ///  update retweet count for retweet model
  createReTweet(FeedModel model) {}

  /// [Delete tweet] in Firebase kDatabase
  /// Remove Tweet if present in home page Tweet list
  /// Remove Tweet if present in Tweet detail page or in comment
  deleteTweet(String tweetId, TweetType type, {String parentkey}) {
    try {} catch (error) {
      cprint(error, errorIn: 'deleteTweet');
    }
  }

  /// upload [file] to firebase storage and return its  path url
  Future<String> uploadFile(File file) async {
    try {} catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }

  /// [Delete file] from firebase storage
  Future<void> deleteFile(String url, String baseUrl) async {
    try {} catch (error) {
      cprint(error, errorIn: 'deleteFile');
    }
  }

  /// [update] tweet
  updateTweet(FeedModel model) async {}

  /// Add/Remove like on a Tweet
  /// [postId] is tweet id, [user_id] is user's id who like/unlike Tweet
  addLikeToTweet(FeedModel tweet, String user_id) {}

  /// Add [new comment tweet] to any tweet
  /// Comment is a Tweet itself
  addcommentToPost(FeedModel replyTweet) {
    try {} catch (error) {
      cprint(error, errorIn: 'addcommentToPost');
    }
    isBusy = false;
    notifyListeners();
  }

  /// Trigger when any tweet changes or update
  /// When any tweet changes it update it in UI
  /// No matter if Tweet is in home page or in detail page or in comment section.

  /// Trigger when comment tweet added
  /// Check if Tweet is a comment
  /// If Yes it will add tweet in comment list.
  /// add [new tweet] comment to comment list
}
