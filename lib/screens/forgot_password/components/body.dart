import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/components/no_account_text.dart';
import 'package:pool_your_car/models/CheckEmailExistAndSendOTP.dart';
import 'package:pool_your_car/screens/forgot_password/components/otpscreen.dart';
import 'package:pool_your_car/size_config.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  String otp = '';
  Map<String, dynamic> resMap;
  TextEditingController _emailController = new TextEditingController();

  Future<CheckEmailExistAndSendOtp> sendOtp() async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '$myip/api/user/checkemailexistsandsendotp/${_emailController.value.text}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var _response = await http.Response.fromStream(response);
      print(jsonDecode(_response.body));
      setState(() {
        resMap = jsonDecode(_response.body);
      });
      print(resMap['message']);
      if (resMap['message'] == 'Email doesnot exists') {
        cherryToastError("Email doesnot exists", context);
      } else {
        setState(() {
          this.otp = resMap['otp'].toString();
        });
        print(otp);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeEmailOtpForm(
              email: _emailController.value.text,
              otp: this.otp,
            ),
          ),
        );
      }
      //print(await response.stream.bytesToString());

    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              //ForgotPassForm(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (newValue) => email = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            errors.contains(kEmailNullError)) {
                          setState(() {
                            errors.remove(kEmailNullError);
                          });
                        } else if (emailValidatorRegExp.hasMatch(value) &&
                            errors.contains(kInvalidEmailError)) {
                          setState(() {
                            errors.remove(kInvalidEmailError);
                          });
                        }
                        return null;
                      },
                      validator: (value) {
                        if (value.isEmpty &&
                            !errors.contains(kEmailNullError)) {
                          setState(() {
                            errors.add(kEmailNullError);
                          });
                        } else if (!emailValidatorRegExp.hasMatch(value) &&
                            !errors.contains(kInvalidEmailError)) {
                          setState(() {
                            errors.add(kInvalidEmailError);
                          });
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email",
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon:
                            CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    FormError(errors: errors),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    DefaultButton(
                      text: "Continue",
                      press: () {
                        if (_formKey.currentState.validate()) {
                          print(_emailController.value.text);
                          // Do what you want to do
                          sendOtp();
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    NoAccountText(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
