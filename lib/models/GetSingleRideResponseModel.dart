// To parse this JSON data, do
//
//     final getSingleRideResponseModel = getSingleRideResponseModelFromJson(jsonString);

import 'dart:convert';

GetSingleRideResponseModel getSingleRideResponseModelFromJson(String str) =>
    GetSingleRideResponseModel.fromJson(json.decode(str));

String getSingleRideResponseModelToJson(GetSingleRideResponseModel data) =>
    json.encode(data.toJson());

class GetSingleRideResponseModel {
  GetSingleRideResponseModel({
    this.passengers,
    this.discount,
    this.requestedPassengers,
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
    this.carName,
    this.carRegistrationNumber,
    this.carManufactureYear,
    this.optionalDetails,
    this.ridefare,
    this.rideType,
    this.driverId,
    this.v,
  });

  List<dynamic> passengers;
  int discount;
  List<dynamic> requestedPassengers;
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
  String carName;
  String carRegistrationNumber;
  String carManufactureYear;
  dynamic optionalDetails;
  int ridefare;
  String rideType;
  String driverId;
  int v;

  factory GetSingleRideResponseModel.fromJson(Map<String, dynamic> json) =>
      GetSingleRideResponseModel(
        passengers: List<dynamic>.from(json["passengers"].map((x) => x)),
        discount: json["discount"],
        requestedPassengers:
            List<dynamic>.from(json["requestedPassengers"].map((x) => x)),
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
        offeredseats: json["offeredseats"],
        availableseats: json["availableseats"],
        cartype: json["cartype"],
        carName: json["car_name"],
        carRegistrationNumber: json["car_registration_number"],
        carManufactureYear: json["car_manufacture_year"],
        optionalDetails: json["optional_details"],
        ridefare: json["ridefare"],
        rideType: json["ride_type"],
        driverId: json["driverId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "passengers": List<dynamic>.from(passengers.map((x) => x)),
        "discount": discount,
        "requestedPassengers":
            List<dynamic>.from(requestedPassengers.map((x) => x)),
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
        "offeredseats": offeredseats,
        "availableseats": availableseats,
        "cartype": cartype,
        "car_name": carName,
        "car_registration_number": carRegistrationNumber,
        "car_manufacture_year": carManufactureYear,
        "optional_details": optionalDetails,
        "ridefare": ridefare,
        "ride_type": rideType,
        "driverId": driverId,
        "__v": v,
      };
}
