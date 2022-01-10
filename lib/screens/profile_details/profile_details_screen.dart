import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../constants.dart';

class ProfileDetailsScreen extends StatelessWidget {
final String sharedprefenrenceid;
  ProfileDetailsScreen({
    Key key,
    @required this.sharedprefenrenceid,
  }) : super(key: key);
  static String routeName = "/profile_details";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Profile Details"),
      ),
      body: Body(sharedprefenrenceid: this.sharedprefenrenceid,),
    );
  }
}
