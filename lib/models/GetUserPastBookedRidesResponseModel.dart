// To parse this JSON data, do
//
//     final getUserPastOfferedRidesResponseModel = getUserPastOfferedRidesResponseModelFromJson(jsonString);

import 'dart:convert';

GetUserPastOfferedRidesResponseModel
    getUserPastOfferedRidesResponseModelFromJson(String str) =>
        GetUserPastOfferedRidesResponseModel.fromJson(json.decode(str));

String getUserPastOfferedRidesResponseModelToJson(
        GetUserPastOfferedRidesResponseModel data) =>
    json.encode(data.toJson());

class GetUserPastOfferedRidesResponseModel {
  GetUserPastOfferedRidesResponseModel({
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
  List<String> offeredride;
  List<dynamic> bookedride;
  List<Pastofferedride> pastofferedride;
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

  factory GetUserPastOfferedRidesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetUserPastOfferedRidesResponseModel(
        emailverified: json["emailverified"],
        offeredride: List<String>.from(json["offeredride"].map((x) => x)),
        bookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
        pastofferedride: List<Pastofferedride>.from(
            json["pastofferedride"].map((x) => Pastofferedride.fromJson(x))),
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
        v: json["__v"],
        profileImageUrl: json["profile_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "emailverified": emailverified,
        "offeredride": List<dynamic>.from(offeredride.map((x) => x)),
        "bookedride": List<dynamic>.from(bookedride.map((x) => x)),
        "pastofferedride":
            List<dynamic>.from(pastofferedride.map((x) => x.toJson())),
        "pastbookedride": List<dynamic>.from(pastbookedride.map((x) => x)),
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

class Pastofferedride {
  Pastofferedride({
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
    this.optionalDetails,
    this.ridefare,
    this.vehicleRegistrationNumber,
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
  dynamic optionalDetails;
  int ridefare;
  String vehicleRegistrationNumber;
  String rideType;
  String driverId;
  int v;

  factory Pastofferedride.fromJson(Map<String, dynamic> json) =>
      Pastofferedride(
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
        offeredseats: json["offeredseats"],
        availableseats: json["availableseats"],
        cartype: json["cartype"],
        optionalDetails: json["optional_details"],
        ridefare: json["ridefare"],
        vehicleRegistrationNumber: json["vehicle_registration_number"],
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
        "offeredseats": offeredseats,
        "availableseats": availableseats,
        "cartype": cartype,
        "optional_details": optionalDetails,
        "ridefare": ridefare,
        "vehicle_registration_number": vehicleRegistrationNumber,
        "ride_type": rideType,
        "driverId": driverId,
        "__v": v,
      };
}
