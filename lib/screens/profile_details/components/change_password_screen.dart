import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/screens/profile_details/components/edit_profile.dart';
import '../../../constants.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/components/default_button.dart';
import '../../../size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/UpdatePasswordResponseModel.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String id;
  ChangePasswordScreen({
    Key key,
    @required this.id,
  }) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentpasswordcontroller =
      new TextEditingController();
  TextEditingController _confirmnewpasswordcontroller =
      new TextEditingController();
  TextEditingController _newpasswordcontroller = new TextEditingController();
  String confirm_new_password;
  String currentpassword;
  String new_password;
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Change Password"),
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
                Text("Change Password", style: headingStyle),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildCurrentPasswordFormField(),
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
                        print(currentpassword);
                        print(new_password);
                        print(confirm_new_password);
                        Future<UpdatePasswordResponseModel>
                            // ignore: missing_return
                            updatePassword() async {
                          final response = await http.put(
                            Uri.parse("$myip/api/user/updatepassword/$userid"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'currentpassword': currentpassword,
                              'password': new_password,
                            }),
                          );
                          print("starting loader");
                          Loader.show(
                            context,
                            isAppbarOverlay: true,
                            isBottomBarOverlay: true,
                            progressIndicator: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                            themeData: Theme.of(context)
                                .copyWith(accentColor: Colors.green),
                            overlayColor: Color(0x99E8EAF6),
                          );
                          Future.delayed(Duration(seconds: 5), () {
                            Loader.hide();

                            if (response.statusCode == 200) {
                              print("response 200");
                              print(response.body);
                              Fluttertoast.showToast(
                                msg: "Password Updated Successfull",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 20.0,
                              );

                              return UpdatePasswordResponseModel.fromJson(
                                  jsonDecode(response.body));
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
                          });
                        }

                        print("calling update method");
                        await updatePassword();
                      }
                    }),
                SizedBox(height: getProportionateScreenHeight(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildCurrentPasswordFormField() {
    return TextFormField(
      controller: _currentpasswordcontroller,
      obscureText: true,
      onSaved: (newValue) => currentpassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        currentpassword = value;
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
        labelText: "Current Password",
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        hintText: "Enter current password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
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
