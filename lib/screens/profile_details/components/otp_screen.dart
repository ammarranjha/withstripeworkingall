import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:pool_your_car/models/SendEmailOTPResponseModel.dart';
import 'package:pool_your_car/screens/profile_details/components/email_otp_form.dart';
import 'package:pool_your_car/size_config.dart';

import '../../../constants.dart';

class MyOtpScreen extends StatefulWidget {
  //static String routeName = "/otp";
  final String email;

  const MyOtpScreen({
    Key key,
    @required this.email,
  }) : super(key: key);

  @override
  State<MyOtpScreen> createState() => _MyOtpScreenState();
}

class _MyOtpScreenState extends State<MyOtpScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                Text("We sent code to your new email"),
                //buildTimer(),
                EmailOtpForm(
                  email: widget.email,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: Duration(seconds: 60),
          builder: (_, value, child) => Text(
            "00:${value.toInt()}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
