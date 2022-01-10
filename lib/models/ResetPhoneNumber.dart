// To parse this JSON data, do
//
//     final resetPhoneNumber = resetPhoneNumberFromJson(jsonString);

import 'dart:convert';

ResetPhoneNumber resetPhoneNumberFromJson(String str) =>
    ResetPhoneNumber.fromJson(json.decode(str));

String resetPhoneNumberToJson(ResetPhoneNumber data) =>
    json.encode(data.toJson());

class ResetPhoneNumber {
  ResetPhoneNumber({
    this.code,
    this.message,
    this.updateUser,
  });

  int code;
  String message;
  UpdateUser updateUser;

  factory ResetPhoneNumber.fromJson(Map<String, dynamic> json) =>
      ResetPhoneNumber(
        code: json["code"],
        message: json["message"],
        updateUser: UpdateUser.fromJson(json["updateUser"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "updateUser": updateUser.toJson(),
      };
}

class UpdateUser {
  UpdateUser({
    this.emailverified,
    this.offeredride,
    this.bookedride,
    this.pastofferedride,
    this.pastbookedride,
    this.inboxconversations,
    this.userRate,
    this.allratings,
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
  int userRate;
  List<dynamic> allratings;
  String id;
  String firstname;
  String lastname;
  String phonenumber;
  String email;
  String profileImageUrl;
  String password;
  String confirmpassword;
  DateTime createdat;
  List<dynamic> notifications;
  int v;

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
        emailverified: json["emailverified"],
        offeredride: List<String>.from(json["offeredride"].map((x) => x)),
        bookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
        pastofferedride:
            List<dynamic>.from(json["pastofferedride"].map((x) => x)),
        pastbookedride:
            List<dynamic>.from(json["pastbookedride"].map((x) => x)),
        inboxconversations:
            List<String>.from(json["inboxconversations"].map((x) => x)),
        userRate: json["userRate"],
        allratings: List<dynamic>.from(json["allratings"].map((x) => x)),
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
        "userRate": userRate,
        "allratings": List<dynamic>.from(allratings.map((x) => x)),
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
