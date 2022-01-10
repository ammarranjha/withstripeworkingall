import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/models/CheckEmailExistsResponseModel.dart';
import 'package:pool_your_car/screens/otp/otp_screen.dart';
import 'package:pool_your_car/screens/profile_details/components/otp_screen.dart';
import '../../../constants.dart';
import 'package:pool_your_car/components/custom_surfix_icon.dart';
import 'package:pool_your_car/components/form_error.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:http/http.dart' as http;
import '../../../size_config.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = new TextEditingController();

  bool emailExists = false;
  Future<CheckEmailExistsResponseModel> checkEmail() async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('GET', Uri.parse('$myip/api/user/checkemailexists'));
    request.body = json.encode({
      "email": this.emailcontroller.value.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var _response = await http.Response.fromStream(response);
      Map<String, dynamic> _map = jsonDecode(_response.body);

      //print(jsonDecode(_response.body));
      print(_map['message']);
      //  print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
      setState(() {
        this.emailExists = true;
      });
      cherryToastError("Email Already Taken", context);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Edit Email Address"),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text("Edit Email Address", style: headingStyle),
                  SizedBox(height: getProportionateScreenHeight(50)),
                  buildEmailFormField(),
                  FormError(errors: errors),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  DefaultButton(
                    text: "Save",
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        //Navigator.pushNamed(context, OtpScreen.routeName);
                        print("Alright");
                        await checkEmail();
                        if (emailExists == false)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyOtpScreen(
                                    email: emailcontroller.value.text)),
                          );
                      }
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailcontroller,
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
      //initialValue: "$propsemail",
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        hintText: "Enter new email address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
