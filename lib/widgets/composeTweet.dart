import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/model/responseModel.dart';
import 'package:iuiuaa/state/searchState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customAppBar.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/title_text.dart';
import 'package:iuiuaa/widgets/url_text/customUrlText.dart';
import 'package:iuiuaa/widgets/widgetView.dart';
import 'package:provider/provider.dart';

import 'composeBottomIconWidget.dart';
import 'composeTweetImage.dart';
import 'newWidget/customLoader.dart';

class ComposeTweetPage extends StatefulWidget {
  ComposeTweetPage({Key key}) : super(key: key);

  final bool isRetweet = false;
  final bool isTweet = true;

  _ComposeTweetReplyPageState createState() => _ComposeTweetReplyPageState();
}

class _ComposeTweetReplyPageState extends State<ComposeTweetPage> {
  bool isScrollingDown = false;
  FeedModel model;
  ScrollController scrollcontroller;
  UserModel loggedinUser = UserModel();
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  File _image;
  TextEditingController _textEditingController;

  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    my_init();
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    scrollcontroller..addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.reverse) {}
  }

  void _onCrossIconPressed() {
    getImage(context, ImageSource.gallery, onImageSelected);
    setState(() {
      _image = null;
    });
  }

  void _onImageIconSelcted(File file) {
    if (file == null) {
      return;
    }
    setState(() {
      _image = file;
    });
  }

  /// Submit tweet to save in firebase database
  void _submitButton() async {
    if (is_loading) {
      Utility.my_toast_short("Loading...");
      return;
    }

    if (_textEditingController.text == null ||
        _textEditingController.text.isEmpty ||
        _textEditingController.text.length > 500) {
      return;
    }

    //kScreenloader.showLoader(context);
    //kScreenloader.hideLoader();

    final _path = "/wp/wp-json/muhindo/v1/post_create";

    final _uri = Uri.https(Constants.BASE_URL, _path);
    http.MultipartRequest request = new http.MultipartRequest("POST", _uri);

    print("ROMINAAA: Before");
    request.fields.addAll({'description': _textEditingController.text});
    request.fields.addAll({'post_by': loggedinUser.user_id});
    request.fields.addAll({'view_count': "0"});
    request.fields.addAll({'post_category': "Jobs"});
    request.fields.addAll({'tags': "Jobs"});

    if (_image != null) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('image', _image.path);
      request.files.add(multipartFile);
    }

    show_loader();

    http.StreamedResponse response =
        await request.send().timeout(Duration(seconds: 30));

    if (response.statusCode != 200) {
      print(response.statusCode);
      return;
    }

    Uint8List s = await response.stream.toBytes();
    var rawJson = Utf8Decoder().convert(s);
    print("Anjane : " + rawJson);
    if (rawJson == null) {
      Utility.my_toast_short("Failed to post. Please try again.");
      hide_loader();
      return;
    }

    Map<String, dynamic> map = jsonDecode(rawJson);
    ResponseModel data = ResponseModel.fromJson(map);

    if (data == null) {
      Utility.my_toast_short('Totally failed to decode data.');
      hide_loader();
      return;
    }

    if (data.code == null) {
      Utility.my_toast_short('Failed to decode data.');
      hide_loader();
      return;
    }

    if (data.code != 1) {
      Utility.my_toast_short(data.message);
      hide_loader();
      return;
    }

    Map<String, dynamic> m = jsonDecode(data.data);
    FeedModel newPost = FeedModel.fromJson(m);

    if (newPost == null) {
      Utility.my_toast_short("Failed parse post.");
      hide_loader();
      return;
    }

    bool res = await dbHelper.save_post(newPost);
    if (res) {
      Utility.my_toast('Posted Successfully!');
      Navigator.pop(context);
      hide_loader();
      return;
    } else {
      Utility.my_toast_short('Failed to save post' + newPost.post_id);
    }

    hide_loader();
    return;

    /// If tweet did not contain image
  }

  /// Return Tweet model which is either a new Tweet , retweet model or comment model
  /// If tweet is new tweet then `parentkey` and `childRetwetkey` should be null
  /// IF tweet is a comment then it should have `parentkey`
  /// IF tweet is a retweet then it should have `childRetwetkey`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: customTitleText(''),
        onActionPressed: _submitButton,
        isCrossButton: true,
        submitButtonText: widget.isTweet
            ? 'Post'
            : widget.isRetweet
                ? 'Retweet'
                : 'Reply',
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollcontroller,
              child: _ComposeTweet(this),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ComposeBottomIconWidget(
                textEditingController: _textEditingController,
                onImageIconSelcted: _onImageIconSelcted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> my_init() async {
    if (dbHelper == null) {
      dbHelper = DatabaseHelper.instance;
    }
    if (dbHelper == null) {
      Utility.my_toast_short("Failed to initialized database");
      return;
    }
    loggedinUser = await dbHelper.get_logged_user();
    setState(() {});
  }

  onImageSelected() {
    Utility.my_toast_short("Done selection");
  }

  bool is_loading = false;
  CustomLoader loader;

  void hide_loader() {
    if (!is_loading) {
      return;
    }
    loader.hideLoader();
    is_loading = false;
  }

  void show_loader() {
    if (is_loading) {
      return;
    }
    if (loader == null) {
      loader = CustomLoader();
    }

    loader.showLoader(context);
    is_loading = true;
  }
}

class _ComposeTweet
    extends WidgetView<ComposeTweetPage, _ComposeTweetReplyPageState> {
  _ComposeTweet(this.viewState) : super(viewState);

  final _ComposeTweetReplyPageState viewState;

  Widget _tweerCard(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30),
              margin: EdgeInsets.only(left: 20, top: 20, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2.0,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: fullWidth(context) - 72,
                    child: UrlText(
                      text: viewState.model.description ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      urlStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  UrlText(
                    text:
                        'Replying to ${viewState.model.post_by ?? viewState.model.post_by}',
                    style: TextStyle(
                      color: TwitterColor.paleSky,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                customImage(context, viewState.model.user.profile_photo,
                    height: 40),
                SizedBox(width: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 0, maxWidth: fullWidth(context) * .5),
                  child: TitleText(viewState.model.user.first_name,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(width: 3),
                viewState.model.user.isVerified.contains("1")
                    ? customIcon(
                        context,
                        icon: AppIcon.blueTick,
                        istwitterIcon: true,
                        iconColor: AppColor.primary,
                        size: 13,
                        paddingIcon: 3,
                      )
                    : SizedBox(width: 0),
                SizedBox(
                    width:
                        viewState.model.user.isVerified.contains("1") ? 5 : 0),
                customText('${viewState.model.user.first_name}',
                    style: TextStyles.userNameStyle.copyWith(fontSize: 15)),
                SizedBox(width: 5),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: customText(
                      '- ${Utility.getChatTime(viewState.model.createdAt)}',
                      style: TextStyles.userNameStyle.copyWith(fontSize: 12)),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight(context),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          viewState.widget.isTweet ? SizedBox.shrink() : _tweerCard(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/bulb.png', height: 40),

              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _TextField(
                  isTweet: widget.isTweet,
                  textEditingController: viewState._textEditingController,
                ),
              )
            ],
          ),
          Flexible(
            child: Stack(
              children: <Widget>[
                ComposeTweetImage(
                  image: viewState._image,
                  onCrossIconPressed: viewState._onCrossIconPressed,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField(
      {Key key,
      this.textEditingController,
      this.isTweet = false,
      this.isRetweet = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final bool isTweet;
  final bool isRetweet;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: textEditingController,
          onChanged: (text) {},
          maxLines: null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: isTweet
                  ? 'Share something meaningful'
                  : isRetweet
                      ? 'Add a comment'
                      : 'Tweet your reply',
              hintStyle: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

class _UserList extends StatelessWidget {
  _UserList({Key key, this.textEditingController, List<UserModel> list})
      : super(key: key);
  final List<UserModel> list = [];
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(bottom: 50),
      color: TwitterColor.white,
      constraints: BoxConstraints(minHeight: 30, maxHeight: double.infinity),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _UserTile(
            user: list[index],
            onUserSelected: (user) {
              Utility.my_toast_short("Changed ==> " + user.first_name);
            },
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key key, this.user, this.onUserSelected}) : super(key: key);
  final UserModel user;
  final ValueChanged<UserModel> onUserSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onUserSelected(user);
      },
      leading: customImage(context, user.profile_photo, height: 35),
      title: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 0, maxWidth: fullWidth(context) * .5),
            child: TitleText(user.first_name,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: 3),
          user.isVerified.contains("1")
              ? customIcon(
                  context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: AppColor.primary,
                  size: 13,
                  paddingIcon: 3,
                )
              : SizedBox(width: 0),
        ],
      ),
      subtitle: Text(user.first_name),
    );
  }
}
