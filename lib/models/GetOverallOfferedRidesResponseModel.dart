class GetOverallOfferedRidesResponseModel {
  int discount;
  List<String> passengersID;
  String sId;
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
  int iV;

  GetOverallOfferedRidesResponseModel(
      {this.discount,
      this.passengersID,
      this.sId,
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
      this.iV});

  GetOverallOfferedRidesResponseModel.fromJson(Map<String, dynamic> json) {
    discount = json['discount'];
    passengersID = json['passengersID'].cast<String>();
    sId = json['_id'];
    pickuplocation = json['pickuplocation'];
    pickuplocationLat = json['pickuplocation_Lat'];
    pickuplocationLon = json['pickuplocation_Lon'];
    droplocation = json['droplocation'];
    droplocationLat = json['droplocation_Lat'];
    droplocationLon = json['droplocation_Lon'];
    date = json['date'];
    time = json['time'];
    offeredseats = json['offeredseats'];
    availableseats = json['availableseats'];
    cartype = json['cartype'];
    vehicleRegistrationNumber = json['vehicle_registration_number'];
    optionalDetails = json['optional_details'];
    ridefare = json['ridefare'];
    rideType = json['ride_type'];
    driverId = json['driverId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = this.discount;
    data['passengersID'] = this.passengersID;
    data['_id'] = this.sId;
    data['pickuplocation'] = this.pickuplocation;
    data['pickuplocation_Lat'] = this.pickuplocationLat;
    data['pickuplocation_Lon'] = this.pickuplocationLon;
    data['droplocation'] = this.droplocation;
    data['droplocation_Lat'] = this.droplocationLat;
    data['droplocation_Lon'] = this.droplocationLon;
    data['date'] = this.date;
    data['time'] = this.time;
    data['offeredseats'] = this.offeredseats;
    data['availableseats'] = this.availableseats;
    data['cartype'] = this.cartype;
    data['vehicle_registration_number'] = this.vehicleRegistrationNumber;
    data['optional_details'] = this.optionalDetails;
    data['ridefare'] = this.ridefare;
    data['ride_type'] = this.rideType;
    data['driverId'] = this.driverId;
    data['__v'] = this.iV;
    return data;
  }
}
