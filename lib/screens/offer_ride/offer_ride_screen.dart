import 'package:flutter/material.dart';
import 'package:pool_your_car/components/coustom_bottom_nav_bar.dart';
import 'package:pool_your_car/enums.dart';
import 'components/body.dart';
import '../../constants.dart';

//const kGoogleApiKey = "AIzaSyDkYPrBWAp4X2newWTdFEaKc4clrawnvgU";

class OfferRideScreen extends StatelessWidget {
  @override
  static String routeName = "/offer_ride";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Offer Ride"),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.offerride,
      ),
    );
  }
}
