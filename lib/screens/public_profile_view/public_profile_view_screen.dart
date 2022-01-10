import 'package:flutter/material.dart';
import 'package:pool_your_car/constants.dart';

import 'package:pool_your_car/screens/public_profile_view/components/body.dart';

class PublicProfileViewScreen extends StatelessWidget {
  final String userid;
  PublicProfileViewScreen({@required this.userid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Profile"),
      ),
      body: Body(userid: this.userid),
    );
  }
}
