import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:http/http.dart' as http;
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/model/responseModel.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/customLoader.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final dbHelper = DatabaseHelper.instance;


  TextEditingController _first_name_controller;
  TextEditingController _last_name_controller;
  TextEditingController _emailController;
  TextEditingController _campusController;
  TextEditingController _reg_number_controller;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  CustomLoader loader;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    check_login();
    loader = CustomLoader();
    _first_name_controller = TextEditingController();
    _reg_number_controller = TextEditingController();
    _reg_number_controller.text = "";
    _first_name_controller.text = "Muhindo";
    _last_name_controller = TextEditingController();
    _last_name_controller.text = "Mubark";
    _emailController = TextEditingController();
    _campusController = TextEditingController();
    _campusController.text = "";
    _emailController.text = "test1@gmail.com";
    _passwordController = TextEditingController();
    _passwordController.text = "123456";
    _confirmController = TextEditingController();
    _confirmController.text = "123456";
    super.initState();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _last_name_controller.dispose();
    _first_name_controller.dispose();
    _confirmController.dispose();
    _campusController.dispose();
    _reg_number_controller.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
      height: fullHeight(context) - 88,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _entryFeild('First name', controller: _first_name_controller),
              _entryFeild('Last name', controller: _last_name_controller),
              _entryFeild('Enter email',
                  controller: _emailController, isEmail: true),
              // _entryFeild('Mobile no',controller: _mobileController),
              _entryFeildSelect('Campus', controller: _campusController),
              _entryFeild('Your last IUIU Reg. Number',
                  controller: _reg_number_controller),

              _entryFeild('Enter password',
                  controller: _passwordController, isPassword: true),
              _entryFeild('Confirm password',
                  controller: _confirmController, isPassword: true),
              _submitButton(context),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  List<String> Campuses = <String>[
    'Arua campus',
    "Female's campus - Kabojja",
    'Kampala campus',
    'Mbale campus'
  ];
  bool campuses_expanded = false;

  Widget _entryFeildSelect(String hint, {TextEditingController controller}) {
    FocusNode _focus = new FocusNode();

    _focus.addListener(() {
      if (campuses_expanded) {
        return;
      }
      campuses_expanded = true;
      var selectedUsState = "Connecticut";

      showMaterialScrollPicker(
          context: context,
          headerColor: Colors.green,
          title: "Pick your campus",
          items: Campuses,
          selectedItem: selectedUsState,
          onChanged: (value) => setState(() {
                selectedUsState = value;
                controller.text = value;
                campuses_expanded = false;
              }),
          onCancelled: () {
            campuses_expanded = false;
          },
          onConfirmed: () {
            campuses_expanded = false;
          });
    });

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        focusNode: _focus,
        controller: controller,
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.green),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.green),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: TwitterColor.dodgetBlue,
        onPressed: _submitForm,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _submitForm() async {
    UserModel user = new UserModel();
    if (_emailController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please enter name');
      return;
    }

    if (_emailController.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
      return;
    }
    user.email = _emailController.text.toLowerCase().toString();

    if (_first_name_controller.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'First name too short.');
      return;
    }
    user.first_name = _first_name_controller.text.toString();

    if (_last_name_controller.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'First name too short.');
      return;
    }
    user.last_name = _last_name_controller.text.toString();

    if (_reg_number_controller.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Registration number not entered.');
      return;
    }
    user.reg_number = _reg_number_controller.text.toString();

    if (_campusController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Campus not selected.');
      return;
    }
    user.campus = _campusController.text.toString();

    if (!Campuses.contains(user.campus)) {
      customSnackBar(_scaffoldKey, 'Invalid Campus.');
      return;
    }

    if (_emailController.text == null ||
        _emailController.text.isEmpty ||
        _passwordController.text == null ||
        _passwordController.text.isEmpty ||
        _confirmController.text == null) {
      customSnackBar(_scaffoldKey, 'Please fill form carefully');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      customSnackBar(
          _scaffoldKey, 'Password and confirm password did not match');
      return;
    }

    user.username = _emailController.text.toLowerCase();
    user.password_plain = _passwordController.text.toLowerCase();
    user.email = _emailController.text.toLowerCase();
    user.first_name = _first_name_controller.text.toLowerCase();
    user.last_name = _last_name_controller.text.toLowerCase();

    if (dbHelper == null) {
      customSnackBar(_scaffoldKey, "Failed to create local database.");
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();

    final _path = "/wp/wp-json/celeb/v1/create_account";
    final _params = user.toJson();

    loader.showLoader(context);
    final _uri = Uri.https(Constants.BASE_URL, _path, _params);
    var response = await http.get(_uri);

    if (response == null) {
      customSnackBar(_scaffoldKey, "Failed to get data.");
      loader.hideLoader();
      return;
    }

    if (response.statusCode != 200) {
      customSnackBar(_scaffoldKey,
          'Failed to connect to internet. ' + response.statusCode.toString());
      loader.hideLoader();
      return;
    }

    String rawJson = response.body;
    Map<String, dynamic> map = jsonDecode(rawJson);
    ResponseModel data = ResponseModel.fromJson(map);


    if (data == null) {
      customSnackBar(_scaffoldKey, 'Totally failed to decode data.');
      loader.hideLoader();
      return;
    }

    if (data.code == null) {
      customSnackBar(_scaffoldKey, 'Failed to decode data.');
      loader.hideLoader();
      return;
    }



    if (data.code != 1) {
      customSnackBar(_scaffoldKey, data.message);
      loader.hideLoader();
      return;
    }


    UserModel new_user = new UserModel();
    Map<String, dynamic> user_map = jsonDecode(data.data);
    new_user = UserModel.fromJson(user_map);

    if (new_user == null) {
      customSnackBar(_scaffoldKey, "Failed to parse user object.");
      loader.hideLoader();
      return;
    }

    if (new_user.user_id == null) {
      customSnackBar(_scaffoldKey, "User id is null.");
      loader.hideLoader();
      return;
    }

    bool login_user = await dbHelper.save_user(new_user);
    loader.hideLoader();
    print("ROMINA: " + new_user.user_id);

    if (login_user) {
      customSnackBar(_scaffoldKey, "Logged successfully");
      return;
    } else {
      customSnackBar(_scaffoldKey, "Failed to login " + new_user.first_name);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText(
          'Sign Up',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }

  Future<void> check_login() async {
    UserModel logged_user;
    logged_user = await dbHelper.get_logged_user();
    if (logged_user == null) {
    } else {
      Navigator.popAndPushNamed(context, Constants.PAGE_HOME);
    }
  }
}
