// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pool_your_car/screens/home/home_screen.dart';
import '../../../size_config.dart';
import '../../../constants.dart';
import '../../../components/default_button.dart';
import '../../../models/AddRideResponseModel.dart';
import 'package:http/http.dart' as http;

class RemainingBodySecond extends StatefulWidget {
  @override
  static String routeName = "/offer_ride/components";
  final String sharedprefenrenceid;
  final String pickuplocation;
  final String droplocation, vehicle_registration_number;
  final String date, time;
  final int offeredseats;
  // ignore_for_file: non_constant_identifier_names
  final String pickup_Lat,
      pickup_Lon,
      drop_Lat,
      drop_Lon,
      cartype,
      car_name,
      car_manufacture_year;
  String optional_details;

  RemainingBodySecond({
    Key key,
    @required this.sharedprefenrenceid,
    @required this.pickuplocation,
    @required this.droplocation,
    @required this.vehicle_registration_number,
    @required this.date,
    @required this.time,
    @required this.pickup_Lat,
    @required this.pickup_Lon,
    @required this.drop_Lat,
    @required this.drop_Lon,
    @required this.offeredseats,
    @required this.cartype,
    @required this.optional_details,
    @required this.car_name,
    @required this.car_manufacture_year,
  }) : super(key: key);

  @override
  _RemainingBodySecondState createState() => _RemainingBodySecondState();
}

class _RemainingBodySecondState extends State<RemainingBodySecond> {
  int ridefare = 0;
  int fareperkilometer = 10;
  int discount = 0;
  String ride_type = "Offered";

  void _incrementDiscount() {
    if (discount < 50) {
      setState(() {
        discount += 5;
      });
    } else {
      discount = 50;
    }
  }

  void _decrementDiscount() {
    if (discount > 0) {
      setState(() {
        discount -= 5;
      });
    } else {
      discount = 0;
    }
  }

  void _incrementRideFare() {
    setState(() {
      ridefare += 10;
    });
  }

  void _decrementRideFare() {
    if (ridefare > 10) {
      setState(() {
        ridefare -= 10;
      });
    } else {
      ridefare = 10;
    }
  }

  // ignore: missing_return
  Future<AddRideResponseModel> createRide(
    String pickuplocation,
    pickuplocationLat,
    pickuplocationLon,
    droplocation,
    droplocationLat,
    droplocationLon,
    date,
    time,
    int offeredseats,
    int availableseats,
    String cartype,
    String car_name,
    car_registration_number,
    car_manufacture_year,
    optionalDetails,
    int discount,
    int ridefare,
    String rideType,
    String sharedprefenrenceid,
  ) async {
    Loader.show(context,
        isAppbarOverlay: true,
        isBottomBarOverlay: true,
        progressIndicator: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
        themeData: Theme.of(context).copyWith(accentColor: Colors.green),
        overlayColor: Color(0x99E8EAF6));

    final String apiUrl = "$myip/api/ride/add";
    var body = jsonEncode({
      "pickuplocation": pickuplocation,
      "pickuplocation_Lat": pickuplocationLat,
      "pickuplocation_Lon": pickuplocationLon,
      "droplocation": droplocation,
      "droplocation_Lat": droplocationLat,
      "droplocation_Lon": droplocationLon,
      "date": date,
      "time": time,
      "offeredseats": offeredseats,
      "availableseats": offeredseats,
      "cartype": cartype,
      "car_name": car_name,
      "car_registration_number": car_registration_number,
      "car_manufacture_year": car_manufacture_year,
      "optional_details": optionalDetails,
      "ridefare": ridefare,
      "ride_type": rideType,
      "discount": discount,
      "driverId": sharedprefenrenceid
    });
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print("ending loader");
    Loader.hide();
    if (response.statusCode == 200) {
      print(response.body.toString());
      final String responseString = response.body;
      Fluttertoast.showToast(
        msg: "Ride Posted Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));

      return addRideResponseModelFromJson(responseString);
    } else {
      print(response.body.toString());
      Fluttertoast.showToast(
        msg: response.body.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
    }

    //   Fluttertoast.showToast(
    //   msg: "Ride Posted Successfully",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.SNACKBAR,
    //   backgroundColor: kPrimaryColor,
    //   textColor: Colors.white,
    //   fontSize: 20.0,
    // );
    //if (_formKey.currentState.validate()) {
    //_formKey.currentState.save();

    //KeyboardUtil.hideKeyboard(context);
    //Navigator.pushNamed(context, RemainingBody.routeName);
    //},
  }

  Future calculatedistance() async {
    double distanceinkilometer = 0.0;

    double distanceInMeters = await Geolocator.distanceBetween(
        double.parse(widget.pickup_Lat),
        double.parse(widget.pickup_Lon),
        double.parse(widget.drop_Lat),
        double.parse(widget.drop_Lon));

    distanceinkilometer = distanceInMeters / 1000;

    setState(() {
      ridefare = (distanceinkilometer * fareperkilometer).round();
    });
  }

  @override
  void initState() {
    super.initState();
    calculatedistance();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text(
          "Offer Ride",
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text(
                    "Ride Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Row(
                    children: [
                      Container(
                        //width: MediaQuery.of(context).size.width*0.9,
                        width: getProportionateScreenWidth(250),
                        child: Text(
                          "This is our recomended price per seat. Is it OK for you?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          _decrementRideFare();
                        },
                        splashColor: Colors.white,
                        elevation: 2.0,
                        fillColor: kPrimaryColor,
                        child: Icon(
                          Icons.remove,
                          size: getProportionateScreenWidth(28),
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ),
                      Spacer(),
                      Text(
                        "Rs$ridefare",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(40),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      RawMaterialButton(
                        onPressed: () {
                          _incrementRideFare();
                        },
                        splashColor: Colors.white,
                        elevation: 2.0,
                        fillColor: kPrimaryColor,
                        child: Icon(Icons.add,
                            size: getProportionateScreenWidth(28)),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Row(
                    children: [
                      Container(
                        width: getProportionateScreenWidth(280),
                        child: Text(
                          "Provide discount to attract passengers",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Optional***",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(15),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text(
                    "Discount",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          _decrementDiscount();
                        },
                        splashColor: Colors.white,
                        elevation: 2.0,
                        fillColor: kPrimaryColor,
                        child: Icon(
                          Icons.remove,
                          size: getProportionateScreenWidth(28),
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ),
                      Spacer(),
                      Text(
                        "$discount%",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(40),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      RawMaterialButton(
                        onPressed: () {
                          _incrementDiscount();
                        },
                        splashColor: Colors.white,
                        elevation: 2.0,
                        fillColor: kPrimaryColor,
                        child: Icon(Icons.add,
                            size: getProportionateScreenWidth(28)),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  DefaultButton(
                    text: "Next",
                    press: () async {
                      print("pickup details : " + widget.pickuplocation);
                      print("pickup lat: " +
                          widget.pickup_Lat +
                          "  pickup long:  " +
                          widget.pickup_Lon);
                      print("drop detail:  " + widget.droplocation);
                      print("drop lat: " +
                          widget.drop_Lat +
                          "  drop long:  " +
                          widget.drop_Lon);
                      print("no of passengers: ");
                      print(widget.offeredseats);
                      print("Car Type: " + widget.cartype);
                      print("Vehicle Reg number: " +
                          widget.vehicle_registration_number);
                      print("Ride Fare: ");
                      print(this.ridefare);
                      print("Ride Discount: ");
                      print(this.discount);
                      print("Date:" + widget.date);
                      print("Time: " + widget.time);
                      if (widget.optional_details.isNotEmpty)
                        print("Optional Details: " + widget.optional_details);
                      else {
                        widget.optional_details = null;

                        print("Optional Details ");
                        print(widget.optional_details);
                      }

                      await createRide(
                          widget.pickuplocation,
                          widget.pickup_Lat,
                          widget.pickup_Lon,
                          widget.droplocation,
                          widget.drop_Lat,
                          widget.drop_Lon,
                          widget.date,
                          widget.time,
                          widget.offeredseats,
                          widget.offeredseats,
                          widget.cartype,
                          widget.car_name,
                          widget.vehicle_registration_number,
                          widget.car_manufacture_year,
                          widget.optional_details,
                          discount,
                          ridefare,
                          ride_type,
                          widget.sharedprefenrenceid);
                    },
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
