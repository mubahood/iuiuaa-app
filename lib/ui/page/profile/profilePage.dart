import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/ui/page/profile/widgets/tabPainter.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/rippleButton.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.profileId);

  final String profileId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool isMyProfile = true;
  int pageIndex = 0;
  final dbHelper = DatabaseHelper.instance;
  UserModel profileUserModel = new UserModel();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> initState() {
    get_local_user(widget.profileId.toString());
    //get_web_user(widget.profileId);
    isMyProfile = true;
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SliverAppBar getAppbar() {
    //print("Muhindo: https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500");
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 220,
      elevation: 0,
      stretch: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.white,
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: (d) {
            if (d.title == "Share") {
              shareProfile(context);
            } else if (d.title == "QR code") {
              Text("QR CODE");
            }
          },
          itemBuilder: (BuildContext context) {
            return choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: 202,
                padding: EdgeInsets.only(bottom: 35),
                child: customNetworkImage(
                  'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                  fit: BoxFit.fill,
                ),
              ),

              /// UserModel avatar, message icon, profile edit and follow/following button
              Container(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          shape: BoxShape.circle),
                      child: RippleButton(
                        child: customImage(
                          context,
                          profileUserModel.profile_photo,
                          height: 90,
                        ),
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () {
                          Navigator.pushNamed(context, "/ProfileImageView");
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60, right: 15, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          isMyProfile
                              ? RippleButton(
                                  splashColor:
                                      TwitterColor.dodgetBlue_50.withAlpha(100),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  onPressed: () {
                                    if (isMyProfile) {
                                      Navigator.pushNamed(
                                          context, '/ChatScreenPage');
                                    }
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    padding: EdgeInsets.only(
                                        bottom: 5, top: 0, right: 0, left: 0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: isMyProfile
                                                ? AppColor.primary
                                                : AppColor.primary,
                                            width: 1),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      AppIcon.edit,
                                      color: AppColor.primary,
                                      size: 20,
                                    ),

                                    // customIcon(context, icon:AppIcon.messageEmpty, iconColor: TwitterColor.dodgetBlue, paddingIcon: 8)
                                  ),
                                )
                              : RippleButton(
                                  splashColor:
                                      TwitterColor.dodgetBlue_50.withAlpha(100),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  onPressed: () {
                                    if (!isMyProfile) {
                                      Navigator.pushNamed(
                                          context, '/ChatScreenPage');
                                    }
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    padding: EdgeInsets.only(
                                        bottom: 5, top: 0, right: 0, left: 0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: isMyProfile
                                                ? AppColor.primary
                                                : AppColor.primary,
                                            width: 1),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      AppIcon.messageEmpty,
                                      color: AppColor.primary,
                                      size: 20,
                                    ),

                                    // customIcon(context, icon:AppIcon.messageEmpty, iconColor: TwitterColor.dodgetBlue, paddingIcon: 8)
                                  ),
                                ),
                          SizedBox(width: 10),
                          RippleButton(
                            splashColor:
                                TwitterColor.dodgetBlue_50.withAlpha(100),
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            onPressed: () {
                              if (isMyProfile) {
                                Navigator.pushNamed(
                                    context, Constants.EditProfile);
                              } else {
                                Text("Followeres");
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isFollower()
                                    ? TwitterColor.dodgetBlue
                                    : TwitterColor.white,
                                border: Border.all(
                                    color: isMyProfile
                                        ? AppColor.primary
                                        : AppColor.primary,
                                    width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              /// If [isMyProfile] is true then Edit profile button will display
                              // Otherwise Follow/Following button will be display
                              child: Text(
                                isMyProfile
                                    ? 'Edit Profile'
                                    : isFollower()
                                        ? 'Following'
                                        : 'Send Message',
                                style: TextStyle(
                                  color: isMyProfile
                                      ? AppColor.primary
                                      : isFollower()
                                          ? TwitterColor.white
                                          : AppColor.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage');
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

  Widget _emptyBox() {
    return SliverToBoxAdapter(child: SizedBox.shrink());
  }

  isFollower() {
    return false;
  }

  /// This meathod called when user pressed back button
  /// When profile page is about to close
  /// Maintain minimum user's profile in profile page list
  Future<bool> _onWillPop() async {
    //final state = Provider.of<AuthState>(context, listen: false);

    /// It will remove last user's profile from profileUserModelList
    //state.removeLastUser();
    return true;
  }

  TabController _tabController;

  void shareProfile(BuildContext context) async {
    var authstate = context.read<AuthState>();
    var user = authstate.profileUserModel;
    //Utility.createLinkAndShare();
  }

  List<FeedModel> list = [];

  @override
  build(BuildContext context) {
    profileUserModel.last_name = "Kule";
    profileUserModel.first_name = "Swaleh";
    profileUserModel.occupation =
        "A computer science and engineering student at IUT";
    profileUserModel.reg_date = "1616374882";
    profileUserModel.nationality = "Uganda";
    profileUserModel.phone_number = "+1616374882";
    profileUserModel.whatsapp = "+1616374882";
    profileUserModel.facebook = "mubahood";
    profileUserModel.twitter = "mubahood";
    profileUserModel.linkedin = "mubahood";
    profileUserModel.website = "website.com";
    profileUserModel.cv =
        "https://www.iuiuaa.org/app/uploads/2020/09/1600649206_535251.pdf";
    profileUserModel.programs =
        "Bachelor's degree in Information Technology, Mbale campus, 2016";
    profileUserModel.about =
        "A student at slamic university of technology currently "
        "pursuing computer science A "
        "student at slamic university of technology currently "
        "pursuing computer science";
    profileUserModel.address = "Kampala, Uganda";

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: !isMyProfile ? null : _floatingActionButton(),
        backgroundColor: TwitterColor.mystic,
        body: SafeArea(
          child: NestedScrollView(
            // controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                getAppbar(),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: UserNameRowWidget(
                      user: profileUserModel,
                      isMyProfile: true,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: TwitterColor.white,
                        child: TabBar(
                          indicator: TabIndicator(),
                          controller: _tabController,
                          tabs: <Widget>[Text("Tweets1"), Text("Media")],
                        ),
                      )
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                Text("Tweets2"),
                Text("Media"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> get_web_user(String user_id) async {
    Map<String, String> params = {'user_id': user_id};
    List<UserModel> users = await Utility.get_web_user(params);
    if (users == null) {
      Utility.my_toast("You are offline.");
      return;
    }
    if (users.isEmpty) {
      Utility.my_toast("Account not found.");
      return;
    }
    await dbHelper.save_user(users[0]);
    get_local_user(user_id);
  }

  Future<void> get_local_user(String string) async {
    List<UserModel> users = await dbHelper
        .user_get(" user_id = '" + widget.profileId.toString() + "' ");
    if (users == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      profileUserModel = users[0];
    });
  }
}

class UserNameRowWidget extends StatelessWidget {
  const UserNameRowWidget({
    Key key,
    @required this.user,
    @required this.isMyProfile,
  }) : super(key: key);

  final bool isMyProfile;
  final UserModel user;

  String getBio(String bio) {
    if (isMyProfile) {
      return bio;
    } else if (bio == "Edit profile to update bio") {
      return "No bio available";
    } else {
      return bio;
    }
  }

  Widget _tappbleText(
      BuildContext context, String count, String text, String navigateTo) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/$navigateTo');
      },
      child: Row(
        children: <Widget>[
          customText(
            '$count ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          customText(
            '$text',
            style: TextStyle(color: AppColor.darkGrey, fontSize: 17),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 0),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            children: <Widget>[
              Text(
                user.first_name + " " + user.last_name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                width: 3,
              ),
              true
                  ? customIcon(context,
                      icon: AppIcon.blueTick,
                      istwitterIcon: true,
                      iconColor: TwitterColor.dodgetBlue,
                      size: 24,
                      paddingIcon: 3)
                  : SizedBox(width: 0),
            ],
          ),
        ),
        user.email.isEmpty == false
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: customText(
                  '${user.email}',
                  style: TextStyles.subtitleStyle.copyWith(fontSize: 13),
                ),
              )
            : SizedBox(width: 0),
        user.about.isEmpty == false
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: customText(getBio(user.about),
                    style: TextStyle(fontSize: 15)),
              )
            : SizedBox(width: 0),
        !user.nationality.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.mapPin,
                        size: 22,
                        istwitterIcon: true,
                        iconColor: AppColor.primary),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: customText(
                        'Born in ' + user.nationality,
                        style:
                            TextStyle(fontSize: 16, color: AppColor.darkGrey),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.address.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.mapSigns,
                        size: 20,
                        istwitterIcon: true,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: customText(
                        "Currently living in " + user.address,
                        style:
                            TextStyle(fontSize: 16, color: AppColor.darkGrey),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.occupation.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.briefcase,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.occupation,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.reg_date.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.calendar,
                        size: 20,
                        istwitterIcon: true,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: customText(
                        Utility.getJoiningDate(user.reg_date),
                        style:
                            TextStyle(fontSize: 16, color: AppColor.darkGrey),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.programs.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.graduationCap,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          "Program(s) completed at IUIU - " + user.programs,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.cv.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.filePdf,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          "Download " + user.last_name + "'s CV",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.phone_number.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.phone,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.phone_number,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.linkedin.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.linkedin,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.linkedin,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.twitter.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.twitter,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.twitter,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.facebook.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.facebook,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.facebook,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.whatsapp.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.whatsapp,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.whatsapp,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
        !user.website.isEmpty
            ? Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customIcon(context,
                        icon: FontAwesomeIcons.chrome,
                        size: 20,
                        istwitterIcon: false,
                        iconColor: AppColor.primary),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: customText(
                          user.website,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(width: 0),
      ],
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final IconData icon;
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Share', icon: Icons.directions_car),
  const Choice(title: 'Draft', icon: Icons.directions_bike),
  const Choice(title: 'View Lists', icon: Icons.directions_boat),
  const Choice(title: 'View Moments', icon: Icons.directions_bus),
  const Choice(title: 'QR code', icon: Icons.directions_railway),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
