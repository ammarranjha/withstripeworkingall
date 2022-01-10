import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pool_your_car/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationAlertButton extends StatefulWidget {
  const NotificationAlertButton({Key key}) : super(key: key);

  @override
  _NotificationAlertButtonState createState() =>
      _NotificationAlertButtonState();
}

class _NotificationAlertButtonState extends State<NotificationAlertButton> {
  String sharedprefenrenceid;
  int notification = 0;

  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    String userid = prefs.getString("user");
    sharedprefenrenceid = json.decode(userid);

    //GetUserDetails();
  }

  Future<void> getNotifications() async {
    //await gettingSharedPreference();
    print("getting notifications");
    http
        .get(Uri.parse(
            "$myip/api/ride/getallpastofferedridesofuser/${this.sharedprefenrenceid}"))
        .asStream()
        .asBroadcastStream()
        .listen((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        setState(() {
          this.notification = (responseJson['notifications'] as List).length;
        });
      }
    });
  }

  Future<void> callfunctions() async {
    await gettingSharedPreference();
    await getNotifications();
  }

  @override
  void initState() {
    super.initState();
    callfunctions();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/notifications");
      },
      child: SizedBox(
          height: 40,
          width: 40,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 5,
                right: 7,
                child: SizedBox(
                    height: 35,
                    width: 35,
                    child: SvgPicture.asset('assets/icons/Bell.svg')),
              ),
              Positioned(
                  right: 5,
                  top: 0,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(
                          '${notification}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        )),
                  ))
            ],
          )),
    );
  }
}
