// To parse this JSON data, do
//
//     final inboxChatsResponseModel = inboxChatsResponseModelFromJson(jsonString);

import 'dart:convert';

InboxChatsResponseModel inboxChatsResponseModelFromJson(String str) =>
    InboxChatsResponseModel.fromJson(json.decode(str));

String inboxChatsResponseModelToJson(InboxChatsResponseModel data) =>
    json.encode(data.toJson());

class InboxChatsResponseModel {
  InboxChatsResponseModel({
    this.code,
    this.message,
    this.conversations,
  });

  int code;
  String message;
  List<Conversation> conversations;

  factory InboxChatsResponseModel.fromJson(Map<String, dynamic> json) =>
      InboxChatsResponseModel(
        code: json["code"],
        message: json["message"],
        conversations: List<Conversation>.from(
            json["conversations"].map((x) => Conversation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "conversations":
            List<dynamic>.from(conversations.map((x) => x.toJson())),
      };
}

class Conversation {
  Conversation({
    this.id,
    this.firstUserId,
    this.secondUserId,
    this.message,
    this.v,
  });

  String id;
  UserId firstUserId;
  UserId secondUserId;
  List<Message> message;
  int v;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["_id"],
        firstUserId: UserId.fromJson(json["firstUserId"]),
        secondUserId: UserId.fromJson(json["secondUserId"]),
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstUserId": firstUserId.toJson(),
        "secondUserId": secondUserId.toJson(),
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
        "__v": v,
      };
}

class UserId {
  UserId({
    this.emailverified,
    this.offeredride,
    this.bookedride,
    this.pastofferedride,
    this.pastbookedride,
    this.inboxconversations,
    this.id,
    this.firstname,
    this.lastname,
    this.phonenumber,
    this.email,
    this.profileImageUrl,
    this.password,
    this.confirmpassword,
    this.createdat,
    this.notifications,
    this.v,
  });

  bool emailverified;
  List<String> offeredride;
  List<dynamic> bookedride;
  List<dynamic> pastofferedride;
  List<dynamic> pastbookedride;
  List<String> inboxconversations;
  String id;
  String firstname;
  String lastname;
  String phonenumber;
  String email;
  dynamic profileImageUrl;
  String password;
  String confirmpassword;
  DateTime createdat;
  List<dynamic> notifications;
  int v;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        emailverified: json["emailverified"],
        offeredride: List<String>.from(json["offeredride"].map((x) => x)),
        bookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
        pastofferedride:
            List<dynamic>.from(json["pastofferedride"].map((x) => x)),
        pastbookedride:
            List<dynamic>.from(json["pastbookedride"].map((x) => x)),
        inboxconversations:
            List<String>.from(json["inboxconversations"].map((x) => x)),
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phonenumber: json["phonenumber"],
        email: json["email"],
        profileImageUrl: json["profile_image_url"],
        password: json["password"],
        confirmpassword: json["confirmpassword"],
        createdat: DateTime.parse(json["createdat"]),
        notifications: List<dynamic>.from(json["notifications"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "emailverified": emailverified,
        "offeredride": List<dynamic>.from(offeredride.map((x) => x)),
        "bookedride": List<dynamic>.from(bookedride.map((x) => x)),
        "pastofferedride": List<dynamic>.from(pastofferedride.map((x) => x)),
        "pastbookedride": List<dynamic>.from(pastbookedride.map((x) => x)),
        "inboxconversations":
            List<dynamic>.from(inboxconversations.map((x) => x)),
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": phonenumber,
        "email": email,
        "profile_image_url": profileImageUrl,
        "password": password,
        "confirmpassword": confirmpassword,
        "createdat": createdat.toIso8601String(),
        "notifications": List<dynamic>.from(notifications.map((x) => x)),
        "__v": v,
      };
}

class Message {
  Message({
    this.id,
    this.senderId,
    this.text,
    this.timestamp,
  });

  String id;
  String senderId;
  String text;
  int timestamp;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        senderId: json["senderId"],
        text: json["text"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "senderId": senderId,
        "text": text,
        "timestamp": timestamp,
      };
}
