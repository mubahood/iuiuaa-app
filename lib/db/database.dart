import 'dart:io';

import 'package:iuiuaa/helper/constant.dart';
import 'package:iuiuaa/model/UserModel.dart';
import 'package:iuiuaa/model/chatModel.dart';
import 'package:iuiuaa/model/feedModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "iuiu_database.db";
  static final _databaseVersion = 10;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database

  Future<Database> get database async {
    if (db != null) return db;
    // lazily instantiate the db the first time it is accessed
    db = await initDatabase();

    return db;
  }

  // this opens the database (and creates it if it doesn't exist)
  initDatabase() async {
    print("INITING.. DB");

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    print("BEFORE CREATE");
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print("CREATING NEW DB ");
    await db.execute(UserModel.CERATE_USER_DATABSE());
    //await db.execute(ChatMessage.DROP_CHAT_DATABSE());
    await db.execute(ChatMessage.CREATE_CHAT_DATABSE());
    await db.execute(FeedModel.CREATE_CHAT_DATABSE());
    print("CREATING NEW DB done ");
  }

  Database db;

  Future<UserModel> get_logged_user() async {
    List<UserModel> users = await user_get(" fcmToken = 1 ");
    if (users == null) {
      return null;
    }
    if (users.isEmpty) {
      return null;
    }
    return users[0];
  }

  Future<void> update_databse() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    _onCreate(db, _databaseVersion);
    return;
  }

  Future<List<ChatMessage>> get_chats_list(String condition) async {
    if (db == null) {
      db = await initDatabase();
    }
    String _condition = " 1 ";
    if (condition != null) {
      _condition = condition;
    }

    String sql = "SELECT * FROM " +
        Constants.CHAT_TABLE +
        " WHERE " +
        _condition +
        " "
            " GROUP BY chat_thread_id ORDER BY key DESC ";

    List<Map> result = await db.rawQuery(sql);
    List<ChatMessage> users = [];

    result.forEach((row) {
      ChatMessage u = new ChatMessage();
      u = ChatMessage.fromJson(row);
      if (u == null) {
      } else {
        if (u.senderId != null) {
          users.add(u);
        }
      }
    });
    return users;
  }

  Future<List<ChatMessage>> get_chats(String condition) async {
    if (db == null) {
      db = await initDatabase();
    }
    String _condition = " 1 ";
    if (condition != null) {
      _condition = condition;
    }

    String sql =
        "SELECT * FROM " + Constants.CHAT_TABLE + " WHERE " + _condition;

    List<Map> result = await db.rawQuery(sql);
    List<ChatMessage> users = [];

    result.forEach((row) {
      ChatMessage u = new ChatMessage();
      u = ChatMessage.fromJson(row);
      if (u == null) {
      } else {
        if (u.senderId != null) {
          users.add(u);
        }
      }
    });
    return users;
  }

  Future<List<FeedModel>> get_posts(String condition) async {
    if (db == null) {
      db = await initDatabase();
    }
    String _condition = " 1 ";
    if (condition != null) {
      _condition = condition;
    }

    String sql =
        "SELECT * FROM " + Constants.POSTS_TABLE + " WHERE " + _condition;

    List<Map> result = await db.rawQuery(sql);
    List<FeedModel> posts = [];
    List<UserModel> users = await this.user_get("  1 ");

    result.forEach((row) {
      FeedModel u = new FeedModel();
      u = FeedModel.fromJson(row);
      if (u == null) {
      } else {
        if (u.post_id != null) {
          if (users != null && !users.isEmpty) {

            for(int i = 0; i<users.length; i++){
              if (users[i].user_id == u.post_by) {
                u.user = users[i];
                print("ROMINA FOUND ===> " + users[i].first_name);
                break;
              }
            }

            posts.add(u);
          } else {}
        }
      }
    });
    return posts;
  }

  Future<bool> save_post(FeedModel post) async {
    bool success = false;
    if (post == null) {
      return success;
    }

    if (post.post_id == null) {
      return success;
    }

    if (post.post_id.isEmpty) {
      return false;
    }

    List<FeedModel> posts =
        await get_posts(" post_id = '" + post.post_id + "'");

    bool is_update = false;

    if (posts != null) {
      if (!posts.isEmpty) {
        is_update = true;
      } else {
        is_update = false;
      }
    }

    if (db == null) {
      db = await instance.database;
    }

    if (is_update) {
      try {
        print("TIME TO UPDATE post ==> " + post.post_id);
        await db.update(Constants.POSTS_TABLE, post.toJson(),
            where: 'localId = ?', whereArgs: [post.post_id]);
        print("muhindo TASK ==> updated chat! success KEY: " + post.post_id);
        success = true;
      } catch (e) {
        success = false;
        print("muhindo FAILED updated  => " + e.toString());
      }
    } else {
      try {
        await db.insert(Constants.POSTS_TABLE, post.toJson());
        print("muhindo TASK ==> inserted success " + post.post_id);
        success = true;
      } catch (e) {
        success = false;
        print("muhindo FAILED INSERT insert => " + e.toString());
      }
    }

    return success;
  }

  Future<bool> save_message(ChatMessage message) async {
    bool success = false;
    if (message == null) {
      return success;
    }

    if (message.localId == null) {
      return success;
    }

    if (message.localId.isEmpty) {
      return false;
    }

    List<ChatMessage> chats =
        await get_chats(" localId = '" + message.localId + "'");

    bool is_update = false;

    if (chats != null) {
      if (!chats.isEmpty) {
        is_update = true;
      } else {
        is_update = false;
      }
    }

    if (db == null) {
      db = await instance.database;
    }

    if (is_update) {
      try {
        print("TIME TO UPDATE chat ==> " + message.localId);
        await db.update(Constants.CHAT_TABLE, message.toJson(),
            where: 'localId = ?', whereArgs: [message.localId]);
        print("muhindo TASK ==> updated chat! success KEY: " + message.key);
        success = true;
      } catch (e) {
        success = false;
        print("muhindo FAILED updated  => " + e.toString());
      }
    } else {
      try {
        await db.insert(Constants.CHAT_TABLE, message.toJson());
        print("muhindo TASK ==> inserted success " + message.localId);
        success = true;
      } catch (e) {
        success = false;
        print("muhindo FAILED INSERT insert => " + e.toString());
      }
    }

    return success;
  }

    Future<List<FeedModel>> posts_get(String condition) async {
    if (db == null) {
      db = await initDatabase();
    }
    String _condition = " 1 ORDER BY post_id DESC ";
    if (condition != null) {
      _condition = condition;
    }

    String sql =
        "SELECT * FROM " + Constants.POSTS_TABLE + " WHERE " + _condition;

    //String sql = "SELECT * FROM " + Constants.USERS_TABLE;

    List<Map> result = await db.rawQuery(sql);
    List<FeedModel> items = [];

    result.forEach((row) {
      FeedModel res = new FeedModel();
      res = FeedModel.fromJson(row);
      if (res == null) {
      } else {
        if (res.post_id != null) {
          items.add(res);
        }
      }
    });
    return items;
  }

  Future<List<UserModel>> user_get(String condition) async {
    if (db == null) {
      db = await initDatabase();
    }
    String _condition = " 1 ORDER BY first_name ASC ";
    if (condition != null) {
      _condition = condition;
    }

    String sql =
        "SELECT * FROM " + Constants.USERS_TABLE + " WHERE " + _condition;

    //String sql = "SELECT * FROM " + Constants.USERS_TABLE;

    List<Map> result = await db.rawQuery(sql);
    List<UserModel> users = [];

    result.forEach((row) {
      UserModel u = new UserModel();
      u = UserModel.fromJson(row);
      if (u == null) {
      } else {
        if (u.user_id != null) {
          users.add(u);
        }
      }
    });
    return users;
  }

  Future<bool> save_user(UserModel userModel) async {
    bool success = false;
    if (userModel == null) {
      return success;
    }

    if (userModel.user_id == null) {
      return success;
    }

    if (userModel.user_id.isEmpty) {
      return false;
    }

    List<UserModel> users =
        await user_get(" user_id = ${userModel.user_id}   ");

    bool is_update = false;
    bool is_logged_in = false;

    if (users != null) {
      if (!users.isEmpty) {
        is_update = true;
        if(users[0].fcmToken == "1"){
          is_logged_in = true;
        }else{
          is_logged_in = false;
        }
      } else {
        is_update = false;
      }
    }

    if (db == null) {
      db = await instance.database;
    } else {}

    if (is_update) {
      print("SUMAYYA TO UPDATE ==> " + userModel.user_id);
      try {


        if(!is_logged_in){
          await db.update(Constants.USERS_TABLE, userModel.toJson(),
              where: 'user_id = ?', whereArgs: [userModel.user_id]);
          print("muhindo TASK ==> updated success " +
              userModel.profile_photo_large);
          success = true;
        }else{
          print("SUMAYYA TO cannoott UPDATE  LOGGED USER  ==> " + userModel.user_id);
        }

      } catch (e) {
        success = false;
        print("muhindo FAILED updated  => " + e.toString());
      }
    } else {
      print("SUMAYYA TO INSERT =======> " + userModel.user_id.toString());
      try {
        await db.insert(Constants.USERS_TABLE, userModel.toJson());
        print("muhindo TASK ==> inserted success " + userModel.user_id);
        success = true;
      } catch (e) {
        success = false;
        print("muhindo FAILED INSERT insert => " + e.toString());
      }
    }

    return success;
  }
}
