import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class RemainingEditRideScreen extends StatefulWidget {
  const RemainingEditRideScreen({Key key}) : super(key: key);

  @override
  _RemainingEditRideScreenState createState() =>
      _RemainingEditRideScreenState();
}

class _RemainingEditRideScreenState extends State<RemainingEditRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text(
          "Edit Ride",
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
