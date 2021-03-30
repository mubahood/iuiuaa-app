import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/chatModel.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customAppBar.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
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

  List<ChatMessage> _messageList;
  List<ChatMessage> _chatUserList;

  List<ChatMessage> get chatUserList {
    _chatUserList = [];
    ChatMessage chatMessage = ChatMessage(
        key: "1",
        senderId: "1",
        message: "I love you.",
        seen: "1",
        createdAt: "90090001",
        receiverId: "90090001",
        senderName: "90090001",
        timeStamp: "90090001");
    _chatUserList.add(chatMessage);
    _chatUserList.add(new ChatMessage(
        key: "1",
        senderId: "1",
        message: "I love you.",
        seen: "1",
        createdAt: "90090001",
        receiverId: "90090001",
        senderName: "90090001",
        timeStamp: "90090001"));
    _chatUserList.add(new ChatMessage(
        key: "1",
        senderId: "1",
        message: "I love you.",
        seen: "1",
        createdAt: "90090001",
        receiverId: "90090001",
        senderName: "90090001",
        timeStamp: "90090001"));
    _chatUserList.add(new ChatMessage(
        key: "1",
        senderId: "1",
        message: "I love you.",
        seen: "0",
        createdAt: "90090001",
        receiverId: "90090001",
        senderName: "90090001",
        timeStamp: "90090001"));
    if (_chatUserList == null) {
      return null;
    } else {
      return List.from(_chatUserList);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _body() {
    List<UserModel> userlist = [];
    if (chatUserList == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'No message available ',
          subTitle:
              'When someone sends you message,UserModel list\'ll show up here \n  To send message tap message button.',
        ),
      );
    } else {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: chatUserList.length,
        itemBuilder: (context, index) => _userCard(
            userlist.firstWhere(
              (x) => x.user_id == chatUserList[index].key,
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
          Navigator.pushNamed(context, '/ChatScreenPage',arguments: "2");
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/ProfilePage/${model.user_id}');
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
                    model.profile_photo_thumb ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        title: TitleText(
          model.username ?? "NA",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: customText(
          getLastMessage(lastMessage.message) ?? '@${model.username}',
          style:
              TextStyles.onPrimarySubTitleText.copyWith(color: Colors.black54),
        ),
        trailing: lastMessage == null
            ? SizedBox.shrink()
            : Text(
                Utility.getChatTime(lastMessage.createdAt).toString(),
              ),
      ),
    );
  }

  FloatingActionButton _newMessageButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/NewMessagePage');
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
    Navigator.pushNamed(context, '/DirectMessagesPage');
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
