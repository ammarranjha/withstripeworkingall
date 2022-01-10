// To parse this JSON data, do
//
//     final siginResponseModel = siginResponseModelFromJson(jsonString);

import 'dart:convert';

SiginResponseModel siginResponseModelFromJson(String str) => SiginResponseModel.fromJson(json.decode(str));

String siginResponseModelToJson(SiginResponseModel data) => json.encode(data.toJson());

class SiginResponseModel {
    SiginResponseModel({
        this.accessToken,
        this.user,
    });

    String accessToken;
    User user;

    factory SiginResponseModel.fromJson(Map<String, dynamic> json) => SiginResponseModel(
        accessToken: json["accessToken"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user.toJson(),
    };
}

class User {
    User({
        this.offeredride,
        this.bookedride,
        this.pastofferedride,
        this.pastbookedride,
        this.id,
        this.firstname,
        this.lastname,
        this.phonenumber,
        this.email,
        this.confirmpassword,
        this.createdat,
        this.v,
    });

    List<dynamic> offeredride;
    List<dynamic> bookedride;
    List<dynamic> pastofferedride;
    List<dynamic> pastbookedride;
    String id;
    String firstname;
    String lastname;
    String phonenumber;
    String email;
    String confirmpassword;
    DateTime createdat;
    int v;

    factory User.fromJson(Map<String, dynamic> json) => User(
        offeredride: List<dynamic>.from(json["offeredride"].map((x) => x)),
        bookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
        pastofferedride: List<dynamic>.from(json["pastofferedride"].map((x) => x)),
        pastbookedride: List<dynamic>.from(json["pastbookedride"].map((x) => x)),
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phonenumber: json["phonenumber"],
        email: json["email"],
        confirmpassword: json["confirmpassword"],
        createdat: DateTime.parse(json["createdat"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "offeredride": List<dynamic>.from(offeredride.map((x) => x)),
        "bookedride": List<dynamic>.from(bookedride.map((x) => x)),
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": phonenumber,
        "email": email,
        "confirmpassword": confirmpassword,
        "createdat": createdat.toIso8601String(),
        "__v": v,
    };
}
