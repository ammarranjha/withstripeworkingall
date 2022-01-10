import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pool_your_car/screens/help_center/help_center_screen.dart';
import 'package:pool_your_car/screens/profile/components/admin_email.dart';
import 'package:pool_your_car/screens/profile_details/profile_details_screen.dart';
import 'package:pool_your_car/screens/profile_details/profile_details_screen.dart';
import 'package:pool_your_car/screens/splash/splash_screen.dart';
import 'package:pool_your_car/screens/stripe/StripeScreenHome.dart';
import 'package:pool_your_car/screens/wallet/wallet_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String sharedprefenrenceid;
  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    print("in profile screen");
    print("id in shared preference is " + json.decode(userid));
    print("email in shared preference is " + json.decode(_email));
    sharedprefenrenceid = json.decode(userid);

    //GetUserDetails();
  }

  @override
  void initState() {
    super.initState();
    gettingSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          //ProfilePic(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Pool Your Car",
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Profile",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              //gettingSharedPreference(),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileDetailsScreen(
                          sharedprefenrenceid: this.sharedprefenrenceid)))
            },
          ),
          ProfileMenu(
            text: "Wallet",
            icon: "assets/icons/Cash.svg",
            press: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WalletScreen(
                          // sharedprefenrenceid: this.sharedprefenrenceid
                          )))
            },
          ),

          ProfileMenu(
            text: "Pay using Stripe",
            icon: "assets/icons/Cash.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StripeScreenHome()));
            },
          ),
          // ProfileMenu(
          //   text: "Notifications",
          //   icon: "assets/icons/Bell.svg",
          //   press: () => {},
          // ),
          // ProfileMenu(
          //   text: "Settings",
          //   icon: "assets/icons/Settings.svg",
          //   press: () {},
          // ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HelpCenterScreen()));
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(SplashScreen.routeName));
            },
          ),
        ],
      ),
    );
  }
}
