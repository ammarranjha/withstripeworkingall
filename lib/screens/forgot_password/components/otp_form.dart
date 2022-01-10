import 'package:flutter/material.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/helper/keyboard.dart';
import 'package:pool_your_car/screens/forgot_password/components/resetpassword_screen.dart';
import 'package:pool_your_car/screens/sign_in/sign_in_screen.dart';
import 'package:pool_your_car/screens/signup_success/signup_success_screen.dart';
import 'package:pool_your_car/size_config.dart';

import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  final String email;
  final String otp;
  const OtpForm({
    Key key,
    @required this.email,
    @required this.otp,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  String providedotp = '';
  String v1, v2, v3, v4 = '';

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
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  autofocus: true,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      v1 = value;
                    });
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      v2 = value;
                    });
                    nextField(value, pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      v3 = value;
                    });
                    nextField(value, pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      v4 = value;
                    });
                    if (value.length == 1) {
                      pin4FocusNode.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Continue",
            press: () async {
              // print("hello");
              // if (_formKey.currentState.validate()) {
              //   _formKey.currentState.save();
              // if all are valid then go to success screen
              KeyboardUtil.hideKeyboard(context);
              //sendOtpCode();
              if (v1 != "" && v2 != "" && v3 != "" && v4 != "") {
                setState(() {
                  providedotp = (v1 + v2 + v3 + v4).toString();
                });
                print("provied otp is " + providedotp);
                if (providedotp == widget.otp) {
                  print("Same");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ResetPasswordScreen(email: widget.email),
                    ),
                  );
                } else {
                  print("not matched");
                  cherryToastError("Invalid OTP Code", context);
                }
              } else {
                cherryToastError("Enter Otp Code", context);
              }
              // }
            },
          )
        ],
      ),
    );
  }
}
