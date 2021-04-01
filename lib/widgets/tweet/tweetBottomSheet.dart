import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/tweet.dart';
import 'package:provider/provider.dart';

import '../share_widget.dart';

class TweetBottomSheet {
  Widget tweetOptionIcon(BuildContext context,
      {FeedModel model, TweetType type, GlobalKey<ScaffoldState> scaffoldKey}) {
    return customInkWell(
        radius: BorderRadius.circular(20),
        context: context,
        onPressed: () {
          _openbottomSheet(context,
              type: type, model: model, scaffoldKey: scaffoldKey);
        },
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: customIcon(context,
              icon: AppIcon.arrowDown,
              istwitterIcon: true,
              iconColor: AppColor.lightGrey),
        ));
  }

  void _openbottomSheet(BuildContext context,
      {TweetType type,
      FeedModel model,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    bool isMyTweet = true;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) *
                (type == TweetType.Tweet
                    ? (isMyTweet ? .25 : .44)
                    : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: type == TweetType.Tweet
                ? _tweetOptions(context,
                    scaffoldKey: scaffoldKey,
                    isMyTweet: isMyTweet,
                    model: model,
                    type: type)
                : _tweetDetailOptions(context,
                    scaffoldKey: scaffoldKey,
                    isMyTweet: isMyTweet,
                    model: model,
                    type: type));
      },
    );
  }

  Widget _tweetDetailOptions(BuildContext context,
      {bool isMyTweet,
      FeedModel model,
      TweetType type,
      GlobalKey<ScaffoldState> scaffoldKey}) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.link,
            text: 'Copy link to tweet', isEnable: true, onPressed: () async {
          var uri = "https://ugnews24.info/app";

          Navigator.pop(context);
          Utility.copyToClipBoard(
              scaffoldKey: scaffoldKey,
              text: uri.toString(),
              message: "Tweet link copy to clipboard");
        }),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Pin to profile',
              )
            : _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Unfollow ${model.user.username}',
              ),

        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.mute,
                text: 'Mute ${model.user.username}',
              ),
        _widgetBottomSheetRow(
          context,
          AppIcon.mute,
          text: 'Mute this convertion',
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.viewHidden,
          text: 'View hidden replies',
        ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.block,
                text: 'Block ${model.user.username}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.report,
                text: 'Report Tweet',
              ),
      ],
    );
  }

  Widget _tweetOptions(BuildContext context,
      {bool isMyTweet,
      FeedModel model,
      TweetType type,
      GlobalKey<ScaffoldState> scaffoldKey}) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.link,
            text: 'Copy link to tweet', isEnable: true, onPressed: () async {
          var uri = "https://www.ugnews24.info";
          Navigator.pop(context);
          Utility.copyToClipBoard(
              scaffoldKey: scaffoldKey,
              text: uri.toString(),
              message: "Tweet link copy to clipboard");
        }),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.thumbpinFill,
                text: 'Pin to profile',
              )
            : _widgetBottomSheetRow(
                context,
                AppIcon.sadFace,
                text: 'Not interested in this',
              ),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Delete Tweet',
                onPressed: () {
                  _deleteTweet(
                    context,
                    type,
                    model.post_by,
                  );
                },
                isEnable: true,
              )
            : Container(),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Unfollow ${model.user.username}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.mute,
                text: 'Mute ${model.user.username}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.block,
                text: 'Block ${model.user.username}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.report,
                text: 'Report Tweet',
              ),
      ],
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, IconData icon,
      {String text, Function onPressed, bool isEnable = false}) {
    return Expanded(
      child: customInkWell(
        context: context,
        onPressed: () {
          if (onPressed != null)
            onPressed();
          else {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              customIcon(
                context,
                icon: icon,
                istwitterIcon: true,
                size: 25,
                paddingIcon: 8,
                iconColor:
                    onPressed != null ? AppColor.darkGrey : AppColor.lightGrey,
              ),
              SizedBox(
                width: 15,
              ),
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.secondary : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTweet(BuildContext context, TweetType type, String tweetId,
      {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deleteTweet(tweetId, type, parentkey: parentkey);
    // CLose bottom sheet
    Navigator.of(context).pop();
    if (type == TweetType.Detail) {
      // Close Tweet detail page
      Navigator.of(context).pop();
      // Remove last tweet from tweet detail stack page
      state.removeLastTweetDetail(tweetId);
    }
  }

  void openRetweetbottomSheet(BuildContext context,
      {TweetType type,
      FeedModel model,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: 130,
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _retweet(context, model, type));
      },
    );
  }

  Widget _retweet(BuildContext context, FeedModel model, TweetType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.retweet,
          isEnable: true,
          text: 'Retweet',
          onPressed: () {
            var state = Provider.of<FeedState>(context, listen: false);
            var authState = Provider.of<AuthState>(context, listen: false);
            var myUser = authState.userModel;
            myUser = UserModel();
            // Prepare current Tweet model to reply


            Navigator.pop(context);
          },
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.edit,
          text: 'Retweet with comment',
          isEnable: true,
          onPressed: () {
            var state = Provider.of<FeedState>(context, listen: false);
            // Prepare current Tweet model to reply
            state.setTweetToReply = model;
            Navigator.pop(context);

            /// `/ComposeTweetPage/retweet` route is used to identify that tweet is going to be retweet.
            /// To simple reply on any `Tweet` use `ComposeTweetPage` route.
            Navigator.of(context).pushNamed('/ComposeTweetPage/retweet');
          },
        )
      ],
    );
  }

  void openShareTweetBottomSheet(
      BuildContext context, FeedModel model, TweetType type) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: 130,
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _shareTweet(context, model, type));
      },
    );
  }

  Widget _shareTweet(BuildContext context, FeedModel model, TweetType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.link,
          isEnable: true,
          text: 'Share Link',
          onPressed: () async {
            var url = Utility.createLinkToShare();
            var uri = await url;
            Utility.share(uri.toString(), subject: "Tweet");
            Navigator.pop(context);
          },
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.image,
          text: 'Share with Tweet thumbnail',
          isEnable: true,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              ShareWidget.getRoute(
                child: Tweet(
                  model: model,
                  type: type,
                ),
                id: "tweet/${model.post_by}",
              ),
            );
          },
        )
      ],
    );
  }
}
