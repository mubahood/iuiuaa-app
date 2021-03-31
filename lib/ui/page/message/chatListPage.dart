import 'dart:core';

import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/chatModel.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customAppBar.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/customLoader.dart';
import 'package:iuiuaa/widgets/newWidget/emptyList.dart';
import 'package:iuiuaa/widgets/newWidget/rippleButton.dart';
import 'package:iuiuaa/widgets/newWidget/title_text.dart';

class ChatListPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ChatListPage({Key key, this.scaffoldKey}) : super(key: key);

  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  /// Contain list of users who have chat history with logged in user

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<ChatMessage> chatUserList = [];
  List<UserModel> userlist = [];
  UserModel logged_in_user = UserModel();
  bool is_loading = true;

  Future<void> get_chats() async {
    if (dbHelper == null) {
      dbHelper = DatabaseHelper.instance;
    }
    if (dbHelper == null) {
      Utility.my_toast("Database is null.");
      return [];
    }

    logged_in_user = await dbHelper.get_logged_user();
    if (logged_in_user == null) {
      Utility.my_toast("You are not logged in.");
      return;
    }

    Map<String, String> params = {"user": logged_in_user.user_id};
    Utility.get_web_chats(params);

    List<UserModel> _userlist = await dbHelper.user_get(" 1 ");
    List<ChatMessage> _chats = await dbHelper.get_chats_list(" 1 ");
    chatUserList = _chats;
    userlist = _userlist;
    is_loading = false;
    setState(() {});
    return;
  }

  @override
  void initState() {
    get_chats();
    super.initState();
  }

  Widget _body() {
    if (is_loading) {
      return Container(
        height: fullHeight(context) - 135,
        child: CustomScreenLoader(
          height: double.infinity,
          width: fullWidth(context),
          backgroundColor: Colors.white,
        ),
      );
    } else if (chatUserList == null || chatUserList.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'No message available',
          subTitle:
              'When someone sends you message,UserModel list\'ll show up here \n  To send message tap message button.',
        ),
      );
    } else {
      String _key = logged_in_user.user_id;

      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: chatUserList.length,
        itemBuilder: (context, index) => _userCard(
            userlist.firstWhere(
              (x) => x.user_id == chatUserList[index].receiverId,
              orElse: () => UserModel(),
            ),
            chatUserList[index]),
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
      );
    }
  }

  Widget _userCard(UserModel model, ChatMessage lastMessage) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          if (logged_in_user == null || !is_loading) {
            String arg = "";
            arg = lastMessage.senderId;
            if (arg == logged_in_user.user_id) {
              arg = lastMessage.receiverId;
            }
            Navigator.pushNamed(context, '/ChatScreenPage', arguments: arg)
                .then((value) => {get_chats()});
          } else {
            Utility.my_toast("Loading...");
          }
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/ProfilePage/${model.user_id}')
                .then((value) => {get_chats()});
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    model.profile_photo ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        title: TitleText(
          model.first_name + " " + model.last_name ?? "NA",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: customText(
          getLastMessage(lastMessage.message) ??
              '@${model.first_name + ' ' + model.last_name}',
          style:
              TextStyles.onPrimarySubTitleText.copyWith(color: Colors.black54),
        ),
        trailing: lastMessage == null
            ? SizedBox.shrink()
            : Text(
                Utility.getChatTime(lastMessage.timeStamp).toString(),
              ),
      ),
    );
  }

  FloatingActionButton _newMessageButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed('/NewMessagePage')
            .then((value) => {get_chats()});
      },
      child: customIcon(
        context,
        icon: AppIcon.newMessage,
        istwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/DirectMessagesPage')
        .then((value) => {get_chats()});
  }

  String getLastMessage(String message) {
    if (message != null && message.isNotEmpty) {
      if (message.length > 100) {
        message = message.substring(0, 80) + '...';
        return message;
      } else {
        return message;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        title: customTitleText(
          'Messages',
        ),
        icon: AppIcon.settings,
        onActionPressed: onSettingIconPressed,
      ),
      floatingActionButton: _newMessageButton(),
      backgroundColor: TwitterColor.mystic,
      body: _body(),
    );
  }
}
