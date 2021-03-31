import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/chatState.dart';
import 'package:iuiuaa/state/searchState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customAppBar.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<StatefulWidget> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    get_users();
    super.initState();
  }

  Future<void> get_users() async {
    if (dbHelper == null) {
      Utility.my_toast("Database is null");
      return;
    }
    List<UserModel> local_users = await dbHelper.user_get(" 1 ");
    if (local_users == null || local_users.isEmpty) {
      Map<String, String> params = {};
      List<UserModel> web_users = await Utility.get_web_user(params);
      local_users = await dbHelper.user_get(" 1 ");
    }

    Map<String, String> params = {};
    Utility.get_web_user(params);

    if (local_users != null) {
      users = [];
      users_display = [];
      users.clear();
      users_display.clear();
      users = local_users;
      users_display = users;
    }
    setState(() {});
  }

  List<UserModel> users = [];
  List<UserModel> users_display = [];
  List<UserModel> users_temp = [];
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  Widget _userTile(UserModel user) {
    print(user.profile_photo);
    return ListTile(
      onTap: () {
        final chatState = Provider.of<ChatState>(context, listen: false);
        chatState.setChatUser = user;
        Navigator.pushNamed(context, '/ChatScreenPage',arguments: user.user_id.toString());
      },

      leading: customImage(context, user.profile_photo, height: 50),

      title: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 0, maxWidth: fullWidth(context) - 104),
            child: TitleText(user.first_name+" "+user.last_name,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(width: 3),
          user.isVerified.contains("1")
              ? customIcon(context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: AppColor.primary,
                  size: 13,
                  paddingIcon: 3)
              : SizedBox(width: 0),
        ],
      ),
      subtitle: (user.campus!=null && user.campus.length>2)? Text(user.campus):Text(user.username),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          scaffoldKey: widget.scaffoldKey,
          isBackButton: true,
          isbootomLine: true,
          title: customTitleText(
            'New Message',
          ),
        ),
        body: users_display == null
            ? Center(
                child: Text("Loading..."),
              )
            : Consumer<SearchState>(
                builder: (context, state, child) {
                  return Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (text) {
                          String keyword = text.toString().trim().toLowerCase();

                          users_temp = Utility.user_search(keyword, users);
                          users_display = users_temp;
                          setState(() {});

                          //users.filterByUsername(text);
                        },
                        decoration: InputDecoration(
                          hintText: "Search for people",
                          hintStyle: TextStyle(fontSize: 20),
                          prefixIcon: customIcon(
                            context,
                            icon: AppIcon.search,
                            istwitterIcon: true,
                            iconColor: TwitterColor.woodsmoke_50,
                            size: 25,
                            paddingIcon: 5,
                          ),
                          border: InputBorder.none,
                          fillColor: TwitterColor.mystic,
                          filled: true,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) => _userTile(
                            users_display[index],
                          ),
                          separatorBuilder: (_, index) => Divider(
                            height: 0,
                          ),
                          itemCount: users_display.length,
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
