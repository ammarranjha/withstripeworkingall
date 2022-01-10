import 'package:flutter/material.dart';
import 'package:pool_your_car/constants.dart';
import 'past_ride_plan.dart';

import '../../../size_config.dart';
import 'package:intl/intl.dart';

class PastRidesContainer extends StatelessWidget {
  final String rideid;
  final String day; //EEE, d LLLL y
  //     DateFormat('EEE, d LLLL y').format(DateTime.now()); //EEE, d LLLL y
  final String
      time; // = DateFormat('hh:mm:a').format(DateTime.now()); //hh:mm:a
  final String fromlocation, tolocation;
  final VoidCallback press;
  final String ridetype;

  final String image = "assets/images/Profile Image.png";
  //final int cashamount;
  final String carType;
  final int bookedseats;
  final int offeredseats;
  final int discount;
  final String discription;
  final int ridefare;
  PastRidesContainer({
    Key key,
    @required this.rideid,
    @required this.day,
    @required this.time,
    @required this.fromlocation,
    @required this.tolocation,
    @required this.ridetype,
    this.press,
    // this.cashamount,
    @required this.carType,
    @required this.bookedseats,
    @required this.offeredseats,
    @required this.discount,
    @required this.discription,
    @required this.ridefare,

    //this.image,
  }) : super(key: key);
  //final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    //var day= DateFormat('EEEE').format(DateTime.now());
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PastRidePlan(
        //       rideid: this.rideid,
        //       day: this.day,
        //       time: this.time,
        //       fromlocation: this.fromlocation,
        //       tolocation: this.tolocation,
        //       ridetype: this.ridetype,
        //       //drivername: this.drivername,
        //       image: this.image,
        //       cartype: this.carType,
        //       bookedseats: this.bookedseats,
        //       ridefare: this.ridefare,
        //     ),
        //   ),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PastRidePlan(
              rideid: rideid,
              day: day,
              time: time,
              fromlocation: fromlocation,
              tolocation: tolocation,
              ridetype: ridetype,
              ridefare: ridefare,
              cartype: carType,
              offeredseats: this.offeredseats,
              bookedseats: bookedseats,
            ),
          ),
        );
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Container(
              decoration: BoxDecoration(
                //color: Colors.white70,
                gradient: kPrimaryGradientColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    //color: kPrimaryColor,
                    spreadRadius: 4,
                    blurRadius: 3,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              // height: getProportionateScreenHeight(200),
              // width: getProportionateScreenWidth(250),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: getProportionateScreenHeight(10)),
                child: Column(
                  children: [
                    Text(
                      "Offered",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(20),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$day",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$time",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Row(
                      children: [
                        Text(
                          "From :",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "$fromlocation",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "To:     ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "$tolocation,",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    // if (ridetype.toLowerCase() == "booked")
                    //   Row(
                    //     children: [
                    //       CircleAvatar(
                    //         backgroundImage: AssetImage("$image"),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 20.0),
                    //         child: Text(
                    //           "drivername",
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: getProportionateScreenWidth(15),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
