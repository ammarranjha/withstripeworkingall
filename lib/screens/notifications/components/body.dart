import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/screens/notifications/components/notification_container.dart';
import 'package:pool_your_car/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String sharedprefenrenceid;
  List notifications;
  bool isNotificationEmpty = true;

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
    final response = await http.get(Uri.parse(
        "$myip/api/ride/getallpastofferedridesofuser/${this.sharedprefenrenceid}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      setState(() {
        this.notifications = responseJson['notifications'];
        print(responseJson['notifications']);
        if (this.notifications.isNotEmpty) {
          this.isNotificationEmpty = false;
        }
      });
      print("Notifications");
    } else {
      print(response.body.toString());
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: getProportionateScreenWidth(20),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: !isNotificationEmpty
                    ? ListView.builder(
                        itemCount: this.notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return NotificationContainer(
                            passengerID: this.notifications[index]['senderID'],
                            type: this.notifications[index]['type'],
                            dropLocation: this.notifications[index]['from'],
                            pickUpLocation: this.notifications[index]['to'],
                            ride: this.notifications[index]['ride'],
                            message: this.notifications[index]['message'],
                            read: this.notifications[index]['read'],
                          );
                        })
                    : Center(
                        child: Text(
                          "No Notifications to show",
                          style: TextStyle(
                            //color: Colors.black,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
