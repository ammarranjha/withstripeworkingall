// To parse this JSON data, do
//
//     final addRideResponseModel = addRideResponseModelFromJson(jsonString);

import 'dart:convert';

AddRideResponseModel addRideResponseModelFromJson(String str) =>
    AddRideResponseModel.fromJson(json.decode(str));

String addRideResponseModelToJson(AddRideResponseModel data) =>
    json.encode(data.toJson());

class AddRideResponseModel {
  AddRideResponseModel({
    this.code,
    this.message,
    this.updateUser,
  });

  int code;
  String message;
  UpdateUser updateUser;

  factory AddRideResponseModel.fromJson(Map<String, dynamic> json) =>
      AddRideResponseModel(
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
    this.id,
    this.firstname,
    this.lastname,
    this.phonenumber,
    this.email,
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
  String id;
  String firstname;
  String lastname;
  String phonenumber;
  String email;
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
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phonenumber: json["phonenumber"],
        email: json["email"],
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
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": phonenumber,
        "email": email,
        "password": password,
        "confirmpassword": confirmpassword,
        "createdat": createdat.toIso8601String(),
        "notifications": List<dynamic>.from(notifications.map((x) => x)),
        "__v": v,
      };
}
