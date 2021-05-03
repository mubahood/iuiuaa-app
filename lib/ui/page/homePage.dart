import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/appState.dart';
import 'package:iuiuaa/ui/page/message/chatListPage.dart';
import 'package:iuiuaa/widgets/bottomMenuBar.dart';
import 'package:iuiuaa/widgets/feedPage.dart';
import 'package:provider/provider.dart';

import 'common/sidebar.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  bool is_loading = true;
  UserModel logged_in_user = null;

  Future<void> _my_init() async {
    if (dbHelper == null) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
    }
    if (dbHelper == null) {
      Utility.my_toast_short("Failed to init db.");
      return;
    }
    logged_in_user = await dbHelper.get_logged_user();
    if (logged_in_user == null) {
      print("Nog logged 1");
      Utility.my_toast_short("You are not logged in.");
      Navigator.pushNamed(context, Constants.SplashPage)
          .then((value) => {Navigator.pop(context)});
      return;
    }
    is_loading = false;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _my_init();
      initTweets();
      initProfile();
      initSearch();
      initNotificaiton();
      initChat();
    });

    super.initState();
  }

  void initTweets() {}

  void initProfile() {}

  void initSearch() {}

  void initNotificaiton() {}

  void initChat() {}

  /// On app launch it checks if app is launch by tapping on notification from notification tray
  /// If yes, it checks for  which type of notification is recieve
  /// If notification type is `NotificationType.Message` then chat screen will open
  /// If notification type is `NotificationType.Mention` then user profile will open who taged you in a tweet
  ///

  Widget _body() {
    return SafeArea(
      child: Container(
        child: _getPage(Provider.of<AppState>(context).pageIndex),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
        break;
      case 1:
        return Text("SearchPage: ");
        //return SearchPage(scaffoldKey: _scaffoldKey);
        break;
      case 2:
        return Text(
            "NotificationPage: "); //NotificationPage(scaffoldKey: _scaffoldKey);
        break;
      case 3:
        return ChatListPage(
            scaffoldKey:
                _scaffoldKey); // ChatListPage(scaffoldKey: _scaffoldKey);
        break;
      default:
        return FeedPage(scaffoldKey: _scaffoldKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomMenubar(),
      drawer: SidebarMenu(),
      body: _body(),
    );
  }
}
