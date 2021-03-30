import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  UserModel user = new UserModel();

  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Sign up'),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, Constants.PAGE_SIGNUP);
              },
            ),
            ElevatedButton(
              child: Text('Main HOme'),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, Constants.PAGE_HOME);
              },
            ),
            ElevatedButton(
              child: Text('EditProfilePage'),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, Constants.EditProfile);
              },
            ),
            ElevatedButton(
              child: Text('get web user'),
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    //check_login();
  }

  Future<void> check_login() async {
    print("MUHINDO starts");
    UserModel logged_user;
    print("MUHINDO ENDS");
    logged_user = await dbHelper.get_logged_user();

    if (logged_user == null) {
      return;
    } else {
      Navigator.pushNamed(context, Constants.PAGE_HOME);
      return;
    }
  }
}
