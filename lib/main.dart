import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iuiuaa/state/searchState.dart';
import 'package:iuiuaa/ui/page/Auth/signup.dart';
import 'package:iuiuaa/ui/page/homePage.dart';
import 'package:iuiuaa/ui/page/message/newMessagePage.dart';
import 'package:iuiuaa/ui/page/profile/EditProfilePage.dart';
import 'package:iuiuaa/ui/page/profile/profilePage.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/composeTweet.dart';
import 'package:provider/provider.dart';

import 'helper/constant.dart';
import 'helper/routes.dart';
import 'state/appState.dart';
import 'state/authState.dart';
import 'state/chatState.dart';
import 'state/feedState.dart';
import 'state/notificationState.dart';
import 'ui/page/common/splash.dart';
import 'ui/page/message/chatScreenPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
        ChangeNotifierProvider<NotificationState>(
            create: (_) => NotificationState()),
      ],
      child: MaterialApp(
        title: 'Fwitter',
        theme: AppTheme.apptheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => HomePage(),
          Constants.PAGE_SIGNUP: (context) => Signup(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          Constants.PAGE_HOME: (context) => HomePage(),
          Constants.ProfilePage: (context) => ProfilePage("1"),
          Constants.EditProfile: (context) => EditProfilePage(),
          Constants.ChatScreenPage: (context) => ChatScreenPage(),
          Constants.ComposeTweetPage: (context) => ComposeTweetPage(),
          Constants.NewMessagePage: (context) => NewMessagePage(),
        },
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: "SplashPage",
      ),
    );
  }
}
