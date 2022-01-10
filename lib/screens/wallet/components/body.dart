// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/models/AddPassengerResponseModel.dart';
import 'package:pool_your_car/models/GetUserResponseModel.dart';
import 'package:pool_your_car/models/WalletModel.dart';
import 'package:pool_your_car/screens/profile_details/components/edit_profile.dart';
import 'package:pool_your_car/screens/public_profile_view/public_profile_view_screen.dart';
import 'package:pool_your_car/screens/wallet/components/mini_statement.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  WalletModel model = WalletModel();
  String amount;
  String uniqueId;

  TextEditingController amountController = TextEditingController();
  TextEditingController uniqueIdController = TextEditingController();

  bool image_is_uploaded = false;
  String driver_profile_image_url;

  String sharedprefenrenceid;
  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    print("In home screen");
    print("User id in shared preference is " + json.decode(userid));
    print("user email in shared preference is " + json.decode(_email));
    sharedprefenrenceid = json.decode(userid);

    //GetUserDetails();
  }

  Future<void> getWalletDetail() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    print("Before url");
    http.Response response = await http.post(
        Uri.parse('$myip/api/payment/getwalletdetails'),
        headers: headers,
        body: json.encode({'userId': sharedprefenrenceid}));

    setState(() {
      model = WalletModel.fromJson(response.body);
    });
  }

  Future<void> sendCredit() async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    print("Before url");
    print(amountController.text);
    print(uniqueIdController.text);
    if (amountController.text == '' || uniqueIdController.text == '') {
      CherryToast.error(
        toastDuration: Duration(seconds: 2),
        title: "",
        enableIconAnimation: true,
        displayTitle: false,
        description: "Enter All Data",
        toastPosition: POSITION.BOTTOM,
        animationDuration: Duration(milliseconds: 500),
        autoDismiss: true,
      ).show(context);
    } else {
      Loader.show(context,
          isAppbarOverlay: true,
          isBottomBarOverlay: true,
          progressIndicator: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
          themeData: Theme.of(context).copyWith(accentColor: Colors.green),
          overlayColor: Color(0x99E8EAF6));

      try {
        http.Response response =
            await http.post(Uri.parse('$myip/api/user/sendCredits'),
                headers: headers,
                body: json.encode({
                  'userId': sharedprefenrenceid,
                  'amountSent': int.parse(amountController.text),
                  'receiverId': '+${uniqueIdController.text}'
                }));

        if (response.statusCode == 200) {
          setState(() {
            model = WalletModel.fromJson(response.body);
          });
          CherryToast.success(
            toastDuration: Duration(seconds: 2),
            title: "",
            enableIconAnimation: true,
            displayTitle: false,
            description: "Transaction Successful",
            toastPosition: POSITION.BOTTOM,
            animationDuration: Duration(milliseconds: 2000),
            autoDismiss: true,
          ).show(context);
        } else {
          CherryToast.error(
            toastDuration: Duration(seconds: 2),
            title: "",
            enableIconAnimation: true,
            displayTitle: false,
            description: response.body,
            toastPosition: POSITION.BOTTOM,
            animationDuration: Duration(milliseconds: 500),
            autoDismiss: true,
          ).show(context);
        }
      } catch (err) {
        CherryToast.error(
          toastDuration: Duration(seconds: 2),
          title: "",
          enableIconAnimation: true,
          displayTitle: false,
          description: "Invalid data",
          toastPosition: POSITION.BOTTOM,
          animationDuration: Duration(milliseconds: 500),
          autoDismiss: true,
        ).show(context);
      }

      Loader.hide();
    }
  }

  Future<void> callFunctions() async {
    await gettingSharedPreference();
    await getWalletDetail();
  }

  @override
  void initState() {
    super.initState();
    callFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Wallet"),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(30)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Wallet",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ), //00331

              SizedBox(height: SizeConfig.screenHeight * 0.05),

              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Text(
                      "Wallet No:   ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Text(
                      model.uniqueId ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Text(
                      "Balance :      ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Text(
                        'Rs. ${model.balance ?? ''}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              DefaultButton(
                  text: "Mini Statement",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MiniStatement(
                                  userId: sharedprefenrenceid,
                                )));
                  } //bookRide
                  ),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              Divider(thickness: 1.8, color: kPrimaryColor),

              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Text(
                      "Transfer :          ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: const SizedBox())
                    //Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                    child: TextField(
                        controller: uniqueIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (text) {
                          uniqueId = text;
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Wallet Id of Reciever"))),
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Text(
                      "Ammount :          ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(child: const SizedBox())
                    //Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                    child: TextField(
                        controller: amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (text) {
                          amount = text;
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Ammount to be Sent"))),
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              // Divider(thickness: 1.8, color: kPrimaryColor),

              SizedBox(height: SizeConfig.screenHeight * 0.02),

              DefaultButton(
                  text: "Send Credit",
                  press: () {
                    sendCredit();
                  } //bookRide
                  ),

              SizedBox(height: SizeConfig.screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
