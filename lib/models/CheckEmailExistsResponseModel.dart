// To parse this JSON data, do
//
//     final checkEmailExistsResponseModel = checkEmailExistsResponseModelFromJson(jsonString);

import 'dart:convert';

CheckEmailExistsResponseModel checkEmailExistsResponseModelFromJson(String str) => CheckEmailExistsResponseModel.fromJson(json.decode(str));

String checkEmailExistsResponseModelToJson(CheckEmailExistsResponseModel data) => json.encode(data.toJson());

class CheckEmailExistsResponseModel {
    CheckEmailExistsResponseModel({
        this.message,
    });

    String message;

    factory CheckEmailExistsResponseModel.fromJson(Map<String, dynamic> json) => CheckEmailExistsResponseModel(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
