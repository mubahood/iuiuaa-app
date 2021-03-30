import 'package:flutter/material.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/ui/page/common/usersListPage.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class FollowerListPage extends StatelessWidget {
  FollowerListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return UsersListPage(
      pageTitle: 'Followers',
      userIdsList: [],
      appBarIcon: AppIcon.follow,
      emptyScreenText:
          '${state?.profileUserModel?.username ?? state.userModel.username} doesn\'t have any followers',
      emptyScreenSubTileText:
          'When someone follow them, they\'ll be listed here.',
    );
  }
}
