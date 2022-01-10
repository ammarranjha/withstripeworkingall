// To parse this JSON data, do
//
//     final sendMessageInConversationResponseModel = sendMessageInConversationResponseModelFromJson(jsonString);

import 'dart:convert';

SendMessageInConversationResponseModel
    sendMessageInConversationResponseModelFromJson(String str) =>
        SendMessageInConversationResponseModel.fromJson(json.decode(str));

String sendMessageInConversationResponseModelToJson(
        SendMessageInConversationResponseModel data) =>
    json.encode(data.toJson());

class SendMessageInConversationResponseModel {
  SendMessageInConversationResponseModel({
    this.code,
    this.conversation,
  });

  int code;
  Conversation conversation;

  factory SendMessageInConversationResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SendMessageInConversationResponseModel(
        code: json["code"],
        conversation: Conversation.fromJson(json["conversation"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
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
