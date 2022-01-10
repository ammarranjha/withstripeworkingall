// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pool_your_car/screens/home/home_screen.dart';
import 'package:pool_your_car/screens/profile/profile_screen.dart';
import 'package:pool_your_car/screens/offer_ride/offer_ride_screen.dart';
import 'package:pool_your_car/screens/search_ride/search_ride_screen.dart';
import 'package:pool_your_car/screens/Inbox/inbox_screen.dart';
import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
    this.onSelect,
  }) : super(key: key);

  final MenuState selectedMenu;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.white,
      unselectedItemColor: inActiveIconColor,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: Icon(
              Icons.home_outlined,
              size: 25,
              color: MenuState.home == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
            onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
          ),
          // ignore: deprecated_member_use
          title: new Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: MenuState.home == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: Icon(
              Icons.search,
              size: 25,
              color: MenuState.searchride == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
            onTap: () => Navigator.pushNamed(
              context,
              SearchRideScreen.routeName,
            ),
          ),
          // ignore: deprecated_member_use
          title: new Text(
            'Search',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: MenuState.searchride == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: Icon(
              Icons.add_circle_outline,
              size: 25.0,
              color: MenuState.offerride == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
            onTap: () => Navigator.pushNamed(
              context,
              OfferRideScreen.routeName,
            ),
          ),
          title: new Text(
            'Offer',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: MenuState.offerride == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              color: MenuState.inbox == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
            onTap: () => Navigator.pushNamed(
              context,
              InboxScreen.routeName,
            ),
          ),
          title: new Text(
            'Chat',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: MenuState.inbox == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: Icon(
              Icons.person,
              size: 25,
              color: MenuState.profile == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
            onTap: () => Navigator.pushNamed(
              context,
              ProfileScreen.routeName,
            ),
          ),
          title: new Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: MenuState.profile == selectedMenu
                  ? kPrimaryColor
                  : inActiveIconColor,
            ),
          ),
        ),
      ],
    );
    //  // yahan tak
    // Container(
    //   padding: EdgeInsets.symmetric(vertical: 10),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     boxShadow: [
    //       BoxShadow(
    //         offset: Offset(0, -15),
    //         blurRadius: 10,
    //         color: Color(0xFFDADADA).withOpacity(0.15),
    //       ),
    //     ],
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(40),
    //       topRight: Radius.circular(40),
    //     ),
    //   ),
    //   child: SafeArea(
    //     top: false,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         GestureDetector(
    //           child: Icon(
    //             Icons.search,
    //             size: 25.0,
    //             color: MenuState.search == selectedMenu
    //                 ? kPrimaryColor
    //                 : inActiveIconColor,
    //           ),
    //           onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
    //         ),
    //         // IconButton(
    //         //   icon: SvgPicture.asset(
    //         //     "assets/icons/Shop Icon.svg",
    //         //     color: MenuState.home == selectedMenu
    //         //         ? kPrimaryColor
    //         //         : inActiveIconColor,
    //         //   ),
    //         //   onPressed: () =>
    //         //       Navigator.pushNamed(context, HomeScreen.routeName),
    //         // ),
    //         // IconButton(
    //         //   icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),

    //         //   onPressed: () {},
    //         // ),
    //         GestureDetector(
    //           child: Icon(
    //             Icons.add_circle_outline,
    //             size: 25.0,
    //             color: //MenuState.search == selectedMenu
    //                 //? kPrimaryColor
    //                 //     :
    //                 inActiveIconColor,
    //           ),
    //           onTap: () => Navigator.pushNamed(
    //             context,
    //             HomeScreen.routeName,
    //           ),
    //         ),

    //         IconButton(
    //           icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: SvgPicture.asset(
    //             "assets/icons/User Icon.svg",
    //             color: MenuState.profile == selectedMenu
    //                 ? kPrimaryColor
    //                 : inActiveIconColor,
    //           ),
    //           onPressed: () =>
    //               Navigator.pushNamed(context, ProfileScreen.routeName),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
