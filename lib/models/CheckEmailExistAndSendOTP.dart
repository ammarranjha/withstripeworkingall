// To parse this JSON data, do
//
//     final checkEmailExistAndSendOtp = checkEmailExistAndSendOtpFromJson(jsonString);

import 'dart:convert';

CheckEmailExistAndSendOtp checkEmailExistAndSendOtpFromJson(String str) => CheckEmailExistAndSendOtp.fromJson(json.decode(str));

String checkEmailExistAndSendOtpToJson(CheckEmailExistAndSendOtp data) => json.encode(data.toJson());

class CheckEmailExistAndSendOtp {
    CheckEmailExistAndSendOtp({
        this.code,
        this.message,
        this.otp,
    });

    int code;
    String message;
    int otp;

    factory CheckEmailExistAndSendOtp.fromJson(Map<String, dynamic> json) => CheckEmailExistAndSendOtp(
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
