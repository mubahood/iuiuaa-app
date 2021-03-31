import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iuiuaa/db/database.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/chatModel.dart';
import 'package:iuiuaa/ui/theme/theme.dart';
import 'package:iuiuaa/widgets/customWidgets.dart';
import 'package:iuiuaa/widgets/newWidget/customLoader.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

final kScreenloader = CustomLoader();

void cprint(dynamic data, {String errorIn, String event}) {
  /// Print logs only in development mode
  if (kDebugMode) {
    if (errorIn != null) {
      print(
          '****************************** error ******************************');
      developer.log('[Error]',
          time: DateTime.now(), error: data, name: errorIn);
      print(
          '****************************** error ******************************');
    } else if (data != null) {
      developer.log(
        data,
        time: DateTime.now(),
      );
    }
    if (event != null) {
      Utility.logEvent(event);
    }
  }
}

class Utility {
  static Future<Uri> createLinkToShare() async {
    final _authority = "ugnews24.info";
    final _path = "/app";
    final _uri = Uri.https(_authority, _path);
    return _uri;
  }

  static final List<String> campuses = <String>[
    'Arua campus',
    "Female's campus - Kabojja",
    'Kampala campus',
    'Mbale campus'
  ];

  static String getPostTime2(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat =
        DateFormat.jm().format(dt) + ' - ' + DateFormat("dd MMM yy").format(dt);
    return dat;
  }

  static void logEvent(String event, {Map<String, dynamic> parameter}) {
    print("[EVENT]: $event");
  }

  static String getdob(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    var dt = DateTime.parse(date).toLocal();
    var dat = DateFormat.yMMMd().format(dt);
    return dat;
  }

  static my_toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.primary,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static my_toast_short(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.primary,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static String getJoiningDate(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    var dt = DateTime.fromMillisecondsSinceEpoch((int.parse(date)) * 1000);

    var dat = DateFormat("MMMM yyyy").format(dt);
    return 'Joined $dat';
  }

  static String getChatTime(String _date) {

    if (_date == null || _date.isEmpty) {
      return '';
    }



    int timestamp = int.parse(_date);
    var dt = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);


    String msg = '';


/*    if (DateTime.now().toLocal().isBefore(dt)) {
      return "nOW";
    }*/

    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 0) {
      msg = '${dur.inDays}d ago';
      return dur.inDays == 1 ? '1d' : DateFormat("dd MMM").format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours}h ago';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes}m ago';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds}s ago';
    } else {
      msg = 'now';
    }
    return msg;
  }

  static Future<List<ChatMessage>> get_web_chats(Map params) async {
    List<ChatMessage> messages = [];
    final _authority = Constants.BASE_URL;
    final _path = Constants.BASE_PATH + "chats_user";
    final _uri = Uri.https(_authority, _path, params);
    try {
      final response = await http.get(_uri).timeout(Constants.timeLimit);
      if (response.statusCode != 200) {
        print("ROMINA: FAILED RESP ==> " +
            _uri.path +
            " == " +
            response.statusCode.toString());
        return [];
      }
      Iterable l = json.decode(response.body);
      messages =
          List<ChatMessage>.from(l.map((model) => ChatMessage.fromJson(model)));
      if (messages == null) {
        return [];
      } else {
        DatabaseHelper dbHelper = DatabaseHelper.instance;
        if (dbHelper != null) {
          messages.forEach((element) {
            if (element != null && element.key !=null) {
              try {
                dbHelper.save_message(element);
              } catch (e) {}
            }
          });
        }
      }

      return messages;
    } catch (E) {
      print("ROMINA: failed Because " + E);
      return [];
    }
  }

  static Future<List<UserModel>> get_web_user(Map params) async {
    final _authority = Constants.BASE_URL;
    final _path = Constants.BASE_PATH + "users";
    final _uri = Uri.https(_authority, _path, params);
    try {
      final response = await http.get(_uri).timeout(Constants.timeLimit);
      if (response.statusCode != 200) {
        print("ROMINA: FAILED RESP ==> " +
            _uri.path +
            " == " +
            response.statusCode.toString());
        return [];
      }
      Iterable l = json.decode(response.body);
      List<UserModel> users =
          List<UserModel>.from(l.map((model) => UserModel.fromJson(model)));
      if (users == null) {
        return [];
      } else {
        DatabaseHelper dbHelper = DatabaseHelper.instance;
        if (dbHelper != null) {
          users.forEach((element) {
            if (element != null) {
              try {
                dbHelper.save_user(element);
              } catch (e) {}
            }
          });
        }
      }

      return users;
    } catch (E) {
      print("ROMINA: failed Because " + E);
      return [];
    }
  }

  static String getPollTime(String date) {
    int hr, mm;
    String msg = 'Poll ended';
    var enddate = DateTime.parse(date);
    if (DateTime.now().isAfter(enddate)) {
      return msg;
    }
    msg = 'Poll ended in';
    var dur = enddate.difference(DateTime.now());
    hr = dur.inHours - dur.inDays * 24;
    mm = dur.inMinutes - (dur.inHours * 60);
    if (dur.inDays > 0) {
      msg = ' ' + dur.inDays.toString() + (dur.inDays > 1 ? ' Days ' : ' Day');
    }
    if (hr > 0) {
      msg += ' ' + hr.toString() + ' hour';
    }
    if (mm > 0) {
      msg += ' ' + mm.toString() + ' min';
    }
    return (dur.inDays).toString() +
        ' Days ' +
        ' ' +
        hr.toString() +
        ' Hours ' +
        mm.toString() +
        ' min';
  }

  static String getSocialLinks(String url) {
    if (url != null && url.isNotEmpty) {
      url = url.contains("https://www") || url.contains("http://www")
          ? url
          : url.contains("www") &&
                  (!url.contains('https') && !url.contains('http'))
              ? 'https://' + url
              : 'https://www.' + url;
    } else {
      return null;
    }
    cprint('Launching URL : $url');
    return url;
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      cprint('Could not launch $url');
    }
  }

  static void debugLog(String log, {dynamic param = ""}) {
    final String time = DateFormat("mm:ss:mmm").format(DateTime.now());
    print("[$time][Log]: $log, $param");
  }

  static void share(String message, {String subject}) {
    Share.share(message, subject: subject);
  }

  static List<String> getHashTags(String text) {
    RegExp reg = RegExp(
        r"([#])\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> _matches = reg.allMatches(text);
    List<String> resultMatches = List<String>();
    for (Match match in _matches) {
      if (match.group(0).isNotEmpty) {
        var tag = match.group(0);
        resultMatches.add(tag);
      }
    }
    return resultMatches;
  }

  static String getusername({
    String id,
    String name,
  }) {
    String username = '';
    if (name.length > 15) {
      name = name.substring(0, 6);
    }
    name = name.split(' ')[0];
    id = id.substring(0, 4).toLowerCase();
    username = '@$name$id';
    return username;
  }

  static bool validateCredentials(
      GlobalKey<ScaffoldState> _scaffoldKey, String email, String password) {
    if (email == null || email.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please enter email id');
      return false;
    } else if (password == null || password.isEmpty) {
      customSnackBar(_scaffoldKey, 'Please enter password');
      return false;
    } else if (password.length < 8) {
      customSnackBar(_scaffoldKey, 'Password must me 8 character long');
      return false;
    }

    var status = validateEmal(email);
    if (!status) {
      customSnackBar(_scaffoldKey, 'Please enter valid email id');
      return false;
    }
    return true;
  }

  static bool validateEmal(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    var status = regExp.hasMatch(email);
    return status;
  }

  static shareFile(List<String> path, {String text = ""}) {
    try {
      //Share.shareFiles(path, text: text);
    } catch (error) {
      print(error);
    }
  }

  static void copyToClipBoard({
    GlobalKey<ScaffoldState> scaffoldKey,
    String text,
    String message,
  }) {
    assert(message != null);
    assert(text != null);
    var data = ClipboardData(text: text);
    Clipboard.setData(data);
    customSnackBar(scaffoldKey, message);
  }

  static List<UserModel> user_search(String _keyword, List<UserModel> _users) {
    if (_keyword == null || _keyword.isEmpty) {
      return _users;
    }
    List<UserModel> _users_temp = [];
    _users_temp.clear();
    _users.forEach((element) {
      if (element.first_name.toLowerCase().contains(_keyword) ||
          element.last_name.toLowerCase().contains(_keyword) ||
          element.email.toLowerCase().contains(_keyword) ||
          element.campus.toLowerCase().contains(_keyword) ||
          element.phone_number.toLowerCase().contains(_keyword)) {
        _users_temp.add(element);
      }
    });

    return _users_temp;
  }
}
