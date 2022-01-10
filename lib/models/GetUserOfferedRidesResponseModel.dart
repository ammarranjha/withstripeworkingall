import 'dart:convert';

GetUserOfferedRidesResponseModel getUserOfferedRidesResponseModelFromJson(
        String str) =>
    GetUserOfferedRidesResponseModel.fromJson(json.decode(str));

String getUserOfferedRidesResponseModelToJson(
        GetUserOfferedRidesResponseModel data) =>
    json.encode(data.toJson());

class GetUserOfferedRidesResponseModel {
  GetUserOfferedRidesResponseModel({
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
  });

  bool emailverified;
  List<Offeredride> offeredride;
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

  factory GetUserOfferedRidesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetUserOfferedRidesResponseModel(
        emailverified: json["emailverified"],
        offeredride: List<Offeredride>.from(
            json["offeredride"].map((x) => Offeredride.fromJson(x))),
        bookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
        pastofferedride:
            List<dynamic>.from(json["pastofferedride"].map((x) => x)),
        pastbookedride: List<dynamic>.from(json["bookedride"].map((x) => x)),
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
        "emailverified": emailverified,
        "offeredride": List<dynamic>.from(offeredride.map((x) => x.toJson())),
        "bookedride": List<dynamic>.from(bookedride.map((x) => x)),
        "pastofferededride": List<dynamic>.from(pastofferedride.map((x) => x)),
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
      };
}

class Offeredride {
  Offeredride({
    this.discount,
    this.passengersId,
    this.id,
    this.pickuplocation,
    this.droplocation,
    this.date,
    this.description,
    this.time,
    this.offeredseats,
    this.availableseats,
    this.cartype,
    this.ridefare,
    this.driverId,
    this.v,
    this.pickuplocationLat,
    this.pickuplocationLon,
    this.droplocationLat,
    this.droplocationLon,
    this.optionalDetails,
  });

  int discount;
  List<dynamic> passengersId;
  String id;
  String pickuplocation;
  String droplocation;
  String date;
  String description;
  String time;
  int offeredseats;
  int availableseats;
  String cartype;
  int ridefare;
  String driverId;
  int v;
  String pickuplocationLat;
  String pickuplocationLon;
  String droplocationLat;
  String droplocationLon;

  String optionalDetails;

  factory Offeredride.fromJson(Map<String, dynamic> json) => Offeredride(
        discount: json["discount"],
        passengersId: List<dynamic>.from(json["passengersID"].map((x) => x)),
        id: json["_id"],
        pickuplocation: json["pickuplocation"],
        droplocation: json["droplocation"],
        date: json["date"],
        description: json["description"] == null ? null : json["description"],
        time: json["time"],
        offeredseats:
            json["offeredseats"] == null ? null : json["offeredseats"],
        availableseats:
            json["availableseats"] == null ? null : json["availableseats"],
        cartype: json["cartype"],
        ridefare: json["ridefare"],
        driverId: json["driverId"],
        v: json["__v"],
        pickuplocationLat: json["pickuplocation_Lat"] == null
            ? null
            : json["pickuplocation_Lat"],
        pickuplocationLon: json["pickuplocation_Lon"] == null
            ? null
            : json["pickuplocation_Lon"],
        droplocationLat:
            json["droplocation_Lat"] == null ? null : json["droplocation_Lat"],
        droplocationLon:
            json["droplocation_Lon"] == null ? null : json["droplocation_Lon"],
        optionalDetails:
            json["optional_details"] == null ? null : json["optional_details"],
      );

  Map<String, dynamic> toJson() => {
        "discount": discount,
        "passengersID": List<dynamic>.from(passengersId.map((x) => x)),
        "_id": id,
        "pickuplocation": pickuplocation,
        "droplocation": droplocation,
        "date": date,
        "description": description == null ? null : description,
        "time": time,
        "maxpassengers": offeredseats == null ? null : offeredseats,
        "availableseats": availableseats == null ? null : availableseats,
        "cartype": cartype,
        "ridefare": ridefare,
        "driverId": driverId,
        "__v": v,
        "pickuplocation_Lat":
            pickuplocationLat == null ? null : pickuplocationLat,
        "pickuplocation_Lon":
            pickuplocationLon == null ? null : pickuplocationLon,
        "droplocation_Lat": droplocationLat == null ? null : droplocationLat,
        "droplocation_Lon": droplocationLon == null ? null : droplocationLon,
        "optional_details": optionalDetails == null ? null : optionalDetails,
      };
}
