import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/models/ResetForgotPassword.dart';
import 'package:pool_your_car/screens/profile_details/components/edit_profile.dart';
import 'package:pool_your_car/screens/sign_in/sign_in_screen.dart';
import '../../../constants.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/components/default_button.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/UpdatePasswordResponseModel.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  static String routeName = "/resetpassword";
  ResetPasswordScreen({
    Key key,
    @required this.email,
  }) : super(key: key);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _confirmnewpasswordcontroller =
      new TextEditingController();
  TextEditingController _newpasswordcontroller = new TextEditingController();
  String confirm_new_password = '';

  String new_password = '';

  @override
  final List<String> errors = [];
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

  Future<ResetForgotPassword> resetPassword() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'PUT', Uri.parse('$myip/api/user/resetforgotpassword/${widget.email}'));
    request.body =
        json.encode({"password": this._newpasswordcontroller.value.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      cherryToastSuccess("Password Updated", context);
      Navigator.popUntil(context, ModalRoute.withName(SignInScreen.routeName));
    } else {
      print(response.reasonPhrase);
      cherryToastError("Unable to reset password", context);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Reset Password"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("Reset Password", style: headingStyle),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildNewPasswordFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildConfirmNewPassFormField(),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                  text: "Save",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      //Navigator.pushNamed(context, OtpScreen.routeName);
                      print("Alright");

                      // print(new_password);
                      // print(confirm_new_password);
                      print(_newpasswordcontroller.value.text);
                      await resetPassword();
                    }
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNewPasswordFormField() {
    return TextFormField(
      controller: _newpasswordcontroller,
      obscureText: false,
      onSaved: (newValue) => new_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNewPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortNewPassError);
        }
        new_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNewPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortNewPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "New Password",
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        hintText: "Enter new password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConfirmNewPassFormField() {
    return TextFormField(
      controller: _confirmnewpasswordcontroller,
      obscureText: false,
      onSaved: (newValue) => confirm_new_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kReEnterNewPassNullError);
        } else if (value.isNotEmpty && new_password == confirm_new_password) {
          removeError(error: kMatchPassError);
        } else if (value.isNotEmpty && value == new_password) {
          removeError(error: kMatchPassError);
        }
        confirm_new_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kReEnterNewPassNullError);
          return "";
        } else if ((new_password != value)) {
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
}
