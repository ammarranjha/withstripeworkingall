// ignore_for_file: missing_return

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:pool_your_car/models/UpdateUserResponseModel.dart';
import '../../../constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/components/default_button.dart';
import '../../../size_config.dart';
import 'change_password_screen.dart';

//import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../../profile/profile_screen.dart';
import 'change_email.dart';
import 'change_phonenumber_screen.dart';

class EditProfile extends StatefulWidget {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String password;

  EditProfile({
    Key key,
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.phoneNumber,
    @required this.password,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

String userid;
// Future<UpdateUserResponseModel> updateUser(String fn, String ln) async {
//   if (fn != "" && ln != "") {
//     final response = await http.put(
//       Uri.parse("$myip/api/user/edituser/$userid"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'firstname': fn,
//         'lastname': ln,
//       }),
//     );
//     print("fn is :" + fn);

//     if (response.statusCode == 200) {
//       print("response 200");
//       print(response.body);
//       Fluttertoast.showToast(
//         msg: "Profile edited Successfull",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.SNACKBAR,
//         backgroundColor: kPrimaryColor,
//         textColor: Colors.white,
//         fontSize: 20.0,
//       );
//       return UpdateUserResponseModel.fromJson(jsonDecode(response.body));
//     } else {
//       print(response.body);
//     }
//   }

//   /////////
//   else if (fn != "") {
//     final response = await http.put(
//       Uri.parse("$myip/api/user/edituser/$userid"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'firstname': fn,
//       }),
//     );
//     print("fn is :" + fn);

//     if (response.statusCode == 200) {
//       print("response 200");
//       print(response.body);
//       Fluttertoast.showToast(
//         msg: "Profile edited Successfull",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.SNACKBAR,
//         backgroundColor: kPrimaryColor,
//         textColor: Colors.white,
//         fontSize: 20.0,
//       );
//       return UpdateUserResponseModel.fromJson(jsonDecode(response.body));
//     } else {
//       print(response.body);
//     }
//   } else if (ln != "") {
//     final response = await http.put(
//       Uri.parse("$myip/api/user/edituser/$userid"),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'lastname': ln,
//       }),
//     );
//     print("ln is :" + ln);

//     if (response.statusCode == 200) {
//       print("response 200");
//       print(response.body);
//       Fluttertoast.showToast(
//         msg: "Profile edited Successfull",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.SNACKBAR,
//         backgroundColor: kPrimaryColor,
//         textColor: Colors.white,
//         fontSize: 20.0,
//       );
//       return UpdateUserResponseModel.fromJson(jsonDecode(response.body));
//     } else {
//       print(response.body);
//     }
//   } else {
//     Fluttertoast.showToast(
//       msg: "Please update any name",
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.SNACKBAR,
//       backgroundColor: kPrimaryColor,
//       textColor: Colors.white,
//       fontSize: 20.0,
//     );
//   }
// }

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  String propsid, propsfirstname, propslastname, propsemail, propspassword;
  TextEditingController firstnamecontroller = new TextEditingController();
  TextEditingController lastnamecontroller = new TextEditingController();
  String _updatedfirstName = '';
  String _updatedlastName = '';
  //String _updatedpassword;
  // PhoneNumber _updatedphoneNumber;

  // String _email;
  // String confirm_password;
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

  void initState() {
    super.initState();
    userid = widget.id;
    propsfirstname = widget.firstName;
    propslastname = widget.lastName;
    propsemail = widget.email;
    propspassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("Edit Profile", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildFirstNameFormField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildLastNameFormField(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      GestureDetector(
                        onTap: () {
                          print("change email address clicked");
                          //print("id: " + widget.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeEmailScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Change email address",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      GestureDetector(
                        onTap: () {
                          print("Change password clicked");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangePasswordScreen(id: userid),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Change password",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      GestureDetector(
                        onTap: () {
                          print("Change phone number clicked");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePhoneNumberScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Change phone number",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FormError(errors: errors),
                      SizedBox(height: getProportionateScreenHeight(40)),
                      DefaultButton(
                        text: "Save",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            print("button pressed");
                            print("firstname : " + _updatedfirstName);
                            print("laststname : " + _updatedlastName);
                            print("calling update request");

                            Future<UpdateUserResponseModel> updateUser(
                                String fn, String ln) async {
                              if (fn != "" && ln != "") {
                                final response = await http.put(
                                  Uri.parse("$myip/api/user/edituser/$userid"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, String>{
                                    'firstname': fn,
                                    'lastname': ln,
                                  }),
                                );
                                print("fn is :" + fn);

                                if (response.statusCode == 200) {
                                  print("response 200");
                                  print(response.body);
                                  // Fluttertoast.showToast(
                                  //   msg: "Profile edited Successfully",
                                  //   toastLength: Toast.LENGTH_LONG,
                                  //   gravity: ToastGravity.SNACKBAR,
                                  //   backgroundColor: kPrimaryColor,
                                  //   textColor: Colors.white,
                                  //   fontSize: 20.0,
                                  // );
                                  CherryToast.success(
                                    toastDuration: Duration(seconds: 5),
                                    title: "",
                                    enableIconAnimation: false,
                                    displayTitle: false,
                                    description: "Profile edited Successfully",
                                    toastPosition: POSITION.BOTTOM,
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    autoDismiss: true,
                                  ).show(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                    ),
                                  );
                                  return UpdateUserResponseModel.fromJson(
                                      jsonDecode(response.body));
                                } else {
                                  print(response.body);
                                }
                              }

                              /////////
                              else if (fn != "") {
                                final response = await http.put(
                                  Uri.parse("$myip/api/user/edituser/$userid"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, String>{
                                    'firstname': fn,
                                  }),
                                );
                                print("fn is :" + fn);

                                if (response.statusCode == 200) {
                                  print("response 200");
                                  print(response.body);
                                  // Fluttertoast.showToast(
                                  //   msg: "Profile edited Successfully",
                                  //   toastLength: Toast.LENGTH_LONG,
                                  //   gravity: ToastGravity.SNACKBAR,
                                  //   backgroundColor: kPrimaryColor,
                                  //   textColor: Colors.white,
                                  //   fontSize: 20.0,
                                  // );
                                  CherryToast.success(
                                    toastDuration: Duration(seconds: 5),
                                    title: "",
                                    enableIconAnimation: false,
                                    displayTitle: false,
                                    description: "Profile edited Successfully",
                                    toastPosition: POSITION.BOTTOM,
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    autoDismiss: true,
                                  ).show(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                    ),
                                  );
                                  return UpdateUserResponseModel.fromJson(
                                      jsonDecode(response.body));
                                } else {
                                  print(response.body);
                                }
                              } else if (ln != "") {
                                final response = await http.put(
                                  Uri.parse("$myip/api/user/edituser/$userid"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, String>{
                                    'lastname': ln,
                                  }),
                                );
                                print("ln is :" + ln);

                                if (response.statusCode == 200) {
                                  print("response 200");
                                  print(response.body);
                                  // Fluttertoast.showToast(
                                  //   msg: "Profile edited Successfully",
                                  //   toastLength: Toast.LENGTH_LONG,
                                  //   gravity: ToastGravity.SNACKBAR,
                                  //   backgroundColor: kPrimaryColor,
                                  //   textColor: Colors.white,
                                  //   fontSize: 20.0,
                                  // );
                                  CherryToast.success(
                                    toastDuration: Duration(seconds: 5),
                                    title: "",
                                    enableIconAnimation: false,
                                    displayTitle: false,
                                    description: "Profile edited Successfully",
                                    toastPosition: POSITION.BOTTOM,
                                    animationDuration:
                                        Duration(milliseconds: 1000),
                                    autoDismiss: true,
                                  ).show(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                    ),
                                  );
                                  return UpdateUserResponseModel.fromJson(
                                      jsonDecode(response.body));
                                } else {
                                  print(response.body);
                                }
                              } else {
                                // Fluttertoast.showToast(
                                //   msg: "Please update any name",
                                //   toastLength: Toast.LENGTH_LONG,
                                //   gravity: ToastGravity.SNACKBAR,
                                //   backgroundColor: kPrimaryColor,
                                //   textColor: Colors.white,
                                //   fontSize: 20.0,
                                // );
                                CherryToast.error(
                                  toastDuration: Duration(seconds: 5),
                                  title: "",
                                  enableIconAnimation: false,
                                  displayTitle: false,
                                  description: "Please update name",
                                  toastPosition: POSITION.BOTTOM,
                                  animationDuration:
                                      Duration(milliseconds: 1000),
                                  autoDismiss: true,
                                ).show(context);
                              }
                            }

                            await updateUser(
                                _updatedfirstName, _updatedlastName);
                          }
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(40)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IntlPhoneField buildnewPhoneNumberFormField() {
    return IntlPhoneField(
      //onSaved: (PhoneNumber newValue) => _phoneNumber = newValue,
      onChanged: (value) {
        if (value.toString().isEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return print(value.completeNumber);
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

      // onChanged: (phone) {
      //   print(phone.completeNumber);
      // },
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      //controller: lastnamecontroller,
      onSaved: (newValue) => {
        _updatedlastName = newValue,
        print(_updatedlastName),
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        } else {
          return value;
        }
        setState(() {
          _updatedlastName = value;
        });
        print("updated last name: " + _updatedlastName);
      },
      initialValue: "$propslastname",
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      //onSaved: (newValue) => _email = newValue,
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
      initialValue: "$propsemail",
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

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      //controller: firstnamecontroller,
      onSaved: (newValue) => {
        _updatedfirstName = newValue,
        print(_updatedfirstName),
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        } else {
          return value;
        }
        setState(() {
          _updatedfirstName = value;
        });
        print("updated first name: " + _updatedfirstName);
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      initialValue: "$propsfirstname",
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
