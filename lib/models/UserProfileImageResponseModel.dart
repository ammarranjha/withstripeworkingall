// To parse this JSON data, do
//
//     final userProfileImageResponseModel = userProfileImageResponseModelFromJson(jsonString);

import 'dart:convert';

UserProfileImageResponseModel userProfileImageResponseModelFromJson(String str) => UserProfileImageResponseModel.fromJson(json.decode(str));

String userProfileImageResponseModelToJson(UserProfileImageResponseModel data) => json.encode(data.toJson());

class UserProfileImageResponseModel {
    UserProfileImageResponseModel({
        this.code,
        this.message,
        this.updateUser,
    });

    int code;
    String message;
    UpdateUser updateUser;

    factory UserProfileImageResponseModel.fromJson(Map<String, dynamic> json) => UserProfileImageResponseModel(
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
        this.v,
        this.profileImageUrl,
    });

    bool emailverified;
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
    String profileImageUrl;

    factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
        emailverified: json["emailverified"],
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
        profileImageUrl: json["profile_image_url"],
    );

    Map<String, dynamic> toJson() => {
        "emailverified": emailverified,
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
        "profile_image_url": profileImageUrl,
    };
}
