import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/body.dart';

class SearchedRideResult extends StatelessWidget {
  static String routeName = "/searched_ride_result";
  final String pickuplocation;
  final String pickuplocation_lat;
  final String pickuplocation_lon;
  final String droplocation;
  final String droplocation_lat;
  final String droplocation_lon;
  final String date;
  final String time;
  final String cartype;
  final int noofpassengers;
  SearchedRideResult({
    @required this.pickuplocation,
    @required this.droplocation,
    @required this.date,
    @required this.time,
    @required this.cartype,
    @required this.noofpassengers,
    @required this.pickuplocation_lat,
    @required this.pickuplocation_lon,
    @required this.droplocation_lat,
    @required this.droplocation_lon,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Available Searched Rides"),
      ),
      body: Body(
        pickuplocation: this.pickuplocation,
        pickuplocation_lat: this.pickuplocation_lat,
        pickuplocation_lon: this.pickuplocation_lon,
        droplocation: this.droplocation,
        droplocation_lat: this.droplocation_lat,
        droplocation_lon: this.droplocation_lon,
        date: this.date,
        time: this.time,
        cartype: this.cartype,
        noofpassengers: this.noofpassengers,
      ),
    );
  }
}
