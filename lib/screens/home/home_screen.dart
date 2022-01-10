import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/components/coustom_bottom_nav_bar.dart';
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/enums.dart';
import 'package:pool_your_car/screens/Inbox/inbox_screen.dart';
import 'package:pool_your_car/screens/offer_ride/offer_ride_screen.dart';
import 'package:pool_your_car/screens/profile/profile_screen.dart';
import 'package:pool_your_car/screens/search_ride/search_ride_screen.dart';

import 'components/body.dart';

//
class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MenuState> pages = [
    MenuState.home,
    MenuState.searchride,
    MenuState.offerride,
    MenuState.inbox,
    MenuState.profile
  ];
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        Body(),
        SearchRideScreen(),
        OfferRideScreen(),
        InboxScreen(),
        ProfileScreen(),
      ].elementAt(currentTab),
      //body: Body(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.home, // pages.elementAt(currentTab),
        onSelect: (selected) {
          setState(() {
            if (isUserBlocked) {
              Fluttertoast.showToast(
                msg: "User Blocked Please Contact Admin",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                backgroundColor: kPrimaryColor,
                textColor: Colors.white,
                fontSize: 20.0,
              );
            }
            //  else {
            //   currentTab = selected;
            // }
          });
        },
      ),
    );
  }
}
