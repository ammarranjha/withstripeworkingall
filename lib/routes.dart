import 'package:flutter/widgets.dart';
import 'package:pool_your_car/screens/notifications/notification_screen.dart';
import 'package:pool_your_car/screens/cart/cart_screen.dart';
import 'package:pool_your_car/screens/complete_profile/complete_profile_screen.dart';
import 'package:pool_your_car/screens/details/details_screen.dart';
import 'package:pool_your_car/screens/forgot_password/forgot_password_screen.dart';
import 'package:pool_your_car/screens/help_center/help_center_screen.dart';
import 'package:pool_your_car/screens/home/home_screen.dart';
import 'package:pool_your_car/screens/login_success/login_success_screen.dart';
import 'package:pool_your_car/screens/signup_success/signup_success_screen.dart';
import 'package:pool_your_car/screens/otp/otp_screen.dart';
import 'package:pool_your_car/screens/profile/profile_screen.dart';
import 'package:pool_your_car/screens/sign_in/sign_in_screen.dart';
import 'package:pool_your_car/screens/splash/splash_screen.dart';
import 'package:pool_your_car/screens/offer_ride/offer_ride_screen.dart';
import 'package:pool_your_car/screens/search_ride/search_ride_screen.dart';
import 'package:pool_your_car/screens/Inbox/inbox_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignupSuccessScreen.routeName: (context) => SignupSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  OfferRideScreen.routeName: (context) => OfferRideScreen(),
  SearchRideScreen.routeName: (context) => SearchRideScreen(),
  InboxScreen.routeName: (context) => InboxScreen(),
  NotificationsScreen.routeName: (context) => NotificationsScreen(),
  //RemainingBodyOne.routeName: (context) => RemainingBodyOne(),
  //RemainingBodySecond.routeName: (context) => RemainingBodySecond(),
  //ProfileDetailsScreen.routeName:(context)=> ProfileDetailsScreen(),
  //SearchedRideResult.routeName:(context)=> SearchedRideResult(),

  HelpCenterScreen.routeName: (context) => HelpCenterScreen(),
};
