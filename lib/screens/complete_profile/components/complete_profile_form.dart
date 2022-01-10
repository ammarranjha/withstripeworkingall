// ignore_for_file: missing_return

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/screens/home/home_screen.dart';
import 'package:pool_your_car/screens/otp/otp_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../models/SignupResponseModel.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

// bool check = false;
// Future<SigupResponseModel> createUser(
//     String firstname,
//     String lastname,
//     String phonenumber,
//     String email,
//     String password,
//     String confirmpassword) async {
//   print(email);
//   final String apiUrl = "http://$myip:3000/api/user/add";
//   var body = jsonEncode({
//     "firstname": firstname,
//     "lastname": lastname,
//     "phonenumber": phonenumber,
//     "email": email,
//     "password": password,
//     "confirmpassword": confirmpassword
//   });
//   final response = await http.post(apiUrl,
//       headers: {"Content-Type": "application/json"}, body: body);
//   if (response.statusCode == 200) {
//     check = true;

//     print(response.body.toString());
//     final String responseString = response.body;
//     return sigupResponseModelFromJson(responseString);
//   } else {
//     print(response.body.toString());
//     Fluttertoast.showToast(
//       msg: response.body.toString(),
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.SNACKBAR,
//       backgroundColor: kPrimaryColor,
//       textColor: Colors.white,
//       fontSize: 20.0,
//     );
//   }
// }

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  PhoneNumber phoneNumber;
  String address;
  String email;
  String password;
  // ignore: non_constant_identifier_names
  String confirm_password;
  String countrycode;
  String fullphonenumber;
  bool remember = false;
  final TextEditingController _firstnamecontroller =
      new TextEditingController();
  final TextEditingController _lastnamecontroller = new TextEditingController();
  final TextEditingController _phonenumbercontroller =
      new TextEditingController();
  final TextEditingController _emailcontroller = new TextEditingController();
  final TextEditingController _passwordcontroller = new TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      new TextEditingController();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildnewPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              print("firstname is " + _firstnamecontroller.text);
              print("lastname is " + _lastnamecontroller.text);
              print("phone is " + _phonenumbercontroller.text);
              print("email is " + _emailcontroller.text);
              print("pass is " + _passwordcontroller.text);
              print("confirmpass is " + _confirmpasswordcontroller.text);

              if (_formKey.currentState.validate()) {
                print("In the if statement");
                final String firstname = _firstnamecontroller.text;
                final String lastname = _lastnamecontroller.text;
                final String phonenumber = fullphonenumber;
                final String email = _emailcontroller.text;
                final String password = _passwordcontroller.text;
                final String confirmpassword = _confirmpasswordcontroller.text;
                bool check = false;
                Future<SigupResponseModel> createUser(
                    String firstname,
                    String lastname,
                    String phonenumber,
                    String email,
                    String password,
                    String confirmpassword) async {
                  print(email);
                  final String apiUrl = "$myip/api/user/add";
                  var body = jsonEncode({
                    "firstname": firstname,
                    "lastname": lastname,
                    "phonenumber": phonenumber,
                    "email": email,
                    "password": password,
                    "confirmpassword": confirmpassword
                  });
                  final response = await http.post(Uri.parse(apiUrl),
                      headers: {"Content-Type": "application/json"},
                      body: body);
                  print("starting loader");
                  Loader.show(
                    context,
                    isAppbarOverlay: true,
                    isBottomBarOverlay: true,
                    progressIndicator: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                    themeData: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.green)),
                    overlayColor: Color(0x99E8EAF6),
                  );
                  Future.delayed(
                    Duration(seconds: 5),
                    () {
                      Loader.hide();
                      if (response.statusCode == 200) {
                        check = true;

                        print(response.body.toString());
                        final String responseString = response.body;
                        Fluttertoast.showToast(
                          msg: "SignUp Successfull",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          fontSize: 20.0,
                        );
                        if (check) {
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        }
                        return sigupResponseModelFromJson(responseString);
                      } else {
                        print(response.body.toString());
                        Fluttertoast.showToast(
                          msg: response.body.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          fontSize: 20.0,
                        );
                      }
                    },
                  );
                }

                await createUser(firstname, lastname, phonenumber, email,
                    password, confirmpassword);
                // if (check) {
                //   print("check is true");
                //   print("New User Created");
                //   Navigator.pushNamed(context, OtpScreen.routeName);
                // }
              }
            },
          ),
        ],
      ),
    );
  }

  IntlPhoneField buildnewPhoneNumberFormField() {
    return IntlPhoneField(
      controller: _phonenumbercontroller,
      onSaved: (PhoneNumber newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.toString().isEmpty) {
          removeError(error: kPhoneNumberNullError);
        } else {
          // countrycode=value.countryCode,
          setState(() {
            fullphonenumber = value.completeNumber;
          });
          print("full phone number is");
          print(value.completeNumber);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: "Enter your phone number",
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
      initialCountryCode: 'PK',
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      controller: _lastnamecontroller,
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _emailcontroller,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _passwordcontroller,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      controller: _confirmpasswordcontroller,
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirm_password) {
          removeError(error: kMatchPassError);
        }
        confirm_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: _firstnamecontroller,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
