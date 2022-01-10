// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/helper/keyboard.dart';
import 'package:pool_your_car/screens/forgot_password/forgot_password_screen.dart';
import 'package:pool_your_car/screens/login_success/login_success_screen.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../models/SigninResponseModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cherry_toast/cherry_toast.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

SiginResponseModel loginuser;

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  String email;
  String password;
  bool remember = false;
  bool showPassword = false;
  final List<String> errors = [];
  @override
  void initState() {
    super.initState();
    gettingSharedPreference();
  }

  bool check = false;
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

  settingSharedPreference() async {
    print("In settingSharedPreference");
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    var valString = jsonEncode(loginuser.user.id);
    var valEmail = jsonEncode(loginuser.user.email);
    var alreadyVisited = await prefs.setString("user", valString);
    var setEmail = await emailprefs.setString("email", valEmail);
    print("id setting in shared prefernce");
    // String _res = prefs.getString("user");

    // print("id in shared preference is " + json.decode(_res));

    // String jsonString = prefs.getString("user");
    // var _res2 = jsonDecode(jsonString);
    // print("_res2 is ");
    // print(_res2);
  }

  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    var _res = prefs.getString("user");
    String _email = emailprefs.getString("email");
    if (_res != null && _email != null) {
      print("id in shared preference is " + json.decode(_res));
      print("email in shared preference is " + json.decode(_email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Checkbox(
                //   value: remember,
                //   activeColor: kPrimaryColor,
                //   onChanged: (value) {
                //     setState(() {
                //       remember = value;
                //     });
                //   },
                // ),
                // Text(
                //   "Remember me",
                //   style: TextStyle(
                //     fontSize: 16,
                //   ),
                // ),
                // Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    ForgotPasswordScreen.routeName,
                  ),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
            FormError(errors: errors),
            SizedBox(height: getProportionateScreenHeight(20)),
            DefaultButton(
              text: "Continue",
              press: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  final String email = _emailcontroller.text;
                  final String password = _passwordcontroller.text;

                  KeyboardUtil.hideKeyboard(context);
                  Loader.show(
                    context,
                    isAppbarOverlay: true,
                    isBottomBarOverlay: true,
                    progressIndicator: CircularProgressIndicator(
                      // backgroundColor: kPrimaryColor,
                      color: kPrimaryColor,
                    ),
                    themeData:
                        Theme.of(context).copyWith(accentColor: Colors.green),
                    overlayColor: Color(0x99E8EAF6),
                  );
                  // await Future.delayed(Duration(seconds: 3), () {
                  //   Loader.hide();
                  // });

                  // ignore: missing_return
                  Future<SiginResponseModel> login(
                      String email, String password) async {
                    // print(email);
                    // print(password);
                    final String apiUrl = "$myip/api/user/login";
                    var body = jsonEncode({
                      "email": email,
                      "password": password,
                    });
                    final response = await http.post(Uri.parse(apiUrl),
                        headers: {"Content-Type": "application/json"},
                        body: body);
                    print("starting loader");
                    Loader.hide();
                    if (response.statusCode == 200) {
                      setState(() {
                        check = true;
                      });

                      if (json.decode(response.body)['blocked'] == 'blocked') {
                        isUserBlocked = true;
                      }

                      print("check  is true");
                      if (check) {
                        Navigator.pushNamed(
                            context, LoginSuccessScreen.routeName);
                      }
                      // Fluttertoast.showToast(
                      //   msg: "Sign in Successfull",
                      //   toastLength: Toast.LENGTH_LONG,
                      //   gravity: ToastGravity.SNACKBAR,
                      //   backgroundColor: kPrimaryColor,
                      //   textColor: Colors.white,
                      //   fontSize: 20.0,
                      // );
                      CherryToast.success(
                        toastDuration: Duration(seconds: 2),
                        title: "",
                        enableIconAnimation: false,
                        displayTitle: false,
                        description: "Sign in Successfull",
                        toastPosition: POSITION.BOTTOM,
                        animationDuration: Duration(milliseconds: 500),
                        autoDismiss: true,
                      ).show(context);

                      final String responseString = response.body;
                      // final SiginResponseModel resstring =
                      //     siginResponseModelFromJson(responseString);

                      // setState(() {
                      //   loginuser = resstring;
                      // });

                      return siginResponseModelFromJson(responseString);
                    } else {
                      print(response.body.toString());
                      // Fluttertoast.showToast(
                      //   msg: response.body.toString(),
                      //   toastLength: Toast.LENGTH_LONG,
                      //   gravity: ToastGravity.SNACKBAR,
                      //   backgroundColor: kPrimaryColor,
                      //   textColor: Colors.white,
                      //   fontSize: 20.0,
                      // );
                      CherryToast.error(
                        toastDuration: Duration(seconds: 5),
                        title: "",
                        enableIconAnimation: true,
                        displayTitle: false,
                        description: response.body.toString(),
                        toastPosition: POSITION.BOTTOM,
                        animationDuration: Duration(milliseconds: 1000),
                        autoDismiss: true,
                      ).show(context);
                    }
                    // });

                    // getVistingFlag() async {
                    //   print("In visiting flag");
                    //   Future<SharedPreferences> preferences =
                    //       SharedPreferences.getInstance();
                    //   final SharedPreferences prefs = await preferences;

                    //   var user = response.body;
                    //   // print(user.toString());
                    //   var valString = jsonEncode(user);

                    //   var alreadyVisited =
                    //       await prefs.setString("user", valString);
                    //   //print(alreadyVisited.toString());

                    //   String _res = prefs.getString("user");

                    //   print("shared preference is " + _res);

                    //   String jsonString = prefs.getString("user");
                    //   var _res2 = jsonDecode(jsonString);
                    //   print("_res2 is ");
                    //   print(_res2);
                    // }

                    // getVistingFlag();
                    // print("printing id");
                    // print("printing body.toString");
                    // print(response.body.toString());

                    //   Fluttertoast.showToast(
                    //     msg: "Sign in Successfull",
                    //     toastLength: Toast.LENGTH_LONG,
                    //     gravity: ToastGravity.SNACKBAR,
                    //     backgroundColor: kPrimaryColor,
                    //     textColor: Colors.white,
                    //     fontSize: 20.0,
                    //   );
                    //   final String responseString = response.body;
                    //   return siginResponseModelFromJson(responseString);
                    // } else {
                    //   print(response.body.toString());
                    //   Fluttertoast.showToast(
                    //     msg: response.body.toString(),
                    //     toastLength: Toast.LENGTH_LONG,
                    //     gravity: ToastGravity.SNACKBAR,
                    //     backgroundColor: kPrimaryColor,
                    //     textColor: Colors.white,
                    //     fontSize: 20.0,
                    //   );
                    // }
                  }

                  final SiginResponseModel _loginuser =
                      await login(email, password);

                  setState(() {
                    loginuser = _loginuser;
                  });

                  // print("id in loginuser " + loginuser.user.id);
                  // print("email in loginuser " + loginuser.user.email);
                  if (check) {
                    await settingSharedPreference();
                    gettingSharedPreference();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _passwordcontroller,
      obscureText: !showPassword,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
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
          //fontWeight: FontWeight.w700,
        ),
        hintText: "Enter your password",
        hintStyle: TextStyle(
          fontSize: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                this.showPassword = !this.showPassword;
              });
            },
            child: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg")),
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
          //fontWeight: FontWeight.w700,
        ),
        hintText: "Enter your email",
        hintStyle: TextStyle(
          fontSize: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
