import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/customRoute.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/ui/page/common/usersListPage.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class TweetIconsRow extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double size;
  final bool isTweetDetail;
  final TweetType type;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TweetIconsRow(
      {Key key,
      this.model,
      this.iconColor,
      this.iconEnableColor,
      this.size,
      this.isTweetDetail = false,
      this.type,
      this.scaffoldKey})
      : super(key: key);

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var authState = Provider.of<AuthState>(context, listen: false);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 0, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          _iconWidget(
            context,
            text: isTweetDetail ? '' : model.view_count.toString(),
            icon: AppIcon.reply,
            iconColor: iconColor,
            size: size ?? 20,
            onPressed: () {
              var state = Provider.of<FeedState>(context, listen: false);
              state.setTweetToReply = model;
              Navigator.of(context).pushNamed('/ComposeTweetPage');
            },
          ),
          _iconWidget(context,
              text: isTweetDetail ? '' : model.view_count.toString(),
              icon: AppIcon.retweet,
              iconColor: iconColor,
              size: size ?? 20, onPressed: () {
            Utility.my_toast_short("TweetBottomSheet");
          }),
          _iconWidget(context, text: '', icon: null, sysIcon: Icons.share,
              onPressed: () {
            shareTweet(context);
          }, iconColor: iconColor, size: size ?? 20),
        ],
      ),
    );
  }

  Widget _iconWidget(BuildContext context,
      {String text,
      IconData icon,
      Function onPressed,
      IconData sysIcon,
      Color iconColor,
      double size = 20}) {
    return Expanded(
      child: Container(
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                if (onPressed != null) onPressed();
              },
              icon: sysIcon != null
                  ? Icon(sysIcon, color: iconColor, size: size)
                  : customIcon(
                      context,
                      size: size,
                      icon: icon,
                      istwitterIcon: true,
                      iconColor: iconColor,
                    ),
            ),
            customText(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: iconColor,
                fontSize: size - 5,
              ),
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            SizedBox(width: 5),
            customText(Utility.getPostTime2(model.createdAt),
                style: TextStyles.textStyle14),
            SizedBox(width: 10),
            customText('Fwitter for Android',
                style: TextStyle(color: Theme.of(context).primaryColor))
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _likeCommentWidget(BuildContext context) {
    bool isLikeAvailable =
        model.view_count != null ? int.parse(model.view_count) > 0 : false;
    bool isRetweetAvailable = int.parse(model.view_count) > 0;
    bool isLikeRetweetAvailable = isRetweetAvailable || isLikeAvailable;
    return Column(
      children: <Widget>[
        Divider(
          endIndent: 10,
          height: 0,
        ),
        AnimatedContainer(
          padding:
              EdgeInsets.symmetric(vertical: isLikeRetweetAvailable ? 12 : 0),
          duration: Duration(milliseconds: 500),
          child: !isLikeRetweetAvailable
              ? SizedBox.shrink()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    !isRetweetAvailable
                        ? SizedBox.shrink()
                        : customText(model.view_count.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                    !isRetweetAvailable
                        ? SizedBox.shrink()
                        : SizedBox(width: 5),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: customText('Retweets',
                          style: TextStyles.subtitleStyle),
                      crossFadeState: !isRetweetAvailable
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 800),
                    ),
                    !isRetweetAvailable
                        ? SizedBox.shrink()
                        : SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        onLikeTextPressed(context);
                      },
                      child: AnimatedCrossFade(
                        firstChild: SizedBox.shrink(),
                        secondChild: Row(
                          children: <Widget>[
                            customSwitcherWidget(
                              duraton: Duration(milliseconds: 300),
                              child: customText(model.view_count.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  key: ValueKey(model.view_count)),
                            ),
                            SizedBox(width: 5),
                            customText('Likes', style: TextStyles.subtitleStyle)
                          ],
                        ),
                        crossFadeState: !isLikeAvailable
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 300),
                      ),
                    )
                  ],
                ),
        ),
        !isLikeRetweetAvailable
            ? SizedBox.shrink()
            : Divider(
                endIndent: 10,
                height: 0,
              ),
      ],
    );
  }

  void addLikeToTweet(BuildContext context) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToTweet(model, authState.user_id);
  }

  void onLikeTextPressed(BuildContext context) {
    Navigator.of(context).push(
      CustomRoute<bool>(
        builder: (BuildContext context) => UsersListPage(
          pageTitle: "Liked by",
          userIdsList: [],
          emptyScreenText: "This tweet has no like yet",
          emptyScreenSubTileText:
              "Once a user likes this tweet, user list will be shown here",
        ),
      ),
    );
  }

  void shareTweet(BuildContext context) async {
    Utility.my_toast_short("TweetBottomSheet 1");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        isTweetDetail ? _timeWidget(context) : SizedBox(),
        isTweetDetail ? _likeCommentWidget(context) : SizedBox(),
        _likeCommentsIcons(context, model)
      ],
    ));
  }
}
