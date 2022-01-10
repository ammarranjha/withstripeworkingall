// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/models/AddPassengerResponseModel.dart';
import 'package:pool_your_car/models/GetUserResponseModel.dart';
import 'package:pool_your_car/screens/public_profile_view/public_profile_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;

class SearchedResultRidePlan extends StatefulWidget {
  final String driverID;
  final String rideid;
  final String day; //EEE, d LLLL y
  //     DateFormat(distance();
  //printlist();'EEE, d LLLL y').format(DateTime.now()); //EEE, d LLLL y
  final String
      time; // = DateFormat('hh:mm:a').format(DateTime.now()); //hh:mm:a
  final String fromlocation, tolocation;

  final int cashamount;
  final String carType;
  final availableseats;
  final offeredseats;
  final int discount;
  final String discription;
  final List<dynamic> passengersID;
  final int ridefare;
  final String vehicle_registration_number;
  SearchedResultRidePlan({
    Key key,
    @required this.driverID,
    @required this.rideid,
    @required this.day,
    @required this.time,
    @required this.fromlocation,
    @required this.tolocation,
    @required this.cashamount,
    @required this.carType,
    @required this.availableseats,
    @required this.offeredseats,
    @required this.discount,
    @required this.discription,
    @required this.ridefare,
    @required this.passengersID,
    @required this.vehicle_registration_number,
  }) : super(key: key);

  @override
  _SearchedResultRidePlanState createState() => _SearchedResultRidePlanState();
}

class _SearchedResultRidePlanState extends State<SearchedResultRidePlan> {
  String firstName = ''; //= "Abdul";
  String lastName = ''; // = "Rehman";
  String email = ''; //= "abc@gmail.com";
  String phoneNumber = ''; // = "03211234567";

  bool image_is_uploaded = false;
  bool Bookrequestbuttondisabled = false;
  String driver_profile_image_url;

  String sharedprefenrenceid;
  gettingSharedPreference() async {
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

  GetUserResponseModel user;
  Function BookRequestButton() {
    print("Book Request button press");
  }

  Future<GetUserResponseModel> GetDriversDetails() async {
    final response =
        await http.get(Uri.parse("$myip/api/getsingleuser/${widget.driverID}"));
    if (response.statusCode == 200) {
      print("Now Getting drivers data in ride plan screen");
      print(jsonDecode(response.body));

      Map<String, dynamic> responseJson = json.decode(response.body);
      // ignore: unused_local_variable

      print("after storing to object ");
      setState(() {
        this.firstName = responseJson['firstname'];
        this.lastName = responseJson['lastname'];
        this.email = responseJson['email'];
        this.phoneNumber = responseJson['phonenumber'];

        if (responseJson['profile_image_url'] != null) {
          this.image_is_uploaded = true;

          this.driver_profile_image_url = responseJson['profile_image_url'];
          print("Printing image url");
          print(this.driver_profile_image_url);
        }
      });

      return GetUserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body.toString());
    }
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
            Bookrequestbuttondisabled = true;
            isRideAccepted = true;
          } else {
            Bookrequestbuttondisabled = false;
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
            Bookrequestbuttondisabled = true;
            isRideAccepted = false;
          } else {
            Bookrequestbuttondisabled = false;
          }
          return passenger;
        }).toList();
      });
    }
  }

  Future<void> bookRide() async {
    print("Before url");
    http.Response response = await http
        .post(Uri.parse('$myip/api/ride/bookride/${widget.rideid.toString()}'),
            body: json.encode({
              "userId": this.sharedprefenrenceid,
            }),
            headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      print(response.body);
      print("In status 200");
      CherryToast.success(
        toastDuration: Duration(seconds: 2),
        title: "",
        enableIconAnimation: false,
        displayTitle: false,
        description: response.body,
        toastPosition: POSITION.BOTTOM,
        animationDuration: Duration(milliseconds: 500),
        autoDismiss: true,
      ).show(context);
      // Bookrequestbuttondisabled = !Bookrequestbuttondisabled;

      getPassengers();
      print('passenger updated');
    } else if (response.statusCode > 500) {
      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: "",
        enableIconAnimation: false,
        displayTitle: false,
        description: "Error Booking Ride",
        toastPosition: POSITION.BOTTOM,
        animationDuration: Duration(milliseconds: 500),
        autoDismiss: true,
      ).show(context);
    } else {
      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: "",
        enableIconAnimation: false,
        displayTitle: false,
        description: response.body,
        toastPosition: POSITION.BOTTOM,
        animationDuration: Duration(milliseconds: 500),
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

      await getPassengers();
      setState(() {
        Bookrequestbuttondisabled = false;
      });
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

  @override
  void initState() {
    super.initState();
    GetDriversDetails();
    getPassengers();
    gettingSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Ride Plan"),
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
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
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
                  //if (this.widget.discription != null)
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
                              this.widget.discription != null
                                  ? this.widget.discription.length != 0
                                      ? "${widget.discription}"
                                      : " - "
                                  : " - ",
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
                        "${widget.carType}",
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
                        "${widget.availableseats} Seat",
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
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),

                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Ride Fare/seat",
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
                        Divider(thickness: 1.8, color: kPrimaryColor),
                        //SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              "Driver: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.w700),
                            ),
                            GestureDetector(
                              onTap: () {
                                print(widget.driverID);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PublicProfileViewScreen(
                                              userid: widget.driverID)),
                                );
                              },
                              child: Text(
                                this.firstName + " " + this.lastName,
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
                                      "$myip/images/${this.driver_profile_image_url}")
                                  : AssetImage(
                                      "assets/images/Profile Image.png"),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                        SizedBox(
                          child: Text(
                            "${this.passengers.isEmpty ? "No" : ""} Passengers Yet",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.01),
                        Column(
                          children: List.generate(passengers.length, (index) {
                            return Column(
                              children: [
                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.02),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print(widget.driverID);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PublicProfileViewScreen(
                                                      userid: widget.driverID)),
                                        );
                                      },
                                      child: Text(
                                        passengers[index].firstname +
                                            " " +
                                            passengers[index].lastname,
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize:
                                                getProportionateScreenWidth(16),
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
                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.02),
                              ],
                            );
                          }),
                        ),
                        Divider(thickness: 1.8, color: kPrimaryColor),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        SizedBox(
                          child: Text(
                            "Note:20% of ride fare will be deducted in advance",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        !Bookrequestbuttondisabled
                            ? DefaultButton(text: "Book Ride", press: bookRide)
                            : DefaultButton(
                                text: isRideAccepted
                                    ? "Cancel Ride"
                                    : "Cancel Request",
                                press: cancelBookedRide)
                      ],
                    ),
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
