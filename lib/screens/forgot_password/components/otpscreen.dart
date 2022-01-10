import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/helper/keyboard.dart';
import 'package:pool_your_car/models/ChangeEmailResponseModel.dart';
import 'package:pool_your_car/models/SendEmailOTPResponseModel.dart';
import 'package:pool_your_car/screens/forgot_password/components/otp_form.dart';
import 'package:pool_your_car/screens/profile/profile_screen.dart';
import 'package:pool_your_car/screens/signup_success/signup_success_screen.dart';
import 'package:pool_your_car/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class ChangeEmailOtpForm extends StatefulWidget {
  final String email;
  final String otp;
  const ChangeEmailOtpForm({
    Key key,
    @required this.email,
    @required this.otp,
  }) : super(key: key);

  @override
  _ChangeEmailOtpFormState createState() => _ChangeEmailOtpFormState();
}

class _ChangeEmailOtpFormState extends State<ChangeEmailOtpForm> {
  Map<String, dynamic> responsemap;
  final _formKey = GlobalKey<FormState>();
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  String providedotp = '';
  String v1, v2, v3, v4 = '';
  String otpcode = '';
  String sharedprefenrenceid;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("OTP Verification"),
          iconTheme: IconThemeData(color: kPrimaryColor),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Text(
                    "OTP Verification",
                    style: headingStyle,
                  ),
                  Text("We sent your code to phone number"),
                  // buildTimer(),
                  OtpForm(
                    email: widget.email,
                    otp: widget.otp,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                  // GestureDetector(
                  //   onTap: () {
                  //     // OTP code resend
                  //   },
                  //   child: Text(
                  //     "Resend OTP Code",
                  //     style: TextStyle(decoration: TextDecoration.underline),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}
