import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/helper/keyboard.dart';
import 'package:pool_your_car/models/ChangeEmailResponseModel.dart';
import 'package:pool_your_car/models/SendEmailOTPResponseModel.dart';
import 'package:pool_your_car/screens/profile/profile_screen.dart';
import 'package:pool_your_car/screens/signup_success/signup_success_screen.dart';
import 'package:pool_your_car/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class EmailOtpForm extends StatefulWidget {
  final String email;
  const EmailOtpForm({
    Key key,
    @required this.email,
  }) : super(key: key);

  @override
  _EmailOtpFormState createState() => _EmailOtpFormState();
}

class _EmailOtpFormState extends State<EmailOtpForm> {
  Map<String, dynamic> responsemap;
  final _formKey = GlobalKey<FormState>();
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  String providedotp = '';
  String v1, v2, v3, v4 = '';
  String otpcode = '';
  String sharedprefenrenceid;

  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    // print("In home screen");
    // print("User id in shared preference is " + json.decode(userid));
    // print("user email in shared preference is " + json.decode(_email));
    setState(() {
      sharedprefenrenceid = json.decode(userid);
    });
    //GetUserDetails();
  }

  settingSharedPreference() async {
    print("In settingSharedPreference");
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    var valEmail = jsonEncode(widget.email);
    var setEmail = await emailprefs.setString("email", valEmail);
    print("email setting in shared prefernce");
  }

  Future<SendEmailOtpResponseModel> sendOtpCode() async {
    // Loader.show(
    //   context,
    //   isAppbarOverlay: true,
    //   isBottomBarOverlay: true,
    //   progressIndicator: CircularProgressIndicator(
    //     // backgroundColor: kPrimaryColor,
    //     color: kPrimaryColor,
    //   ),
    //   themeData: Theme.of(context).copyWith(accentColor: Colors.green),
    //   overlayColor: Color(0x99E8EAF6),
    // );

    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('$myip/api/user/sendemailotp'));
    request.body = json.encode({
      "email": this.widget.email,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Loader.hide();
    if (response.statusCode == 200) {
      var _response = await http.Response.fromStream(response);
      //print(await response.stream.bytesToString());
      setState(() {
        responsemap = jsonDecode(_response.body);
        otpcode = responsemap['otp'].toString();
      });
      print("Printing otp");
      print(responsemap['otp']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<ChangeEmailResponseModel> changeEmail() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: CircularProgressIndicator(
        // backgroundColor: kPrimaryColor,
        color: kPrimaryColor,
      ),
      themeData: Theme.of(context).copyWith(accentColor: Colors.green),
      overlayColor: Color(0x99E8EAF6),
    );
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PUT',
        Uri.parse('$myip/api/user/changeemail/${this.sharedprefenrenceid}'));
    request.body = json.encode({"newemail": widget.email});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    Loader.hide();

    if (response.statusCode == 200) {
      var _response = await http.Response.fromStream(response);
      print(jsonDecode(_response.body));
      cherryToastSuccess("Email Updated", context);
      await settingSharedPreference();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ProfileScreen(),
      //   ),
      // );
      Navigator.popUntil(context, ModalRoute.withName(ProfileScreen.routeName));
      //print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      cherryToastError("Unable to update", context);
    }
  }

  callfunction() async {
    await sendOtpCode();
    await gettingSharedPreference();
  }

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    callfunction();
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
      key: _formKey,
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
                if (providedotp == otpcode) {
                  print("Same");
                  await changeEmail();
                } else {
                  print("not matched");
                  cherryToastError("Invalid OTP Code", context);
                }
              } else {
                cherryToastError("Enter Otp Code", context);
              }
              // }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          // GestureDetector(
          //   onTap: () {
          //     // OTP code resend
          //     //sendOtpCode();
          //   },
          //   child: Text(
          //     "Resend OTP Code",
          //     style: TextStyle(
          //       decoration: TextDecoration.underline,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
