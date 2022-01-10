// To parse this JSON data, do
//
//     final updateUserResponseModel = updateUserResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateUserResponseModel updateUserResponseModelFromJson(String str) => UpdateUserResponseModel.fromJson(json.decode(str));

String updateUserResponseModelToJson(UpdateUserResponseModel data) => json.encode(data.toJson());

class UpdateUserResponseModel {
    UpdateUserResponseModel({
        this.code,
        this.message,
        this.updateUser,
    });

    int code;
    String message;
    UpdateUser updateUser;

    factory UpdateUserResponseModel.fromJson(Map<String, dynamic> json) => UpdateUserResponseModel(
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

    factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
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
