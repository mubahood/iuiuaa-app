import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:provider/provider.dart';

class Tweet extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final TweetType type;
  final bool isDisplayOnProfile;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Tweet({
    Key key,
    this.model,
    this.trailing,
    this.type = TweetType.Tweet,
    this.isDisplayOnProfile = false,
    this.scaffoldKey,
  }) : super(key: key);

  void onLongPressedTweet(BuildContext context) {
    if (type == TweetType.Detail || type == TweetType.ParentTweet) {
      Utility.copyToClipBoard(
          scaffoldKey: scaffoldKey,
          text: model.description ?? "",
          message: "Tweet copy to clipboard");
    }
  }

  void onTapTweet(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    if (type == TweetType.Detail || type == TweetType.ParentTweet) {
      return;
    }
    if (type == TweetType.Tweet && !isDisplayOnProfile) {
      feedstate.clearAllDetailAndReplyTweetStack();
    }
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/' + model.post_by);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        /// Left vertical bar of a tweet
        type != TweetType.ParentTweet
            ? SizedBox.shrink()
            : Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 38,
                    top: 75,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 3.0, color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
        InkWell(
          onLongPress: () {
            onLongPressedTweet(context);
          },
          onTap: () {
            onTapTweet(context);
          },
          child: Text("Tweet post..."),
        ),
      ],
    );
  }
}
