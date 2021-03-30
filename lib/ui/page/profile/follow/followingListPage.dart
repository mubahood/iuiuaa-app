import 'package:flutter/material.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/ui/page/common/usersListPage.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:provider/provider.dart';

class FollowingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return UsersListPage(
        pageTitle: 'Following',
        userIdsList: [],
        appBarIcon: AppIcon.follow,
        emptyScreenText:
            '${state?.profileUserModel?.username ?? state.userModel.username} isn\'t follow anyone',
        emptyScreenSubTileText: 'When they do they\'ll be listed here.');
  }
}
