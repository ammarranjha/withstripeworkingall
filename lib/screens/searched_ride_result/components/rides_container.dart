import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/screens/home/components/your_ride_plan.dart';
import 'package:pool_your_car/screens/searched_ride_result/components/ride_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class RidesContainer extends StatefulWidget {
  final String currentuserId;
  final String driverID;
  final String rideid;
  final String day;
  final String time;
  final String fromlocation, tolocation;
  final String ridetype;
  final String carType;
  final String carName;
  final String carRegNumber;
  final String carManufactureYear;
  final int availableseats;
  final int offeredseats;
  final int discount;
  final String discription;
  final int ridefare;
  final passengersID;

  RidesContainer({
    Key key,
    @required this.currentuserId,
    @required this.driverID,
    @required this.rideid,
    @required this.day,
    @required this.time,
    @required this.fromlocation,
    @required this.tolocation,
    @required this.ridetype,
    @required this.carType,
    @required this.carName,
    @required this.carManufactureYear,
    @required this.carRegNumber,
    @required this.availableseats,
    @required this.offeredseats,
    @required this.discount,
    @required this.discription,
    @required this.ridefare,
    this.passengersID,
  }) : super(key: key);

  @override
  _RidesContainerState createState() => _RidesContainerState();
}

class _RidesContainerState extends State<RidesContainer> {
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

  @override
  void initState() {
    super.initState();
    gettingSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("object");
        // print("driver id: " + widget.driverID);
        // print(this.sharedprefenrenceid);
        if (widget.driverID == this.sharedprefenrenceid) {
          print("current" + this.sharedprefenrenceid);
          print("driver id: " + widget.driverID);
          print("Current user is same as driver id");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RidePlan(
                rideid: widget.rideid,
                day: widget.day,
                time: widget.time,
                fromlocation: widget.fromlocation,
                tolocation: widget.tolocation,
                ridetype: widget.ridetype,
                cartype: widget.carType,
                carName: widget.carName,
                carManufactureYear: widget.carManufactureYear,
                carRegNumber: widget.carRegNumber,
                discount: widget.discount,
                discription: widget.discription,
                ridefare: widget.ridefare,
                availableseats: widget.availableseats,
                offeredseats: widget.offeredseats,
              ),
            ),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SearchedResultRidePlan(
          //       driverID: widget.driverID,
          //       rideid: widget.rideid,
          //       day: widget.day,
          //       time: widget.time,
          //       fromlocation: widget.fromlocation,
          //       tolocation: widget.tolocation,
          //       cashamount: widget.ridefare,
          //       carType: widget.carType,
          //       vehicle_registration_number: widget.vehicle_registration_number,
          //       availableseats: widget.availableseats,
          //       offeredseats: widget.offeredseats,
          //       discount: widget.discount,
          //       discription: widget.discription,
          //       ridefare: widget.ridefare,
          //     ),
          //   ),
          // );
        } else {
          print("No");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchedResultRidePlan(
                driverID: widget.driverID,
                rideid: widget.rideid,
                day: widget.day,
                time: widget.time,
                fromlocation: widget.fromlocation,
                tolocation: widget.tolocation,
                cashamount: widget.ridefare,
                carType: widget.carType,
                vehicle_registration_number: widget.carRegNumber,
                availableseats: widget.availableseats,
                offeredseats: widget.offeredseats,
                discount: widget.discount,
                discription: widget.discription,
                passengersID: (widget.passengersID == null)
                    ? []
                    : widget.passengersID as List<dynamic>,
                ridefare: widget.ridefare,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(40),
            vertical: getProportionateScreenHeight(10)),
        child: Column(
          children: [
            //SizedBox(height: getProportionateScreenHeight(20)),
            Container(
              decoration: BoxDecoration(
                //color: Colors.white54,
                gradient: kPrimaryGradientColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    //color: kPrimaryColor,
                    spreadRadius: 4,
                    blurRadius: 3,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              // height: getProportionateScreenHeight(200),
              // width: getProportionateScreenWidth(250),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: getProportionateScreenHeight(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.day}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.time}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Row(
                      children: [
                        Text(
                          "From :",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.fromlocation}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "To :",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.tolocation}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    if (widget.discount != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Discount",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${widget.discount}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ride Fare",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Rs ${widget.ridefare}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    // CircleAvatar(
                    //   backgroundImage: AssetImage("$image"),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: Text(
                    //     "drivername",
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: getProportionateScreenWidth(15),
                    //     ),
                    //   ),
                    // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
