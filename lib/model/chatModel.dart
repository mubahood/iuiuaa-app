import 'package:iuiuaa/helper/constant.dart';

class ChatMessage {
  String key;
  String localId;
  String senderId;
  String message;
  String seen;
  String sent;
  String createdAt;
  String timeStamp;
  String senderName;
  String receiverId;
  String chat_thread_id;


  ChatMessage(
      {this.key,
      this.senderId,
      this.localId,
      this.message,
      this.seen,
      this.sent,
      this.createdAt,
      this.receiverId,
      this.chat_thread_id,
      this.senderName,
      this.timeStamp});



  static String DROP_CHAT_DATABSE() {
    return 'DROP TABLE  ' +
        Constants.CHAT_TABLE ;
  }

  static String CREATE_CHAT_DATABSE() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        Constants.CHAT_TABLE +
        '('
            ' localId VARCHAR(100) PRIMARY KEY ,'
            ' key VARCHAR(100) ,'
            ' senderId VARCHAR(100),'
            ' message TEXT,'
            ' seen VARCHAR(10),'
            ' sent VARCHAR(10),'
            ' createdAt VARCHAR(50),'
            ' timeStamp VARCHAR(50),'
            ' senderName VARCHAR(100),'
            ' chat_thread_id VARCHAR(100),'
            ' receiverId VARCHAR(50)'
            ')';
  }

  factory ChatMessage.fromJson(Map<dynamic, dynamic> json) => ChatMessage(
      key: json["key"],
      senderId: json["senderId"],
      localId: json["localId"],
      message: json["message"],
      seen: json["seen"],
      sent: json["sent"],
      chat_thread_id: json["chat_thread_id"],
      createdAt: json["created_at"],
      timeStamp: json['timeStamp'],
      senderName: json["senderName"],
      receiverId: json["receiverId"]);

  Map<String, dynamic> toJson() => {
        "key": key,
        "senderId": senderId,
        "message": message,
        "localId": localId,
        "sent": sent,
        "receiverId": receiverId,
        "seen": seen,
        "chat_thread_id": chat_thread_id,
        "createdAt": createdAt,
        "senderName": senderName,
        "timeStamp": timeStamp
      };
}
