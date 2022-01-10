import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pool_your_car/screens/profile_details/profile_details_screen.dart';
import 'package:pool_your_car/screens/profile_details/profile_details_screen.dart';
import 'package:pool_your_car/screens/wallet/wallet_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Admin_Email extends StatefulWidget {
  const Admin_Email({Key key}) : super(key: key);

  @override
  _Admin_EmailState createState() => _Admin_EmailState();
}

class _Admin_EmailState extends State<Admin_Email> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            SizedBox(
                child: Text(
              'In case of any query',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            )),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              child: Text('Please contact admin on the provided email',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  child: Text('admin@mail.com'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
