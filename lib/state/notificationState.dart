

import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/model/notificationModel.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/appState.dart';

class NotificationState extends AppState {
  String fcmToken;
  NotificationType _notificationType = NotificationType.NOT_DETERMINED;
  String notificationReciverId, notificationTweetId;
  FeedModel notificationTweetModel;

  NotificationType get notificationType => _notificationType;

  set setNotificationType(NotificationType type) {
    _notificationType = type;
  }

  // FcmNotificationModel notification;
  String notificationSenderId;

  List<UserModel> userList = [];

  List<NotificationModel> _notificationList;

  List<NotificationModel> get notificationList => _notificationList;

  /// [Intitilise firebase notification kDatabase]
  Future<bool> databaseInit(String user_id) {
    try {
      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  /// get [Notification list] from firebase realtime database
  void getDataFromDatabase(String user_id) {
    try {
      loading = true;
      _notificationList = [];
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// get `Tweet` present in notification
  Future<FeedModel> getTweetDetail(String tweetId) async {
    FeedModel _tweetDetail;
  }

  /// get user who liked your tweet
  Future<UserModel> getuserDetail(String user_id) async {
    UserModel user;
    if (userList.length > 0 && userList.any((x) => x.user_id == user_id)) {
      return Future.value(userList.firstWhere((x) => x.user_id == user_id));
    }
  }

  /// Remove notification if related Tweet is not found or deleted
  void removeNotification(String user_id, String tweetkey) async {}




  /// Initilise push notification services
  void initfirebaseService() {}
}
