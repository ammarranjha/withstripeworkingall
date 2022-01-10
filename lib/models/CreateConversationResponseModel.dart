// To parse this JSON data, do
//
//     final createConversationResponseModel = createConversationResponseModelFromJson(jsonString);

import 'dart:convert';

CreateConversationResponseModel createConversationResponseModelFromJson(
        String str) =>
    CreateConversationResponseModel.fromJson(json.decode(str));

String createConversationResponseModelToJson(
        CreateConversationResponseModel data) =>
    json.encode(data.toJson());

class CreateConversationResponseModel {
  CreateConversationResponseModel({
    this.code,
    this.message,
    this.conversation,
  });

  int code;
  String message;
  Conversation conversation;

  factory CreateConversationResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateConversationResponseModel(
        code: json["code"],
        message: json["message"],
        conversation: Conversation.fromJson(json["conversation"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "conversation": conversation.toJson(),
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
  String firstUserId;
  String secondUserId;
  List<Message> message;
  int v;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["_id"],
        firstUserId: json["firstUserId"],
        secondUserId: json["secondUserId"],
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstUserId": firstUserId,
        "secondUserId": secondUserId,
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
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
