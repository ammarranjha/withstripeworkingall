// To parse this JSON data, do
//
//     final getUserResponseModel = getUserResponseModelFromJson(jsonString);

import 'dart:convert';

GetUserResponseModel getUserResponseModelFromJson(String str) => GetUserResponseModel.fromJson(json.decode(str));

String getUserResponseModelToJson(GetUserResponseModel data) => json.encode(data.toJson());

class GetUserResponseModel {
    GetUserResponseModel({
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
    String password;
    String confirmpassword;
    DateTime createdat;
    int v;

    factory GetUserResponseModel.fromJson(Map<String, dynamic> json) => GetUserResponseModel(
        offeredride: List<dynamic>.from(json["offeredride"].map((x) => x)),
        bookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
        pastofferedride: List<dynamic>.from(json["pastofferedride"].map((x) => x)),
        pastbookedride: List<dynamic>.from(json["pastbookedride"].map((x) => x)),
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phonenumber: json["phonenumber"],
        email: json["email"],
        password: json["password"],
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
        "password": password,
        "confirmpassword": confirmpassword,
        "createdat": createdat.toIso8601String(),
        "__v": v,
    };
}
