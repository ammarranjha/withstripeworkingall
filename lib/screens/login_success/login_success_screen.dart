import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../constants.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kPrimaryColor),
          //leading: SizedBox(),
          title: Text("Login Success"),
        ),
        body: Body(),
      ),
    );
  }
}
