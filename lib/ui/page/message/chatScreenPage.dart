import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/chatModel.dart';
import 'package:iuiuaa/model/responseModel.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';

class ChatScreenPage extends StatefulWidget {
  ChatScreenPage({Key key, this.userProfileId}) : super(key: key);

  final String userProfileId;

  _ChatScreenPageState createState() => _ChatScreenPageState();
}

List<ChatMessage> messageList = [];

class _ChatScreenPageState extends State<ChatScreenPage> {
  final messageController = new TextEditingController();
  String userImage;
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  ScrollController _controller;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  Widget _chatScreenBody() {
    if (is_loading) {
      _my_init();
    }

    if (messageList == null || messageList.length == 0) {
      return Center(
        child: Text(
          'No message found',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      reverse: false,
      physics: BouncingScrollPhysics(),
      itemCount: messageList.length,
      itemBuilder: (context, index) => chatMessage(messageList[index]),
    );
  }

  Widget chatMessage(ChatMessage message) {
    if (sender == null) {
      return Container();
    }

    if (message.senderId == sender.user_id)
      return _message(message, true);
    else
      return _message(message, false);
  }

  String senderId = null;

  Widget _message(ChatMessage chat, bool myMessage) {
    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            myMessage
                ? SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: customAdvanceNetworkImage(userImage),
                  ),
            Expanded(
              child: Container(
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (fullWidth(context) / 4),
                  top: 20,
                  left: myMessage ? (fullWidth(context) / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage
                            ? TwitterColor.dodgetBlue
                            : TwitterColor.mystic,
                      ),
                      child: Text(
                        chat.message,
                        style: TextStyle(
                          fontSize: 16,
                          color: myMessage ? TwitterColor.white : Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: InkWell(
                        borderRadius: getBorder(myMessage),
                        onLongPress: () {
                          var text = ClipboardData(text: chat.message);
                          Clipboard.setData(text);
                          _scaffoldKey.currentState.hideCurrentSnackBar();
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              backgroundColor: TwitterColor.white,
                              content: Text(
                                'Message copied',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Text(
            Utility.getChatTime(chat.timeStamp),
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
          ),
        )
      ],
    );
  }

  BorderRadius getBorder(bool myMessage) {
    return BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomRight: myMessage ? Radius.circular(0) : Radius.circular(20),
      bottomLeft: myMessage ? Radius.circular(20) : Radius.circular(0),
    );
  }

  Widget _bottomEntryField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Divider(
            thickness: 0,
            height: 1,
          ),
          TextField(
            autofocus: true,
            onSubmitted: (val) async {
              submitMessage();
            },
            controller: messageController,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              alignLabelWithHint: true,
              hintText: 'Start with a message...',
              suffixIcon:
                  IconButton(icon: Icon(Icons.send), onPressed: submitMessage),
              // fillColor: Colors.black12, filled: true
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // final chatState = Provider.of<ChatState>(context,listen: false);
    // state.setIsChatScreenOpen = false;
    // state.onChatScreenClosed();
    return true;
  }

  String chat_thread_id = null;
  String sender_id = null;
  String receiver_id = null;
  UserModel receiver = null;
  UserModel sender = null;
  bool is_loading = true;

  Future<UserModel> get_receiver() async {
    print("ROMINA ==> getting  receiver ");
    receiver_id = ModalRoute.of(context).settings.arguments.toString().trim();
    print("ROMINA ==> getting  receiver ");
    if (receiver_id == null) {
      return null;
    }

    List<UserModel> _users =
        await dbHelper.user_get(" user_id = '$receiver_id' ");

    if (_users == null || _users.isEmpty) {
      Map<String, String> params = {'user_id': "$receiver_id"};
      List<UserModel> web_users = await Utility.get_web_user(params);

      if (web_users == null || web_users.isEmpty) {
        print("ROMINA: WEB USERS EMPTY ");
        return null;
      }
      receiver = web_users[0];

      await dbHelper.save_user(receiver);
      return receiver;
    }

    receiver = _users[0];
    return receiver;
  }

  Future<String> get_chat_thread_id() async {
    final _path = "/wp/wp-json/muhindo/v1/get_chat_thread_id";
    final _uri = Uri.https(Constants.BASE_URL, _path);
    var response = await http.get(_uri);
    if (response.statusCode == 200) {
      String rawJson = response.body;
      Map<String, dynamic> map = jsonDecode(rawJson);
      ResponseModel data = ResponseModel.fromJson(map);
      if (data != null) {
        return data.data.toString().trim();
      }
    }
    return null;
  }

  Future<void> _my_init() async {
    await get_receiver();

    print("ROMINA ==>  receiver is done ...");

    if (receiver == null) {
      Utility.my_toast("Receiver not found!");
      Navigator.pop(context);
      return;
    }
    sender = await dbHelper.get_logged_user();

    if (sender == null) {
      Utility.my_toast("Sender not found!");
      Navigator.pop(context);
      return;
    }

    messageList = [];
    messageList.clear();
    String cond =
        " (senderId = '${sender.user_id}' AND receiverId = '${receiver.user_id}') OR (receiverId = '${sender.user_id}' AND senderId = '${receiver.user_id}')  ";

    messageList = await dbHelper.get_chats(cond);

    if (messageList != null && !messageList.isEmpty) {
      chat_thread_id = messageList[0].chat_thread_id;
    }

    if (chat_thread_id == null) {
      chat_thread_id = await get_chat_thread_id();
    }

    if (chat_thread_id == null) {
      Utility.my_toast("You are offline.");
      Navigator.pop(context);
      return;
    }

    setState(() {});

    is_loading = false;

    Future.delayed(const Duration(seconds: 5), () {
      listen_to_new_chats();
      print(" JULIET This line is execute after 5 seconds");
    });
  }

  Future<void> submitMessage() async {
    if (is_loading) {
      Utility.my_toast("Loading...");
      _my_init();
      return;
    }

    if (sender == null) {
      Utility.my_toast("sender is null");
      _my_init();
      return;
    }

    if (messageController.text == null || messageController.text.isEmpty) {
      return;
    }

    ChatMessage message;

    message = ChatMessage(
        localId: DateTime.now().millisecondsSinceEpoch.toString(),
        key: DateTime.now().millisecondsSinceEpoch.toString(),
        chat_thread_id: chat_thread_id,
        message: messageController.text,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: sender.user_id,
        receiverId: receiver.user_id,
        seen: "0",
        sent: "0",
        timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: sender.first_name + " " + sender.last_name);

    Future.delayed(Duration(milliseconds: 300)).then((_) {
      messageController.clear();
    });

    try {
      dbHelper.save_message(message);
    } catch (e) {}

    //messageList.insert((messageList.length), message);
    messageList.add(message);

    print("SUMAYYA " + messageList.length.toString());
    setState(() {});
    scroll_to_last();

    final _path = "/wp/wp-json/muhindo/v1/send_message";
    Map<String, String> _params = {
      'sender': message.senderId,
      'receiver': message.receiverId,
      'message': message.message,
      'localId': message.localId,
    };

    final _uri = Uri.https(Constants.BASE_URL, _path, _params);
    var response = await http.get(_uri).timeout(Duration(seconds: 30));

    if (response == null) {
      Utility.my_toast("Failed to get data.");
      return;
    }

    if (response.statusCode != 200) {
      Utility.my_toast(
          'Failed to connect to internet. ' + response.statusCode.toString());
      return;
    }

    String rawJson = response.body;
    Map<String, dynamic> map = jsonDecode(rawJson);

    ResponseModel data = ResponseModel.fromJson(map);

    if (data == null) {
      Utility.my_toast('Totally failed to decode data.');
      return;
    }

    if (data.code == null) {
      Utility.my_toast('Failed to decode data.');
      return;
    }

    print("romina ========> " + data.data);

    if (data.code != 1) {
      Utility.my_toast(data.message);
      return;
    }

    ChatMessage m = ChatMessage.fromJson(jsonDecode(data.data));

    if (m == null) {
      Utility.my_toast("Failed to parse data response.");
      return;
    }

    try {
      dbHelper.save_message(m);
      print("romina: saved message locally " + m.chat_thread_id);
    } catch (e) {
      Utility.my_toast("Failed to save message locally.");
    }
  }

  @override
  Widget build(BuildContext context) {
    userImage = "";

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: receiver != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      receiver.first_name + " " + receiver.last_name,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      receiver.email,
                      style: TextStyle(color: AppColor.darkGrey, fontSize: 15),
                    )
                  ],
                )
              : Text("Loading..."),
          iconTheme: IconThemeData(color: Colors.blue),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.info, color: AppColor.primary),
                onPressed: () {
                  Navigator.pushNamed(context, '/ConversationInformation');
                })
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: _chatScreenBody(),
                ),
              ),
              _bottomEntryField()
            ],
          ),
        ),
      ),
    );
  }

  void scroll_to_last() {
    try {
      _controller.animateTo(
        (_controller.position.maxScrollExtent + 100),
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print("[Error] $e");
    }
  }

  Future<void> listen_to_new_chats() async {
    if (is_loading) {
      return;
    }
    Map<String, String> params = {
      "user": receiver.user_id,
      "thread": chat_thread_id
    };
    List<ChatMessage> unread = await Utility.get_web_chats(params);

    if (unread == null) {
      print("JULIET IS NULL");
      await _my_init();
      return;
    }
    if (unread.length < 1) {
      print("JULIET IS EMPTY");
      await _my_init();
      return;
    }

    await _my_init();
    scroll_to_last();
  }
}
