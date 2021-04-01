import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/tweetIconsRow.dart';
import 'package:provider/provider.dart';

class ImageViewPge extends StatefulWidget {
  _ImageViewPgeState createState() => _ImageViewPgeState();
}

class _ImageViewPgeState extends State<ImageViewPge> {
  bool isToolAvailable = true;

  FocusNode _focusNode;
  TextEditingController _textEditingController;

  @override
  void initState() {
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _my_init();
    });

    super.initState();
  }

  bool is_loading = true;

  Future<void> _my_init() async {
    try {
      post_id = ModalRoute.of(context).settings.arguments.toString().trim();
    } catch (e) {}

    if (post_id == null || post_id.isEmpty) {
      Utility.my_toast_short("ID not found.");
      //Navigator.pop(context);
      return;
    }
    posts = await dbHelper.get_posts(" post_id = '${post_id}' ");

    if (posts == null || posts.isEmpty) {
      Utility.my_toast_short("Post not found. ==> "+post_id);
      //Navigator.pop(context);
      return;
    }

    post = posts.first;
    is_loading = false;
    setState(() {});
  }

  FeedModel post = FeedModel();
  List<FeedModel> posts = [];
  String post_id = null;
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  Widget _body() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: is_loading
              ? Center(
                  child: Text("Loading..."),
                )
              : Container(
                  color: Colors.brown.shade700,
                  constraints: BoxConstraints(
                    maxHeight: fullHeight(context),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isToolAvailable = !isToolAvailable;
                      });
                    },
                    child:
                        _imageFeed(post.post_thumbnail),
                  ),
                ),
        ),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown.shade700.withAlpha(200),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          BackButton(
                            color: Colors.white,
                          ),
                        ],
                      )),
                )),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TweetIconsRow(
                        model: post,
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        iconEnableColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      Container(
                        color: Colors.brown.shade700.withAlpha(200),
                        padding:
                            EdgeInsets.only(right: 10, left: 10, bottom: 10),
                        child: TextField(
                          controller: _textEditingController,
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.blue,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _submitButton();
                              },
                              icon: Icon(Icons.send, color: Colors.white),
                            ),
                            focusColor: Colors.black,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            hintText: 'Comment here..',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _imageFeed(String _image) {
    return _image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Container(
                child: InteractiveViewer(
              child: customNetworkImage(
                _image,
                fit: BoxFit.fitWidth,
              ),
            )),
          );
  }

  void _submitButton() {
    if (_textEditingController.text == null ||
        _textEditingController.text.isEmpty) {
      return;
    }
    if (_textEditingController.text.length > 280) {
      return;
    }
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    var user = authState.userModel;
    var profilePic = user.profile_photo;
    if (profilePic == null) {
      profilePic = Constants.dummyProfilePic;
    }
    var name = authState.userModel.first_name ??
        authState.userModel.email.split('@')[0];
    var pic = authState.userModel.profile_photo ?? Constants.dummyProfilePic;
    var tags = Utility.getHashTags(_textEditingController.text);

    UserModel commentedUser = UserModel();

    var postId = state.tweetDetailModel.last.post_id;

    FeedModel reply = FeedModel();
    state.addcommentToPost(reply);
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() {
      _textEditingController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }
}
