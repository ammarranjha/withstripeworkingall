import 'package:flutter/material.dart';
import 'package:pool_your_car/components/coustom_bottom_nav_bar.dart';
import 'package:pool_your_car/enums.dart';
import 'body.dart';
import '../../constants.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({Key key}) : super(key: key);

  static String routeName = "/inbox";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text(
          "Inbox",
        ),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.inbox,
      ),
    );
  }
}
