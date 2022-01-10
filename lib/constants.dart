import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:pool_your_car/size_config.dart';

const googleApiKey = 'AIzaSyCsh2LKtmVlhmQVDF-1jp3Ci6jWG_vUMzw';
// const ipaddress = "192.168.10.7";
// const myip = "http://$ipaddress:3000"; //mine http for running locally in pc

const myip = "https://poolyourcarfypbackend.herokuapp.com"; //ar internet ip

//const myip = "poolyourcar.herokuapp.com"; jude heroku ip
bool isUserBlocked = false;
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kNewPassNullError = "Please Enter your new password";
const String kReEnterNewPassNullError = "Please Re-Enter your new password";
const String kShortPassError = "Password is too short";
const String kShortNewPassError = "New Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kPickupAddressNullError = "Please Enter your pick-up address";
const String kDropAddressNullError = "Please Enter your drop address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

CherryToast cherryToastError(String body, BuildContext context) {
  return CherryToast.error(
    toastDuration: Duration(seconds: 3),
    title: "",
    enableIconAnimation: true,
    displayTitle: false,
    description: body,
    toastPosition: POSITION.BOTTOM,
    animationDuration: Duration(milliseconds: 1000),
    autoDismiss: true,
  ).show(context);
}

CherryToast cherryToastSuccess(String body, BuildContext context) {
  return CherryToast.success(
    toastDuration: Duration(seconds: 3),
    title: "",
    enableIconAnimation: true,
    displayTitle: false,
    description: body,
    toastPosition: POSITION.BOTTOM,
    animationDuration: Duration(milliseconds: 1000),
    autoDismiss: true,
  ).show(context);
}
