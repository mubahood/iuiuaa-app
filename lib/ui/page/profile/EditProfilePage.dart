import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:http/http.dart' as http;
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/helper/utility.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/programItem.dart';
import 'package:iuiuaa/model/responseModel.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/addProgramItemWidget.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/customLoader.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool is_loading = false;

  void hide_loader() {
    if (!is_loading) {
      return;
    }
    loader.hideLoader();
    is_loading = false;
  }

  void show_loader() {
    if (is_loading) {
      return;
    }
    loader.showLoader(context);
    is_loading = true;
  }

  UserModel userModel = new UserModel();
  final dbHelper = DatabaseHelper.instance;
  CustomLoader loader;

  File _image;
  File _banner;
  List<ProgramItem> programs = [];
  String _programs = "";

  //NewProgramItem
  TextEditingController first_name, last_name, _nationality;
  TextEditingController _program_item_award,_occupation,_gender,_facebook,_twitter,_linkedin,_phone_number,_whatsapp;
  TextEditingController _bio;
  TextEditingController _location;
  TextEditingController _dob;
  TextEditingController _programs_controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String dob;
  ProgramItem NewProgramItem = new ProgramItem();

  Future<void> check_login() async {
    userModel = await dbHelper.get_logged_user();


    //dbHelper.save_user(userModel);
    if (userModel == null) {
      Utility.my_toast_short("Account not found.");
      Navigator.pop(context);
      return;
    }

    first_name.text = userModel.first_name.toString();
    last_name.text = userModel.last_name.toString();
    _nationality.text = userModel.nationality.toString();
    _location.text = userModel.address.toString();
    _bio.text = userModel.about.toString();
    _dob.text = userModel.dob.toString();
    _occupation.text = userModel.occupation.toString();
    _gender.text = userModel.gender.toString();
    _phone_number.text = userModel.phone_number.toString();
    _whatsapp.text = userModel.whatsapp.toString();
    _linkedin.text = userModel.linkedin.toString();
    _twitter.text = userModel.twitter.toString();
    _facebook.text = userModel.facebook.toString();

    _program_item_award.text = NewProgramItem.award;
    _programs = "";
    programs.forEach((element) {
      _programs += element.award +
          " in " +
          element.title +
          " at " +
          element.campus +
          " campus - " +
          element.year +
          ",\n";
    });
    _programs_controller.text = _programs;


    if (userModel.programs != null) {
      List<ProgramItem> pros = ProgramItem.fromJsonList(userModel.programs);
      if (pros != null) {
        setState(() {
          programs.clear();
          programs = pros;
        });
      }
    }

    setState(() {

    });
  }

  @override
  void initState() {
    check_login();

    loader = CustomLoader();
    first_name = TextEditingController();
    _occupation = TextEditingController();
    _phone_number = TextEditingController();
    _facebook = TextEditingController();
    _program_item_award = TextEditingController();
    last_name = TextEditingController();
    _gender = TextEditingController();
    _linkedin = TextEditingController();
    _bio = TextEditingController();
    _nationality = TextEditingController();
    _location = TextEditingController();
    _twitter = TextEditingController();
    _programs_controller = TextEditingController();
    _dob = TextEditingController();
    _whatsapp = TextEditingController();

    super.initState();
  }

  void dispose() {
    first_name.dispose();
    last_name.dispose();
    _bio.dispose();
    _location.dispose();
    _dob.dispose();
    _gender.dispose();
    _twitter.dispose();
    _occupation.dispose();
    _phone_number.dispose();
    _facebook.dispose();
    super.dispose();
  }

  Widget _body() {
    cprint(userModel.profile_photo_large);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 180,
          child: Stack(
            children: <Widget>[
              _bannerImage(),
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(),
              ),
            ],
          ),
        ),
        _entry('First Name', controller: first_name),
        _entry('Last Name', controller: last_name),
        InkWell(
          onTap: showGenderPicker,
          child:
          _entry('Gender', isenable: false, controller: _gender),
        ),
        InkWell(
          onTap: showCountryPicker,
          child:
              _entry('Nationality', isenable: false, controller: _nationality),
        ),
        _entry('Current Address', controller: _location),
        _entry('Occupation', controller: _occupation, maxLine: 1),
        _entry('About you', controller: _bio, maxLine: null),
        InkWell(
          onTap: showCalender,
          child: _entry('Date of birth', isenable: false, controller: _dob),
        ),
        SizedBox(height: 10),
        InkWell(
            onTap: () {
              show_add_program_modal(context);
            },
            child: _entry('Program(s) you accomplished at IUIU',
                isenable: false, maxLine: null, controller: _programs_controller)),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            children: <Widget>[
              _programs.isEmpty == false
                  ? Expanded(
                      child: FlatButton(
                        color: Colors.red,
                        child: Text(
                          'Clear Programs',
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor),
                        ),
                        onPressed: () {
                          setState(() {
                            programs.clear();
                          });
                        },
                      ),
                    )
                  : SizedBox(
                      width: 0,
                    )
            ],
          ),
        ),

        _entry('Phone number', controller: _phone_number),
        _entry('Whatsapp number', controller: _whatsapp),
        _entry('Linkedin username', controller: _linkedin),
        _entry('Twitter username', controller: _twitter),
        _entry('Facebook username', controller: _facebook),

        SizedBox(height: 50),
        InkWell(
          onTap: _submitButton,
          child: Center(
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 50),
      ],
    );
  }

  Widget _userImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(userModel.profile_photo),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _image != null
            ? FileImage(_image)
            : customAdvanceNetworkImage(userModel.profile_photo),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        image: userModel.profile_photo_large == null
            ? null
            : DecorationImage(
                image: customAdvanceNetworkImage(userModel.profile_photo_large),
                fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
        ),
        child: Stack(
          children: [
            _banner != null
                ? Image.file(_banner,
                    fit: BoxFit.cover, width: MediaQuery.of(context).size.width)
                : customNetworkImage(userModel.profile_photo_large,
                    fit: BoxFit.cover),
            Center(
              child: IconButton(
                onPressed: uploadBanner,
                icon: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entry(String title,
      {TextEditingController controller,
      int maxLine = 1,
      bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void showCountryPicker() async {
    showMaterialRadioPicker(
      title: "What's your country?",
      context: context,
      items: Constants.countries,
      selectedItem: userModel.nationality,
      onChanged: (value) {
        setState(() {
          _nationality.text = value;
          userModel.nationality = value;
        });
      },
    );
  }
  void showGenderPicker() async {
    showMaterialRadioPicker(
      context: context,
      title: "What's your gender?",
      items: Constants.genders,
      selectedItem: userModel.gender,
      onChanged: (value) {
        setState(() {
          _gender.text = value;
          userModel.gender = value;
        });
      },
    );
  }

  void showCalender() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, DateTime.now().day),
      firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().subtract(Duration(days: (335 * 18))),
    );
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob.text = Utility.getdob(dob);
        userModel.dob = Utility.getdob(dob);
      }
    });
  }

  Future<void> uploadFile(String url, File file) async {

    final _path = "/wp/wp-json/muhindo/v1/user_update";
    final _uri = Uri.https(Constants.BASE_URL, _path);
    http.MultipartRequest request = new http.MultipartRequest("POST", _uri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('profile_photo', file.path);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    //////////
  }

  Future<void> _submitButton() async {
    if (is_loading) {
      Utility.my_toast_short("Please be patient.");
      return;
    }

    final _path = "/wp/wp-json/muhindo/v1/user_update";
    final _uri = Uri.https(Constants.BASE_URL, _path);
    http.MultipartRequest request = new http.MultipartRequest("POST", _uri);

    if (_banner != null) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'profile_photo_large', _banner.path);
      request.files.add(multipartFile);
    }

    if (_image != null) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('profile_photo', _image.path);
      request.files.add(multipartFile);
    }

    userModel.first_name = first_name.text;
    if (first_name.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
      return;
    }

    if (userModel.first_name.isEmpty) {
      customSnackBar(_scaffoldKey, 'First name can\'t be empty.');
      return;
    }
    request.fields.addAll({'first_name': userModel.first_name});

    userModel.last_name = last_name.text;
    if (userModel.last_name.isEmpty) {
      customSnackBar(_scaffoldKey, 'Last name can\'t be empty.');
      return;
    }
    request.fields.addAll({'last_name': userModel.last_name});

    userModel.nationality = _nationality.text;
    if (userModel.nationality.isEmpty) {
      customSnackBar(_scaffoldKey, 'You must select your nationality.');
      return;
    }
    request.fields.addAll({'nationality': userModel.nationality});

    userModel.dob = _dob.text;
    request.fields.addAll({'dob': userModel.dob});

    userModel.about = _bio.text;
    if (userModel.about.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please write some short lines about you.');
      return;
    }
    userModel.user_id = "1";
    request.fields.addAll({'address': _location.text});
    request.fields.addAll({'about': userModel.about});
    request.fields.addAll({'user_id': userModel.user_id});
    if (programs.isEmpty) {
      if (userModel.programs == null) {

      } else {}
      customSnackBar(_scaffoldKey, 'You must add at least one program.');
      return;
    }



    request.fields.addAll({'programs': jsonEncode(programs)});
    request.fields.addAll({'campus': programs[0].campus.toString()});
    request.fields.addAll({'gender': _gender.text.toString()});
    request.fields.addAll({'occupation': _occupation.text.toString()});
    request.fields.addAll({'phone_number': _phone_number.text.toString()});
    request.fields.addAll({'whatsapp': _whatsapp.text.toString()});
    request.fields.addAll({'linkedin': _linkedin.text.toString()});
    request.fields.addAll({'facebook': _facebook.text.toString()});

    show_loader();
    http.StreamedResponse response =
        await request.send().timeout(Duration(seconds: 30));

    if (response.statusCode != 200) {
      hide_loader();
      print(response.statusCode);
      customSnackBar(_scaffoldKey,
          'Failed to connect server. error ' + response.statusCode.toString());
      return;
    }

    Uint8List s = await response.stream.toBytes();
    var rawJson = Utf8Decoder().convert(s);

    String d =
        '{"code":1,"message":"Update profile successfully.","data":"as"}';

    Map<String, dynamic> map = jsonDecode(rawJson);
    ResponseModel data = ResponseModel.fromJson(map);

    if (data == null) {
      hide_loader();
      customSnackBar(_scaffoldKey, 'Totally failed to decode data.');
      return;
    }

    if (data.code == null) {
      hide_loader();
      customSnackBar(_scaffoldKey, 'Failed to decode data.');
      return;
    }

    if (data.code != 1) {
      hide_loader();
      customSnackBar(_scaffoldKey, data.data);
      return;
    }

    Map<String, dynamic> user_map = jsonDecode(data.data);
    userModel = UserModel.fromJson(user_map);

    if (userModel == null) {
      hide_loader();
      customSnackBar(_scaffoldKey, "Failed to parse user object.");
      return;
    }
    userModel.fcmToken = "1";
    bool login_user = await dbHelper.save_user(userModel);

    if (!login_user) {
      hide_loader();
      customSnackBar(_scaffoldKey, "Filed to save local data.");
      return;
    }

    hide_loader();
    Utility.my_toast("Profile updated successfully.");
    Navigator.pop(context);
  }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
    });
  }

  void uploadBanner() {
    openImagePicker(context, (file) {
      if (file == null) {
        return;
      }

      setState(() {
        _banner = file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColor.primary),
        title: customTitleText('Profile Edit'),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }

  void show_add_program_modal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return addProgramItemWidget(add_new_program_item);
        });
  }

  void add_new_program_item(ProgramItem programItem) {
    //Utility.my_toast_short("You must select award");
    setState(() {
      programs.add(programItem);
    });
    Navigator.pop(context);
  }
}
