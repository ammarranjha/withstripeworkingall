// To parse this JSON data, do
//
//     final sendEmailOtpResponseModel = sendEmailOtpResponseModelFromJson(jsonString);

import 'dart:convert';

SendEmailOtpResponseModel sendEmailOtpResponseModelFromJson(String str) =>
    SendEmailOtpResponseModel.fromJson(json.decode(str));

String sendEmailOtpResponseModelToJson(SendEmailOtpResponseModel data) =>
    json.encode(data.toJson());

class SendEmailOtpResponseModel {
  SendEmailOtpResponseModel({
    this.code,
    this.message,
    this.otp,
  });

  int code;
  String message;
  int otp;

  factory SendEmailOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendEmailOtpResponseModel(
        code: json["code"],
        message: json["message"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "otp": otp,
      };
}
