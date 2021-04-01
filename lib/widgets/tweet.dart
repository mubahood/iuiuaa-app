import 'package:flutter/material.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/newWidget/title_text.dart';
import 'package:iuiuaa/widgets/tweetIconsRow.dart';
import 'package:iuiuaa/widgets/tweetImage.dart';
import 'package:iuiuaa/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';

import 'customWidgets.dart';

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

    Navigator.of(context).pushNamed(Constants.FeedPostDetail, arguments: model.post_id);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: type == TweetType.Tweet || type == TweetType.Reply
                      ? 12
                      : 0,
                ),
                child: type == TweetType.Tweet || type == TweetType.Reply
                    ? _TweetBody(
                        isDisplayOnProfile: isDisplayOnProfile,
                        model: model,
                        trailing: trailing,
                        type: type,
                      )
                    : _TweetDetailBody(
                        isDisplayOnProfile: isDisplayOnProfile,
                        model: model,
                        trailing: trailing,
                        type: type,
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: TweetImage(
                  model: model,
                  type: type,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: type == TweetType.Detail ? 10 : 60),
                child: TweetIconsRow(
                  type: type,
                  model: model,
                  isTweetDetail: type == TweetType.Detail,
                  iconColor: Theme.of(context).textTheme.caption.color,
                  iconEnableColor: TwitterColor.ceriseRed,
                  size: 20,
                ),
              ),
              type == TweetType.ParentTweet
                  ? SizedBox.shrink()
                  : Divider(height: .5, thickness: .5)
            ],
          ),
        ),
      ],
    );
  }
}

class _TweetBody extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final TweetType type;
  final bool isDisplayOnProfile;

  const _TweetBody(
      {Key key, this.model, this.trailing, this.type, this.isDisplayOnProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double descriptionFontSize = type == TweetType.Tweet
        ? 15
        : type == TweetType.Detail || type == TweetType.ParentTweet
            ? 18
            : 14;
    FontWeight descriptionFontWeight =
        type == TweetType.Tweet || type == TweetType.Tweet
            ? FontWeight.w400
            : FontWeight.w400;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.

              Navigator.of(context).pushNamed(Constants.ProfilePage, arguments: model.post_by);

            },
            child: customImage(context, model.user.profile_photo),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: fullWidth(context) - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: 0, maxWidth: fullWidth(context) * .5),
                          child: TitleText(model.user.first_name + model.user.last_name,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(width: 3),
                        model.user.isVerified.contains("1")
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
                          width: model.user.isVerified.contains("1") ? 5 : 0,
                        ),

                        SizedBox(width: 4),
                        customText(  '· ${Utility.getChatTime(model.createdAt)}',
                            style: TextStyles.userNameStyle),
                      ],
                    ),
                  ),
                  Container(child: trailing == null ? SizedBox() : trailing),
                ],
              ),
              model.description == null
                  ? SizedBox()
                  : UrlText(
                      text: model.description,
                      onHashTagPressed: (tag) {
                        cprint(tag);
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: descriptionFontSize,
                          fontWeight: descriptionFontWeight),
                      urlStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: descriptionFontSize,
                          fontWeight: descriptionFontWeight),
                    ),
            ],
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

class _TweetDetailBody extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final TweetType type;
  final bool isDisplayOnProfile;

  const _TweetDetailBody(
      {Key key, this.model, this.trailing, this.type, this.isDisplayOnProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double descriptionFontSize = type == TweetType.Tweet
        ? getDimention(context, 15)
        : type == TweetType.Detail
            ? getDimention(context, 18)
            : type == TweetType.ParentTweet
                ? getDimention(context, 14)
                : 10;

    FontWeight descriptionFontWeight =
        type == TweetType.Tweet || type == TweetType.Tweet
            ? FontWeight.w300
            : FontWeight.w400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: fullWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: GestureDetector(
                  onTap: () {

                    Navigator.of(context)
                        .pushNamed('/ProfilePage/' + model?.post_by);
                  },
                  child: customImage(context, model.user.profile_photo),
                ),
                title: Row(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 0, maxWidth: fullWidth(context) * .5),
                      child: TitleText(model.user.first_name,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(width: 3),
                    model.user.isVerified.contains("1")
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
                      width: model.user.isVerified.contains("1") ? 5 : 0,
                    ),
                  ],
                ),
                subtitle: customText('${model.user.first_name}',
                    style: TextStyles.userNameStyle),
                trailing: trailing,
              ),
              model.description == null
                  ? SizedBox()
                  : Padding(
                      padding: type == TweetType.ParentTweet
                          ? EdgeInsets.only(left: 80, right: 16)
                          : EdgeInsets.symmetric(horizontal: 16),
                      child: UrlText(
                        text: model.description,
                        onHashTagPressed: (tag) {
                          cprint(tag);
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: descriptionFontSize,
                          fontWeight: descriptionFontWeight,
                        ),
                        urlStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: descriptionFontSize,
                          fontWeight: descriptionFontWeight,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
