import 'package:flutter/material.dart';
import 'package:pool_your_car/components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';
import '../../constants.dart';

class SearchRideScreen extends StatelessWidget {
  static String routeName = "/search_ride";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text(
          "Search Ride",
        ),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.searchride,
      ),
    );
  }
}
