import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/body.dart';

class HelpCenterScreen extends StatelessWidget {
  static String routeName = "/help_center";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Help Center"),
      ),
      body: Body(),
    );
  }
}
