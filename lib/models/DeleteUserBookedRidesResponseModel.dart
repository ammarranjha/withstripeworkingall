// To parse this JSON data, do
//
//     final deleteUserOfferedRidesResponseModel = deleteUserOfferedRidesResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteUserOfferedRidesResponseModel deleteUserOfferedRidesResponseModelFromJson(
        String str) =>
    DeleteUserOfferedRidesResponseModel.fromJson(json.decode(str));

String deleteUserOfferedRidesResponseModelToJson(
        DeleteUserOfferedRidesResponseModel data) =>
    json.encode(data.toJson());

class DeleteUserOfferedRidesResponseModel {
  DeleteUserOfferedRidesResponseModel({
    this.code,
    this.message,
    this.deleteRide,
  });

  int code;
  String message;
  DeleteRide deleteRide;

  factory DeleteUserOfferedRidesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      DeleteUserOfferedRidesResponseModel(
        code: json["code"],
        message: json["message"],
        deleteRide: DeleteRide.fromJson(json["deleteRide"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "deleteRide": deleteRide.toJson(),
      };
}

class DeleteRide {
  DeleteRide({
    this.discount,
    this.passengersId,
    this.id,
    this.pickuplocation,
    this.pickuplocationLat,
    this.pickuplocationLon,
    this.droplocation,
    this.droplocationLat,
    this.droplocationLon,
    this.date,
    this.time,
    this.offeredseats,
    this.availableseats,
    this.cartype,
    this.vehicleRegistrationNumber,
    this.optionalDetails,
    this.ridefare,
    this.rideType,
    this.driverId,
    this.v,
  });

  int discount;
  List<dynamic> passengersId;
  String id;
  String pickuplocation;
  String pickuplocationLat;
  String pickuplocationLon;
  String droplocation;
  String droplocationLat;
  String droplocationLon;
  String date;
  String time;
  int offeredseats;
  int availableseats;
  String cartype;
  String vehicleRegistrationNumber;
  String optionalDetails;
  int ridefare;
  String rideType;
  String driverId;
  int v;

  factory DeleteRide.fromJson(Map<String, dynamic> json) => DeleteRide(
        discount: json["discount"],
        passengersId: List<dynamic>.from(json["passengersID"].map((x) => x)),
        id: json["_id"],
        pickuplocation: json["pickuplocation"],
        pickuplocationLat: json["pickuplocation_Lat"],
        pickuplocationLon: json["pickuplocation_Lon"],
        droplocation: json["droplocation"],
        droplocationLat: json["droplocation_Lat"],
        droplocationLon: json["droplocation_Lon"],
        date: json["date"],
        time: json["time"],
        offeredseats: json["noofpassengers"],
        availableseats: json["availableseats"],
        cartype: json["cartype"],
        vehicleRegistrationNumber: json["vehicle_registration_number"],
        optionalDetails: json["optional_details"],
        ridefare: json["ridefare"],
        rideType: json["ride_type"],
        driverId: json["driverId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "discount": discount,
        "passengersID": List<dynamic>.from(passengersId.map((x) => x)),
        "_id": id,
        "pickuplocation": pickuplocation,
        "pickuplocation_Lat": pickuplocationLat,
        "pickuplocation_Lon": pickuplocationLon,
        "droplocation": droplocation,
        "droplocation_Lat": droplocationLat,
        "droplocation_Lon": droplocationLon,
        "date": date,
        "time": time,
        "noofpassengers": offeredseats,
        "availableseats": availableseats,
        "cartype": cartype,
        "vehicle_registration_number": vehicleRegistrationNumber,
        "optional_details": optionalDetails,
        "ridefare": ridefare,
        "ride_type": rideType,
        "driverId": driverId,
        "__v": v,
      };
}
