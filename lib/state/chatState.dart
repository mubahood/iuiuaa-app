
import 'package:iuiuaa/model/chatModel.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/appState.dart';

class ChatState extends AppState {
  bool setIsChatScreenOpen;

  List<ChatMessage> _messageList;
  List<ChatMessage> _chatUserList;
  UserModel _chatUser;
  String serverToken = "<FCM SERVER KEY>";

  /// Get FCM server key from firebase project settings
  UserModel get chatUser => _chatUser;

  set setChatUser(UserModel model) {
    _chatUser = model;
  }

  String _channelName;

  /// Contains list of chat messages on main chat screen
  /// List is sortBy mesage timeStamp
  /// Last message will be display on the bottom of screen
  List<ChatMessage> get messageList {
    if (_messageList == null) {
      return null;
    } else {
      _messageList.sort((x, y) => DateTime.parse(y.createdAt)
          .toLocal()
          .compareTo(DateTime.parse(x.createdAt).toLocal()));
      return _messageList;
    }
  }

  /// Contain list of users who have chat history with logged in user
  List<ChatMessage> get chatUserList {
    if (_chatUserList == null) {
      return null;
    } else {
      return List.from(_chatUserList);
    }
  }

  void databaseInit(String user_id, String myId) async {
    _messageList = null;
    if (_channelName == null) {
      getChannelName(user_id, myId);
    }
  }

  /// Fecth FCM server key from firebase Remote config
  /// FCM server key is stored in firebase remote config
  /// you have to add server key in firebase remote config
  /// To fetch this key go to project setting in firebase
  /// Click on `cloud messaging` tab
  /// Copy server key from `Project credentials`
  /// Now goto `Remote Congig` section in fireabse
  /// Add [FcmServerKey]  as paramerter key and below json in Default vslue
  ///  ``` json
  ///  {
  ///    "key": "FCM server key here"
  ///  } ```
  /// For more detail visit:- https://github.com/TheAlphamerc/iuiuaa/issues/28#issue-611695533
  /// For package detail check:-  https://pub.dev/packages/firebase_remote_config#-readme-tab-
  void getFCMServerKey() async {}

  /// Fetch users list to who have ever engaged in chat message with logged-in user
  void getUserchatList(String user_id) {}

  /// Fetch chat  all chat messages
  /// `_channelName` is used as primary key for chat message table
  /// `_channelName` is created from  by combining first 5 letters from user ids of two users
  void getchatDetailAsync() async {}

  /// Send message to other user
  void onMessageSubmitted(ChatMessage message,
      {UserModel myUser, UserModel secondUser}) {
    print(chatUser.user_id);
  }

  /// Channel name is like a room name
  /// which save messages of two user uniquely in database
  String getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';
    // cprint(_channelName); //2RhfE-5kyFB
    return _channelName;
  }


  // update last message on chat user list screen when manin chat screen get closed.
  void onChatScreenClosed() {
    if (_chatUserList != null && _chatUserList.isNotEmpty) {
      var user = _chatUserList.firstWhere((x) => x.key == chatUser.user_id);
      if (_messageList != null) {
        user.message = _messageList.first.message;
        user.createdAt = _messageList.first.createdAt; //;
        _messageList = null;
        notifyListeners();
      }
    }
  }

  /// Push notification will be sent to other user when you send him a message in chat.
  /// To send push notification make sure you have FCM `serverToken`
  void sendAndRetrieveMessage(ChatMessage model) async {
    if (chatUser.fcmToken == null) {
      return;
    }

    print("{}");
  }
}
