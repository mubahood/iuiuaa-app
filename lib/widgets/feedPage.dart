import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/state/feedState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/emptyList.dart';
import 'package:iuiuaa/widgets/tweet.dart';
import 'package:iuiuaa/widgets/tweet/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<UserModel> _users = [];
  UserModel loggined_user = null;
  List<FeedModel> _posts = [];
  bool isBusy = true;

  @override
  void initState() {
    my_init();
    super.initState();
  }

  Future<void> my_init() async {
    isBusy = true;
    setState(() {});
    Map<String, String> params = {};
    _users = await Utility.get_web_user(params);
    await Utility.get_web_posts(params);
    loggined_user = await dbHelper.get_logged_user();

    if (_users == null || _users.isEmpty) {
      _users = await dbHelper.user_get(" 1 ");
    }

    _posts = await dbHelper.get_posts(null);

    print("ROBINA: STARTS ==> " + _posts.length.toString());
    isBusy = false;
    setState(() {});
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //my_init();
        Navigator.pushNamed(context, Constants.ComposeTweetPage);
      },
      child: customIcon(
        context,
        icon: AppIcon.fabTweet,
        istwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _getUserAvatar(BuildContext context, UserModel u) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: customInkWell(
          context: context,
          onPressed: () {
            /// Open up sidebaar drawer on user avatar tap
            widget.scaffoldKey.currentState.openDrawer();
          },
          child: u == null
              ? Text("Image6666")
              : customImage(context, u.profile_photo, height: 30),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: _floatingActionButton(context),
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: Container(
          height: fullHeight(context),
          width: fullWidth(context),
          child: RefreshIndicator(
              key: widget.refreshIndicatorKey,
              onRefresh: () async {
                /// refresh home page feed
                my_init();
              },
              child: Consumer<FeedState>(
                builder: (context, state, child) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      child,
                      isBusy || _posts == null
                          ? SliverToBoxAdapter(
                              child: Container(
                                height: fullHeight(context) - 135,
                                child: Center(
                                  child: Container(
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 135,
                                            height: 135,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          Image.asset(
                                            'assets/images/icon-480.png',
                                            height: 120,
                                            width: 120,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : !state.isBusy && _posts == null
                              ? SliverToBoxAdapter(
                                  child: EmptyList(
                                    'No Tweet added yet',
                                    subTitle:
                                        'When new Tweet added, they\'ll show up here \n Tap tweet button to add new',
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildListDelegate(
                                    _posts.map(
                                      (model) {
                                        return Container(
                                          color: Colors.white,
                                          child: Tweet(
                                            model: model,
                                            trailing: TweetBottomSheet()
                                                .tweetOptionIcon(context,
                                                    model: model,
                                                    type: TweetType.Tweet,
                                                    scaffoldKey:
                                                        widget.scaffoldKey),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                )
                    ],
                  );
                },
                child: SliverAppBar(
                  floating: true,
                  elevation: 0,
                  leading: _getUserAvatar(context, loggined_user),
                  title: customTitleText('Home'),
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  backgroundColor: Theme.of(context).appBarTheme.color,
                  bottom: PreferredSize(
                    child: Container(
                      color: Colors.grey.shade200,
                      height: 1.0,
                    ),
                    preferredSize: Size.fromHeight(0.0),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
