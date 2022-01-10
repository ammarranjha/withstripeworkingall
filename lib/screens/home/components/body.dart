import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pool_your_car/components/notification_alert_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pool_your_car/models/GetUserOfferedRidesResponseModel.dart';
import 'package:pool_your_car/models/GetUserPastOfferedRidesResponseModel.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'past_rides_container.dart';
import 'your_rides_container.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String sharedprefenrenceid;
  bool offered = true;
  bool booked = false;
  bool pastoffered = true;
  bool pastbooked = false;
  bool isofferedridelistempty = false;
  bool isbookedridelistempty = false;
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

  bool isListNotEmpty(List a) {
    if (a.length != 0)
      return true;
    else
      return false;
  }

  bool offeredridelistempty = false;
  bool pastofferedridelistempty = false;
  List offeredRideList = [];
  List pastofferedRideList = [];

  bool bookedridelistempty = false;
  bool pastbookedridelistempty = false;
  List bookedRideList = [];
  List pastbookedRideList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // ignore: non_constant_identifier_names, missing_return
  Future<GetUserOfferedRidesResponseModel> getUserOfferedRides() async {
    //await gettingSharedPreference();
    final response = await http.get(Uri.parse(
        "$myip/api/ride/getallofferedridesofuser/${this.sharedprefenrenceid}"));
    if (response.statusCode == 200) {
      var _user = json.decode(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      // Loader.show(context,
      //     isAppbarOverlay: true,
      //     isBottomBarOverlay: true,
      //     progressIndicator: CircularProgressIndicator(
      //       backgroundColor: kPrimaryColor,
      //     ),
      //     themeData: Theme.of(context).copyWith(accentColor: Colors.green),
      //     overlayColor: Color(0x99E8EAF6));
      // await Future.delayed(Duration(seconds: 3), () {
      //   Loader.hide();
      // });
      setState(() {
        this.offeredRideList = responseJson['offeredride'];
        print(responseJson['offeredride']);
        if (this.offeredRideList.isEmpty) {
          this.isofferedridelistempty = true;
          ;
        }
      });
      print("Offered Rides");
      for (int i = 0; i < this.offeredRideList.length; i++) {
        print(i);
        Future<GetUserOfferedRidesResponseModel> getUserOfferedRides() async {
          //await gettingSharedPreference();
          final response = await http.get(Uri.parse(
              "$myip/api/ride/getallofferedridesofuser/${this.sharedprefenrenceid}"));
          if (response.statusCode == 200) {
            var _user = json.decode(response.body);
            Map<String, dynamic> responseJson = json.decode(response.body);
            // Loader.show(context,
            //     isAppbarOverlay: true,
            //     isBottomBarOverlay: true,
            //     progressIndicator: CircularProgressIndicator(
            //       backgroundColor: kPrimaryColor,
            //     ),
            //     themeData: Theme.of(context).copyWith(accentColor: Colors.green),
            //     overlayColor: Color(0x99E8EAF6));
            // await Future.delayed(Duration(seconds: 3), () {
            //   Loader.hide();
            // });
            setState(() {
              this.offeredRideList = responseJson['offeredride'];
              print(responseJson['offeredride']);
              if (this.offeredRideList.isEmpty) {
                this.isofferedridelistempty = true;
              }

              this.bookedRideList = responseJson['offeredride'];
              print(responseJson['offeredride']);
              if (this.bookedRideList.isEmpty) {
                this.isbookedridelistempty = true;
              }
            });
            print("Offered Rides");
            for (int i = 0; i < this.offeredRideList.length; i++) {
              print(i);
              print(this.offeredRideList[i]["_id"]);
            }

            return GetUserOfferedRidesResponseModel.fromJson(
                jsonDecode(response.body));
          } else {
            print(response.body.toString());
          }
        }

        print(this.offeredRideList[i]["_id"]);
      }

      return GetUserOfferedRidesResponseModel.fromJson(
          jsonDecode(response.body));
    } else {
      print(response.body.toString());
    }
  }

  Future<GetUserPastOfferedRidesResponseModel> getUserPastOfferedRides() async {
    //await gettingSharedPreference();
    final response = await http.get(Uri.parse(
        "$myip/api/ride/getallpastofferedridesofuser/${this.sharedprefenrenceid}"));
    if (response.statusCode == 200) {
      //var _user = json.decode(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      print("printing now respone");
      print(response.body);
      setState(() {
        this.pastofferedRideList = responseJson['pastofferedride'];
        print(responseJson['pastofferedride']);
        if (this.pastofferedRideList.isEmpty) {
          this.pastofferedridelistempty = true;
        }
      });
      print("passt Offered Rides");
      for (int i = 0; i < this.pastofferedRideList.length; i++) {
        //print("Ride id");
        print(this.pastofferedRideList[i]["_id"]);
      }

      return GetUserPastOfferedRidesResponseModel.fromJson(
          jsonDecode(response.body));
    } else {
      print(response.body.toString());
    }
  }

  Future<void> getUserBookedRides() async {
    //await gettingSharedPreference();
    final response = await http.get(Uri.parse(
        "$myip/api/ride/getallbookedridesofuser/${this.sharedprefenrenceid}"));
    if (response.statusCode == 200) {
      var _user = json.decode(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      setState(() {
        this.bookedRideList = responseJson['bookedride'];
        print(responseJson['bookedride']);
        if (this.bookedRideList.isEmpty) {
          this.isbookedridelistempty = true;
        }
      });
      print("Booked Rides");
      for (int i = 0; i < this.bookedRideList.length; i++) {
        print(i);
        print(this.bookedRideList[i]);
      }

      // return GetUserOfferedRidesResponseModel.fromJson(
      //     jsonDecode(response.body));
    } else {
      print(response.body.toString());
    }
  }

  Future<void> callfunctions() async {
    await gettingSharedPreference();
    await getUserOfferedRides();
    await getUserPastOfferedRides();
    await getUserBookedRides();
    isListNotEmpty(this.pastofferedRideList);
    _refreshController.refreshCompleted();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    //Shared preference is called in GetUserOfferedRides function
    // GetUserOfferedRides();
    // GetUserPastOfferedRides();
    callfunctions();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: callfunctions,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            //backgroundColor: Colors.white,
            appBar: new AppBar(
              iconTheme: IconThemeData(color: kPrimaryColor),
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicatorColor: kPrimaryColor,
                tabs: [
                  Text(
                    'Your Rides',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Past Rides',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              title: new Text("Home"),
              actions: [NotificationAlertButton()],
            ),

            body: TabBarView(
              children: [
                //Your Rides
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(18)),
                      //HomeHeader(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              //width: double.infinity,
                              width: 130,
                              height: getProportionateScreenHeight(50),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  backgroundColor: offered
                                      ? kPrimaryColor
                                      : Colors.grey.shade200,
                                ),
                                onPressed: () {
                                  setState(() {
                                    offered = !offered;
                                    booked = !booked;
                                  });
                                },
                                child: Text(
                                  "Offered",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    color:
                                        offered ? Colors.white : kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              //width: double.infinity,
                              width: 130,
                              height: getProportionateScreenHeight(50),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: booked
                                    ? kPrimaryColor
                                    : Colors.grey.shade200,
                                onPressed: () {
                                  setState(() {
                                    offered = !offered;
                                    booked = !booked;
                                  });
                                },
                                child: Text(
                                  "Booked",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    color:
                                        booked ? Colors.white : kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(18)),
                      // YourRidesContainer(
                      //   time: DateFormat('hh:mm:a').format(DateTime.now().add(Duration(hours:9, minutes: 55))),
                      //   day: DateFormat('EEE, d LLLL y').format(DateTime.now()),
                      //   fromlocation:
                      //       "Street# 5, Muslim Town, Rawalpindi, Pakistan",
                      //   tolocation:
                      //       "COMSATS University Islamabad, Park Road, Islamabad, Pakistan",
                      //   ridetype: "booked",
                      //   drivername: "Abdul Rehman",
                      //   //image: "assets/images/Profile Image.png",
                      //   cashamount: 20,
                      //   carType: "Mini Car",
                      //   bookedseats: 1,
                      //   discount: 20,
                      //   discription: "No Smoking",
                      //   //image: "assets/images/Profile Image.png",
                      // ),

                      if (offered == true)
                        Expanded(
                          child: Container(
                            child: !isofferedridelistempty
                                ? ListView.builder(
                                    itemCount: this.offeredRideList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return YourRidesContainer(
                                        rideid: this.offeredRideList[index]
                                            ["_id"],
                                        // time: DateFormat('hh:mm:a').format(DateTime.now()
                                        //     .add(Duration(hours: 9, minutes: 55))),
                                        time: this.offeredRideList[index]
                                            ["time"],
                                        // day: DateFormat('EEE, d LLLL y')
                                        //     .format(DateTime.now()),
                                        day: this.offeredRideList[index]
                                            ["date"],
                                        fromlocation:
                                            this.offeredRideList[index]
                                                ["pickuplocation"],
                                        tolocation: this.offeredRideList[index]
                                            ['droplocation'],
                                        ridetype: "offered",
                                        carType: this.offeredRideList[index]
                                            ["cartype"],
                                        carName: this.offeredRideList[index]
                                            ["car_name"],
                                        carManufactureYear:
                                            this.offeredRideList[index]
                                                ["car_manufacture_year"],
                                        carRegNumber:
                                            this.offeredRideList[index]
                                                ["car_registration_number"],
                                        discount: this.offeredRideList[index]
                                            ["discount"],
                                        offeredseats:
                                            this.offeredRideList[index]
                                                ["offeredseats"],
                                        availableseats:
                                            this.offeredRideList[index]
                                                ["availableseats"],
                                        drivername: "Abdul Rehman",
                                        discription: this.offeredRideList[index]
                                            ["optional_details"],
                                        ridefare: this.offeredRideList[index]
                                            ["ridefare"],
                                      );
                                    })
                                : Center(
                                    child: Text(
                                      "No Offered rides to show",
                                      style: TextStyle(
                                        //color: Colors.black,
                                        fontSize:
                                            getProportionateScreenWidth(20),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                        )
                      else
                        Expanded(
                          child: Container(
                            child: !isbookedridelistempty
                                ? ListView.builder(
                                    itemCount: this.bookedRideList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return YourRidesContainer(
                                        rideid: this.bookedRideList[index]
                                            ["_id"],
                                        // time: DateFormat('hh:mm:a').format(DateTime.now()
                                        //     .add(Duration(hours: 9, minutes: 55))),
                                        time: this.bookedRideList[index]
                                            ["time"],
                                        // day: DateFormat('EEE, d LLLL y')
                                        //     .format(DateTime.now()),
                                        day: this.bookedRideList[index]["date"],
                                        fromlocation: this.bookedRideList[index]
                                            ["pickuplocation"],
                                        tolocation: this.bookedRideList[index]
                                            ['droplocation'],
                                        ridetype: "booked",
                                        carType: this.bookedRideList[index]
                                            ["cartype"],
                                        carName: this.bookedRideList[index]
                                            ["car_name"],
                                        carManufactureYear:
                                            this.bookedRideList[index]
                                                ["car_manufacture_year"],
                                        carRegNumber: this.bookedRideList[index]
                                            ["car_registration_number"],
                                        discount: this.bookedRideList[index]
                                            ["discount"],
                                        offeredseats: this.bookedRideList[index]
                                            ["offeredseats"],
                                        availableseats:
                                            this.bookedRideList[index]
                                                ["availableseats"],
                                        drivername: "Abdul Rehman",
                                        discription: this.bookedRideList[index]
                                            ["optional_details"],
                                        ridefare: this.bookedRideList[index]
                                            ["ridefare"],
                                        isAccepted: (this.bookedRideList[index]
                                                    ["passengersID"] as List)
                                                .contains(sharedprefenrenceid)
                                            ? "Booked"
                                            : "Pending",
                                      );
                                    })
                                : Center(
                                    child: Text(
                                      "No Booked rides to show",
                                      style: TextStyle(
                                        //color: Colors.black,
                                        fontSize:
                                            getProportionateScreenWidth(20),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                        )
                    ],
                  ),
                ),
                //Past Rides

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(18)),
                      //HomeHeader(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              //width: double.infinity,
                              //width: 130,
                              height: getProportionateScreenHeight(50),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: pastoffered
                                    ? kPrimaryColor
                                    : Colors.grey.shade200,
                                onPressed: () {
                                  setState(() {
                                    pastoffered = !pastoffered;
                                    pastbooked = !pastbooked;
                                  });
                                },
                                child: Text(
                                  "Past Offered",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    color: pastoffered
                                        ? Colors.white
                                        : kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              //width: double.infinity,
                              //width: 130,
                              height: getProportionateScreenHeight(50),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                color: pastbooked
                                    ? kPrimaryColor
                                    : Colors.grey.shade200,
                                onPressed: () {
                                  setState(() {
                                    pastoffered = !pastoffered;
                                    pastbooked = !pastbooked;
                                  });
                                },
                                child: Text(
                                  "Past Booked",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(18),
                                    color: pastbooked
                                        ? Colors.white
                                        : kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (pastoffered == true)
                        Expanded(
                          child: Container(
                            child: !this.pastofferedridelistempty
                                ? ListView.builder(
                                    itemCount: this.pastofferedRideList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return PastRidesContainer(
                                          rideid: this.pastofferedRideList[index]
                                              ["_id"],
                                          // time: DateFormat('hh:mm:a').format(DateTime.now()
                                          //     .add(Duration(hours: 9, minutes: 55))),
                                          time: this.pastofferedRideList[index]
                                              ["time"],
                                          // day: DateFormat('EEE, d LLLL y')
                                          //     .format(DateTime.now()),
                                          day: this.pastofferedRideList[index]
                                              ["date"],
                                          fromlocation:
                                              this.pastofferedRideList[index]
                                                  ["pickuplocation"],
                                          tolocation: this.pastofferedRideList[index]
                                              ['droplocation'],
                                          ridetype: this.pastofferedRideList[index]
                                              ['ride_type'],
                                          carType: this.pastofferedRideList[index]
                                              ["cartype"],
                                          discount: this.pastofferedRideList[index]
                                              ["discount"],
                                          offeredseats:
                                              this.pastofferedRideList[index]
                                                  ["offeredseats"],
                                          bookedseats: this.pastofferedRideList[index]
                                              ["offeredseats"],
                                          discription: this.pastofferedRideList[index]
                                              ["optional_details"],
                                          ridefare: this.pastofferedRideList[index]
                                              ["ridefare"]);
                                    })
                                : Center(
                                    child: Text(
                                      "No past offered rides to show",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            getProportionateScreenWidth(20),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
