import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/models/AddPassengerResponseModel.dart';
import 'package:pool_your_car/models/Directions.dart';
import 'package:pool_your_car/screens/map/map_screen.dart';
import 'package:pool_your_car/screens/public_profile_view/public_profile_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../size_config.dart';
import '../../../constants.dart';

import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

import 'package:confirm_dialog/confirm_dialog.dart';
import '../home_screen.dart';
import 'edit_ride_screen.dart';
import 'package:http/http.dart' as http;

class RidePlan extends StatefulWidget {
  final String rideid;
  final String day; //=
  //DateFormat('EEE, M/d/y').format(DateT ime.now()); //EEE, M/d/y
  final String time; //= DateFormat('hh:mm:a').format(DateTime.now()); //hh:mm:a
  final String fromlocation, tolocation;
  final String ridetype;
  final String image;
  final String drivername;
  final String carName;
  final String carRegNumber;
  final String carManufactureYear;
  final String cartype;
  final availableseats;
  final offeredseats;
  final int discount;
  final String discription;
  final int ridefare;
  final String acceptance;
  RidePlan({
    Key key,
    @required this.rideid,
    @required this.day,
    @required this.time,
    @required this.fromlocation,
    @required this.tolocation,
    @required this.ridetype,
    this.image,
    this.drivername,
    this.acceptance,
    @required this.cartype,
    @required this.availableseats,
    @required this.offeredseats,
    @required this.discount,
    @required this.discription,
    @required this.ridefare,
    @required this.carName,
    @required this.carManufactureYear,
    @required this.carRegNumber,
  }) : super(key: key);

  @override
  State<RidePlan> createState() => _RidePlanState();
}

class _RidePlanState extends State<RidePlan> {
  bool image_is_uploaded = false;
  bool bookrequestbuttondisabled = false;
  String driver_profile_image_url;

  String sharedprefenrenceid;
  Future<void> gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    print("In home screen");
    print("User id in shared preference is " + json.decode(userid));
    print("user email in shared preference is " + json.decode(_email));
    sharedprefenrenceid = json.decode(userid);
    //GetUserDetails();
  }

  Future<void> deleteofferedride() async {
    var headers = {'Content-Type': 'application/json'};
    print("Before url");
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '$myip/api/ride/deleteofferedride/${widget.rideid.toString()}'));
    request.body = json.encode({
      "userId": this.sharedprefenrenceid,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("In status 200");
      Fluttertoast.showToast(
        msg: "Ride deleted",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
      //CherryToast.success(
      //   toastDuration: Duration(seconds: 5),
      //   title: "",
      //   enableIconAnimation: true,
      //   displayTitle: false,
      //   description: "Ride deleted",
      //   toastPosition: POSITION.BOTTOM,
      //   animationDuration: Duration(milliseconds: 1000),
      //   autoDismiss: true,
      // ).show(context);
      //Navigator.pushNamed(context, HomeScreen.routeName);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print(response.reasonPhrase);
      CherryToast.error(
        toastDuration: Duration(seconds: 5),
        title: "",
        enableIconAnimation: true,
        displayTitle: false,
        description: "Deletion Failed",
        toastPosition: POSITION.BOTTOM,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    }
  }

  Future<void> cancelBookedRide() async {
    print("Before url");
    http.Response response = await http.post(
        Uri.parse(
            '$myip/api/ride/cancelbookedride/${widget.rideid.toString()}'),
        body: json.encode({
          "userId": this.sharedprefenrenceid,
        }),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print(response.body);
      print("In status 200");
      Fluttertoast.showToast(
        msg: "Ride Booking cancelled",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to cancel booked ride',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 20.0,
      );
      throw Exception('Failed to cancel booked ride');
    }
  }

  Future<Directions> getDirection({String origin, String destination}) async {
    Dio _dio = Dio();
    const String _url = 'https://maps.googleapis.com/maps/api/directions/json?';

    final Response response = await _dio.get(_url, queryParameters: {
      'origin': origin,
      'destination': destination,
      'key': googleApiKey
    });

    if (response.statusCode == 200) {
      return Directions.fromJson(response.data as Map<String, dynamic>);
    }

    return throw 'Error in Direction';
  }

  List<AddPassengerResponseModel> passengers = [];
  bool isBooked = false;
  bool isRideAccepted = false;

  Future<void> getPassengers() async {
    var headers = {'Content-Type': 'application/json'};
    print("Before url");
    http.Response response = await http.get(
        Uri.parse('$myip/api/ride/passengers/${widget.rideid.toString()}'),
        headers: headers);

    List<dynamic> passengerData = json.decode(response.body)['passengers'];
    print("data length: ${passengerData.length}");
    if (passengerData.length > 0) {
      setState(() {
        passengers = passengerData.map((e) {
          AddPassengerResponseModel passenger =
              AddPassengerResponseModel.fromJson(e);
          if (passenger.id == this.sharedprefenrenceid) {
            bookrequestbuttondisabled = true;
            isRideAccepted = true;
          } else {
            bookrequestbuttondisabled = false;
          }
          return passenger;
        }).toList();
      });
    }

    List<dynamic> requestedPassengerData =
        json.decode(response.body)['requestedpassengers'];
    print("data length: ${requestedPassengerData.length}");
    if (requestedPassengerData.length > 0) {
      setState(() {
        requestedPassengerData.map((e) {
          AddPassengerResponseModel passenger =
              AddPassengerResponseModel.fromJson(e);
          if (passenger.id == this.sharedprefenrenceid) {
            bookrequestbuttondisabled = true;
            isRideAccepted = false;
          } else {
            bookrequestbuttondisabled = false;
          }
          return passenger;
        }).toList();
      });
    }
  }

  Future<void> openMap() async {
    try {
      final Directions directions = await getDirection(
          origin: widget.fromlocation, destination: widget.tolocation);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapScreen(
                    info: directions,
                    ride: this.widget.rideid,
                  )));
    } catch (err) {
      print(err);
    }
  }

  Future<void> callFunction() async {
    await getPassengers();
  }

  @override
  void initState() {
    getPassengers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        //title: Text("Ride Plan"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                left: getProportionateScreenWidth(30),
                right: getProportionateScreenWidth(30)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Ride Plan",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ), //00331

                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Row(
                    children: [
                      Text(
                        "${widget.day}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${widget.time}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "From :      ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "${widget.fromlocation}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "To :          ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "${widget.tolocation}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  if (this.widget.discription != null)
                    Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              "Ride limitations",
                              style: TextStyle(
                                  //color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${widget.discription}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(15),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "${widget.cartype}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Container(
                        child: SvgPicture.asset(
                          "assets/icons/Minicar2 icon.svg",
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Car Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        "${widget.carName}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Offered Seats",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        "${widget.offeredseats}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "Available Seats",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        "${widget.availableseats}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "Available Seats",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        "${widget.availableseats}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Discount",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${widget.discount}%",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),

                  Row(
                    children: [
                      Text(
                        "Ride Fare Per Seat",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        "Rs. ${widget.ridefare}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  if (widget.acceptance != null)
                    Row(
                      children: [
                        Text(
                          "Ride Status",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Text(
                          "${widget.acceptance}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),

                  SizedBox(height: SizeConfig.screenHeight * 0.01),

                  SizedBox(
                    child: Text(
                      "${this.passengers.isEmpty ? "No" : ""} Passengers",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Column(
                    children: List.generate(passengers.length, (index) {
                      return Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print(passengers[index].id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PublicProfileViewScreen(
                                                userid: passengers[index].id)),
                                  );
                                },
                                child: Text(
                                  passengers[index].firstname +
                                      " " +
                                      passengers[index].lastname,
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: getProportionateScreenWidth(16),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Spacer(),
                              CircleAvatar(
                                backgroundImage: this.image_is_uploaded
                                    ? NetworkImage(
                                        "$myip/images/${passengers[index].profileImageUrl}")
                                    : AssetImage(
                                        "assets/images/Profile Image.png"),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                        ],
                      );
                    }),
                  ),
                  if (widget.ridetype == 'offered')
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                  if (widget.ridetype == 'offered')
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(50),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: kPrimaryColor,
                        onPressed: () async {
                          print('map opened');
                          openMap();
                        },
                        child: Text(
                          "Open In Map",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  if (widget.acceptance == null && widget.ridetype == 'offered')
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(50),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: kPrimaryColor,
                        ),
                        onPressed: () => {
                          print("Edit ride clicked"),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRideScreen(
                                rideid: this.widget.rideid,
                              ),
                            ),
                          )
                        },
                        child: Text(
                          "Edit Your Ride",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  if (widget.acceptance == null)
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(50),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: kPrimaryColor,
                        onPressed: () async {
                          if (await confirm(
                            context,
                            title: Text('Confirm'),
                            content: Text('Would you like to Delete?'),
                            textOK: Text('Yes'),
                            textCancel: Text('No'),
                          )) {
                            return {
                              //print("Ok is pressed"),
                              deleteofferedride(),
                            };
                          }
                          return print('pressedCancel');
                        },
                        child: Text(
                          "Delete Your Ride",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  if (widget.acceptance != null)
                    SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(50),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: kPrimaryColor,
                        ),
                        onPressed: () async {
                          if (await confirm(
                            context,
                            title: Text('Confirm'),
                            content:
                                Text('Would you like to cancel this ride?'),
                            textOK: Text('Yes'),
                            textCancel: Text('No'),
                          )) {
                            Navigator.popAndPushNamed(context, "/home");
                            return {
                              //print("Ok is pressed"),
                              cancelBookedRide(),
                            };
                          }
                        },
                        child: Text(
                          "Cancel ${widget.acceptance == "Booked" ? "Ride" : "Request"}",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
