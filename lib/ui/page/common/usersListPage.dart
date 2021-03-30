import 'package:flutter/material.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/searchState.dart';
import 'package:iuiuaa/ui/page/common/widget/userListWidget.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/emptyList.dart';
import 'package:provider/provider.dart';

class UsersListPage extends StatelessWidget {
  UsersListPage({
    Key key,
    this.pageTitle = "",
    this.appBarIcon,
    this.emptyScreenText,
    this.emptyScreenSubTileText,
    this.user_idsList, List userIdsList,
  }) : super(key: key);

  final String pageTitle;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  final IconData appBarIcon;
  final List<String> user_idsList;

  @override
  Widget build(BuildContext context) {
    List<UserModel> userList;
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      appBar: AppBar(
        title: customTitleText(pageTitle),
      ),
      body: Consumer<SearchState>(
        builder: (context, state, child) {
          if (user_idsList != null && user_idsList.isNotEmpty) {}
          return !(userList != null && userList.isNotEmpty)
              ? Container(
                  width: fullWidth(context),
                  padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                  child: NotifyText(
                    title: emptyScreenText,
                    subTitle: emptyScreenSubTileText,
                  ),
                )
              : UserListWidget(
                  list: userList,
                  emptyScreenText: emptyScreenText,
                  emptyScreenSubTileText: emptyScreenSubTileText,
                );
        },
      ),
    );
  }
}
