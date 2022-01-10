import 'package:flutter_svg/flutter_svg.dart';
import 'package:pool_your_car/components/default_button.dart';

import '../../../size_config.dart';
import '../../../constants.dart';

import 'package:flutter/material.dart';

class PastRidePlan extends StatelessWidget {
  final String rideid;
  final String day; //=
  //DateFormat('EEE, M/d/y').format(DateT ime.now()); //EEE, M/d/y
  final String time; //= DateFormat('hh:mm:a').format(DateTime.now()); //hh:mm:a
  final String fromlocation, tolocation;
  final String ridetype;
  final String image;
  //final String drivername;
  final int ridefare;
  final String cartype;
  final int offeredseats;
  final bookedseats;
  PastRidePlan({
    Key key,
    @required this.rideid,
    @required this.day,
    @required this.time,
    @required this.fromlocation,
    @required this.tolocation,
    @required this.ridetype,
    this.image,
    //this.drivername,
    @required this.ridefare,
    @required this.cartype,
    @required this.bookedseats,
    @required this.offeredseats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        //title: Text("Ride Plan"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                left: getProportionateScreenWidth(30),
                right: getProportionateScreenWidth(30)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Row(
                    children: [
                      Text(
                        "Ride Plan",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ), //00331

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_border_purple500_sharp,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Leave a rating!",
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      15),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 30.0),
                                      //   child: Row(
                                      //     children: [
                                      //       Text(
                                      //         "Rate your  dsa das  ads asd",
                                      //         style: TextStyle(
                                      //           color: Colors.black,
                                      //           fontSize:
                                      //               getProportionateScreenWidth(
                                      //                   15),
                                      //           fontWeight: FontWeight.w500,
                                      //         ),
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //       height: getProportionateScreenWidth(3)),
                                // Text(
                                //   "Rate your travel experience with AR",
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: getProportionateScreenWidth(15),
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Row(
                    children: [
                      Text(
                        "$day",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "$time",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "From:      ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "$fromlocation",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Icon(
                      //   Icons.arrow_forward_ios,
                      //   color: kPrimaryColor,
                      // ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Row(
                    children: [
                      Text(
                        "To:          ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "$tolocation",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Icon(Icons.arrow_forward_ios),
                    ],
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.02),

                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Ride fare per seat",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Rs. 200",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Offered Seats",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "$offeredseats",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Booked Seats",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "$bookedseats",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        //SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Divider(thickness: 1.8, color: kPrimaryColor),
                        //SizedBox(height: SizeConfig.screenHeight * 0.02),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "$drivername",
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: getProportionateScreenWidth(15),
                        //           fontWeight: FontWeight.w700),
                        //     ),
                        //     Spacer(),
                        //     CircleAvatar(
                        //       backgroundImage: AssetImage("$image"),
                        //     ),
                        //   ],
                        // ),
                        //SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              "$cartype",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: getProportionateScreenWidth(15),
                                  fontWeight: FontWeight.w700),
                            ),
                            Spacer(),
                            Container(
                              child: SvgPicture.asset(
                                "assets/icons/Minicar2 icon.svg",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Divider(thickness: 1.8, color: kPrimaryColor),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              "No of passengers",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "0",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        DefaultButton(
                          text: "Delete Ride",
                          press: () {
                            print("object");
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
