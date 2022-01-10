import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pool_your_car/screens/notifications/notification_screen.dart';
import 'package:pool_your_car/screens/home/home_screen.dart';
import 'package:pool_your_car/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationContainer extends StatefulWidget {
  const NotificationContainer(
      {Key key,
      this.type,
      this.message,
      this.ride,
      this.read,
      this.passengerID,
      this.pickUpLocation,
      this.dropLocation,
      this.firstname})
      : super(key: key);

  final String passengerID;
  final String type;
  final String message;
  final String ride;
  final String pickUpLocation;
  final String dropLocation;
  final firstname;
  final bool read;

  @override
  State<NotificationContainer> createState() => _NotificationContainerState();
}

class _NotificationContainerState extends State<NotificationContainer> {
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

  Future<void> _accept(id) async {
    print(sharedprefenrenceid);

    String apiUrl;
    var body;

    if (this.widget.type == 'bookrequest') {
      apiUrl = "$myip/api/ride/acceptbookedride";
      body = jsonEncode({
        'rideId': this.widget.ride,
        'passengerID': id,
        'userId': sharedprefenrenceid
      });
    } else if (this.widget.type == 'startaccepted') {
      apiUrl = "$myip/api/ride/cancelnotification";
      body = jsonEncode({
        'rideId': this.widget.ride,
        'passengerID': id,
        'userId': sharedprefenrenceid
      });
    } else {
      apiUrl = "$myip/api/ride/acceptstartride";
      body = jsonEncode({
        'rideId': this.widget.ride,
        'passengerID': id,
        'userId': sharedprefenrenceid
      });
    }

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"}, body: body);
    print("starting loader");

    if (response.statusCode == 200) {
      Navigator.popAndPushNamed(context, NotificationsScreen.routeName);
    }
  }

  Future<void> _decline(id) async {
    String apiUrl;
    var body;
    if (this.widget.type == 'bookrequest') {
      apiUrl = "$myip/api/ride/rejectbookedride";
      body = jsonEncode({
        'rideId': this.widget.ride,
        'passengerID': id,
        'userId': sharedprefenrenceid
      });
    } else if (this.widget.type == 'startaccepted') {
      apiUrl = "$myip/api/ride/cancelnotification";
      body = jsonEncode({
        'rideId': this.widget.ride,
        'passengerID': id,
        'userId': sharedprefenrenceid
      });
    } else {
      apiUrl = "$myip/api/ride/cancelstartride";
      body = jsonEncode({
        'rideId': this.widget.ride,
        'passengerID': id,
        'userId': sharedprefenrenceid
      });
    }

    final response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"}, body: body);
    print("starting loader");

    if (response.statusCode == 200) {
      Navigator.popAndPushNamed(context, NotificationsScreen.routeName);
    }
  }

  Future<void> callfunctions() async {
    await gettingSharedPreference();
  }

  @override
  void initState() {
    callfunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        margin:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
        child: Column(children: [
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
                  spreadRadius: 4,
                  blurRadius: 3,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            // height: getProportionateScreenHeight(200),
            width: getProportionateScreenWidth(250),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(10)),
              child: Column(
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(20),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    "${this.widget.message}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(16),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Row(
                    children: [
                      Text(
                        "From :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(12),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${this.widget.pickUpLocation}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
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
                          "To:     ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${this.widget.dropLocation},",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
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
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        color: kPrimaryColor,
                        onPressed: () {
                          _accept(this.widget.passengerID);
                        },
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      if (this.widget.type != 'startaccepted')
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: kPrimaryColor,
                          ),
                          onPressed: () {
                            _decline(this.widget.passengerID);
                          },
                          child: Text(
                            "Decline",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
