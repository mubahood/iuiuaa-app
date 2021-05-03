import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/enum.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/state/authState.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

import '../homePage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPage createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  bool is_loading = true;
  UserModel logged_in_user = null;

  Future<void> _my_init() async {
    if (dbHelper == null) {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
    }
    if (dbHelper == null) {
      Utility.my_toast_short("Failed to init db.");
      return;
    }
    logged_in_user = await dbHelper.get_logged_user();
    if (logged_in_user == null) {
    } else {
      Navigator.pushNamed(context, Constants.PAGE_HOME)
          .then((value) => {Navigator.pop(context)});
    }
    is_loading = false;
    setState(() {

    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _my_init();
    });

    super.initState();
  }

  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: TwitterColor.dodgetBlue,
        onPressed: () {
          Navigator.pushNamed(context, Constants.PAGE_SIGNUP);
        },
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TitleText('Sign Up', color: Colors.white),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: is_loading
          ? Center(
              child: Container(
                color: Color(0xfff8f8f8),
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
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    child: Image.asset('assets/images/icon-480.png'),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TitleText(
                    'Join IUIU-AA and reconnect with your OBs & OGs right now!',
                    fontSize: 25,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  _submitButton(),
                  Spacer(),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      TitleText(
                        'Have an account already?',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Constants.PAGE_SIGNUP).then((value) => {
                            //Navigator.pop(context)
                          });
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                          child: TitleText(
                            ' Log in',
                            fontSize: 14,
                            color: TwitterColor.dodgetBlue,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN ||
              state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : HomePage(),
    );
  }
}
