// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/models/GetOverallOfferedRidesResponseModel.dart';
import 'package:pool_your_car/screens/searched_ride_result/components/rides_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Body extends StatefulWidget {
  final String pickuplocation;
  final String pickuplocation_lat;
  final String pickuplocation_lon;
  final String droplocation;
  final String droplocation_lat;
  final String droplocation_lon;
  final String date;
  final String time;
  final String cartype;
  final int noofpassengers;
  Body({
    @required this.pickuplocation,
    @required this.droplocation,
    @required this.date,
    @required this.time,
    @required this.cartype,
    @required this.noofpassengers,
    @required this.pickuplocation_lat,
    @required this.pickuplocation_lon,
    @required this.droplocation_lat,
    @required this.droplocation_lon,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List rides;
  List list = [];
  List sortedrideslist = [];
  bool isSortedListEmpty = true;
  Position currentUserPosition;
  double pickuplocationdistanceInMeter = 0.0;
  double droplocationdistanceInMeter = 0.0;
  DateFormat format = DateFormat("EEE, d LLLL y h:mm a");
  DateTime parsedDate;
  String sharedprefenrenceid;
  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    //String _email = emailprefs.get("email");
    print("In search ride result screen");
    print("User id in shared preference is " + json.decode(userid));
    // print("user email in shared preference is " + json.decode(_email));
    sharedprefenrenceid = json.decode(userid);
  }

  bool isListNotEmpty(List a) {
    if (a.length != 0)
      return true;
    else
      return false;
  }

  var users = new List<GetOverallOfferedRidesResponseModel>();
  // ignore: missing_return
  Future<GetOverallOfferedRidesResponseModel> fetchOverallOfferedRides() async {
    final response =
        await http.get(Uri.parse('$myip/api/ride/getoverallofferedrides'));
    list = json.decode(response.body);

    if (response.statusCode == 200) {
      // List<String> jsonResponse = json.decode(response.body);

      final body = json.decode(response.body) as List;
      setState(() {
        this.list = body;
      });

      // return GetOverallOfferedRidesResponseModel.fromJson(
      //     jsonDecode(response.body));
    } else {
      throw Exception('Failed ro load overall offered rides');
    }
  }

  Future calculatedistance() async {
    double pickuplocationdistanceInKiloMeters = 0.0;
    double droplocationdistanceInKiloMeters = 0.0;
    for (int i = 0; i < this.list.length; i++) {
      pickuplocationdistanceInMeter = await Geolocator.distanceBetween(
          double.parse(list[i]["pickuplocation_Lat"]),
          double.parse(list[i]["pickuplocation_Lon"]),
          double.parse(widget.pickuplocation_lat),
          double.parse(widget.pickuplocation_lon));
      droplocationdistanceInMeter = await Geolocator.distanceBetween(
          double.parse(list[i]["droplocation_Lat"]),
          double.parse(list[i]["droplocation_Lon"]),
          double.parse(widget.droplocation_lat),
          double.parse(widget.droplocation_lon));
      pickuplocationdistanceInKiloMeters = pickuplocationdistanceInMeter / 1000;
      droplocationdistanceInKiloMeters = droplocationdistanceInMeter / 1000;

      DateTime _searcheddatetime =
          format.parse(widget.date + " " + widget.time);
      DateTime _ridelistdatetime =
          format.parse(list[i]["date"] + " " + list[i]["time"]);

      if (
          //_searcheddatetime.isAtSameMomentAs(_ridelistdatetime) &&
          droplocationdistanceInKiloMeters < 10.0 &&
              pickuplocationdistanceInKiloMeters < 2.0
          //&&
          //widget.noofpassengers <= list[i]["availableseats"]
          ) {
        // print(i);
        // print("--Pickup location:---");
        // print("list pickup loc : " + list[i]["pickuplocation"]);
        // print("search pickup loc :");
        // print(widget.pickuplocation);
        // print("Pickup Distance: $pickuplocationdistanceInKiloMeters km");
        // print("---Drop location:----");
        // print("list drop loc : " + list[i]["droplocation"]);
        // print("search Drop loc :");
        // print(widget.droplocation);
        // print("Drop Distance: $droplocationdistanceInKiloMeters km");
        // print("Searched ride date time");
        // print(_searcheddatetime);

        // print("Rides list date time");
        // print(_ridelistdatetime);
        // print("Driver ID" + list[i]["driverId"]);
        setState(() {
          this.sortedrideslist.add(list[i]);
          this.isSortedListEmpty = false;
        });
      }
    }
    if (sortedrideslist.isNotEmpty) {
      for (int i = 0; i < sortedrideslist.length; i++) {
        print(sortedrideslist[i]);
      }
    } else {
      print("List empty");
    }
  }

  Function printlist() {
    if (sortedrideslist.length != 0) {
      for (int i = 0; i < sortedrideslist.length; i++) {
        print(sortedrideslist[i]);
      }
    } else {
      print("List empty");
    }
  }

  void callfunction() async {
    await fetchOverallOfferedRides();
    await calculatedistance();
    printlist();
  }

  @override
  void initState() {
    super.initState();

    //fetchOverallOfferedRides();
    callfunction();
    //calculatedistance();
    //printlist();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.007),
          Text(
            "Available Rides",
            style: TextStyle(
              color: Colors.black,
              fontSize: getProportionateScreenWidth(28),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),

          // DefaultButton(
          //   text: "Click",
          //   press: () {
          //     calculatedistance();
          //   },
          // ),
          // SizedBox(height: getProportionateScreenHeight(20)),
          // DefaultButton(
          //   text: "print list",
          //   press: () {
          //     calculatedistance();
          //     //printlist();
          //   },
          // ),

          Expanded(
            child: Container(
              child: !this.isSortedListEmpty
                  ? ListView.builder(
                      itemCount: this.sortedrideslist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RidesContainer(
                          currentuserId: this.sharedprefenrenceid,
                          rideid: this.sortedrideslist[index]["_id"],
                          time: this.sortedrideslist[index]["time"],
                          day: this.sortedrideslist[index]["date"],
                          fromlocation: this.sortedrideslist[index]
                              ["pickuplocation"],
                          tolocation: this.sortedrideslist[index]
                              ['droplocation'],
                          ridetype: this.sortedrideslist[index]["ride_type"],
                          carType: this.sortedrideslist[index]["cartype"],
                          carManufactureYear: this.sortedrideslist[index]
                              ["car_manufacture_year"],
                          carName: this.sortedrideslist[index]["car_name"],
                          carRegNumber: this.sortedrideslist[index]
                              ["car_registration_number"],
                          discount: this.sortedrideslist[index]["discount"],
                          offeredseats: this.sortedrideslist[index]
                              ["offeredseats"],
                          availableseats: this.sortedrideslist[index]
                              ["availableseats"],
                          discription: this.sortedrideslist[index]
                              ["optional_details"],
                          passengersID: (this.sortedrideslist[index]
                                      ["passengersID"] ==
                                  null)
                              ? []
                              : this.sortedrideslist[index]["passengersID"],
                          ridefare: this.sortedrideslist[index]["ridefare"],
                          driverID: this.sortedrideslist[index]["driverId"],
                        );
                      })
                  : Center(
                      child: Text(
                        "No Offered rides to show",
                        style: TextStyle(
                          //color: Colors.black,
                          fontSize: getProportionateScreenWidth(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
