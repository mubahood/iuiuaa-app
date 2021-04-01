import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/tweet.dart';
import 'package:iuiuaa/widgets/tweet/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPostDetail extends StatefulWidget {
  FeedPostDetail({Key key, this.postId}) : super(key: key);
  final String postId;

  _FeedPostDetailState createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _my_init();
    });
  }

  bool is_loading = true;

  FeedModel post = FeedModel();
  List<FeedModel> posts = [];
  String post_id = null;
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> _my_init() async {
    try {
      post_id = ModalRoute.of(context).settings.arguments.toString().trim();
    } catch (e) {}

    if (post_id == null || post_id.isEmpty) {
      Utility.my_toast_short("ID not found.");
      Navigator.pop(context);
      return;
    }
    posts = await dbHelper.get_posts(" post_id = '${post_id}' ");

    if (posts == null || posts.isEmpty) {
      Utility.my_toast_short("Post not found.");
      Navigator.pop(context);
      return;
    }

    post = posts.first;
    is_loading = false;
    setState(() {});
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _my_init();
        //Navigator.of(context).pushNamed('/ComposeTweetPage/' + postId);
      },
      child: Icon(Icons.add),
    );
  }

  Widget _commentRow(FeedModel model) {
    return Tweet(
      model: model,
      type: TweetType.Reply,
      trailing: TweetBottomSheet().tweetOptionIcon(context,
          scaffoldKey: scaffoldKey, model: model, type: TweetType.Reply),
    );
  }

  Widget _tweetDetail(FeedModel model) {
    return Tweet(
      model: model,
      type: TweetType.Detail,
      trailing: TweetBottomSheet().tweetOptionIcon(context,
          scaffoldKey: scaffoldKey, model: model, type: TweetType.Detail),
    );
  }

  void addLikeToComment(String commentId) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToTweet(state.tweetDetailModel.last, authState.user_id);
  }

  void openImage() async {
    Navigator.pushNamed(context, Constants.ImageViewPge, arguments: post.post_id);
  }

  void deleteTweet(TweetType type, String tweetId, {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deleteTweet(tweetId, type, parentkey: parentkey);
    Navigator.of(context).pop();
    if (type == TweetType.Detail) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FeedState>(context);
    return WillPopScope(
      onWillPop: () async {
        Provider.of<FeedState>(context, listen: false)
            .removeLastTweetDetail(post_id);
        return Future.value(true);
      },
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: _floatingActionButton(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: customTitleText('Thread'),
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Theme.of(context).appBarTheme.color,
              bottom: PreferredSize(
                child: Container(
                  color: Colors.grey.shade200,
                  height: 1.0,
                ),
                preferredSize: Size.fromHeight(0.0),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  is_loading
                      ? Center(
                          child: Text("Loading..."),
                        )
                      : _tweetDetail(post),
                  Container(
                    height: 6,
                    width: fullWidth(context),
                    color: TwitterColor.mystic,
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                state.tweetReplyMap == null ||
                        state.tweetReplyMap.length == 0 ||
                        state.tweetReplyMap[post_id] == null
                    ? [
                        Container(
                          child: Center(
                              //  child: Text('No comments'),
                              ),
                        )
                      ]
                    : state.tweetReplyMap[post_id]
                        .map((x) => _commentRow(x))
                        .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
