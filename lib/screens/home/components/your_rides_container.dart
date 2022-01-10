import 'package:flutter/material.dart';
import 'package:pool_your_car/constants.dart';
import 'your_ride_plan.dart';

import '../../../size_config.dart';
// import 'package:intl/intl.dart';

class YourRidesContainer extends StatelessWidget {
  final String rideid;
  final String day; //EEE, d LLLL y
  //     DateFormat('EEE, d LLLL y').format(DateTime.now()); //EEE, d LLLL y
  final String
      time; // = DateFormat('hh:mm:a').format(DateTime.now()); //hh:mm:a
  final String fromlocation, tolocation;
  final VoidCallback press;
  final String ridetype;
  final String drivername;
  final String image = "assets/images/Profile Image.png";
  final int cashamount;
  final String carType;
  final String carName;
  final String carRegNumber;
  final String carManufactureYear;
  final availableseats;
  final offeredseats;
  final int discount;
  final String discription;
  final int ridefare;
  final String isAccepted;
  final bool viewMap;
  YourRidesContainer({
    Key key,
    @required this.rideid,
    @required this.day,
    @required this.time,
    @required this.fromlocation,
    @required this.tolocation,
    @required this.ridetype,
    @required this.drivername,
    this.press,
    this.cashamount,
    this.carType,
    this.availableseats,
    this.offeredseats,
    @required this.discount,
    @required this.discription,
    @required this.ridefare,
    @required this.carName,
    @required this.carManufactureYear,
    @required this.carRegNumber,
    this.viewMap = false,
    this.isAccepted,
    //@required this.image

    //this.image,
  }) : super(key: key);
  //final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    //var day= DateFormat('EEEE').format(DateTime.now());
    return GestureDetector(
      onTap: () {
        print(this.offeredseats);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RidePlan(
              rideid: this.rideid,
              day: this.day,
              time: this.time,
              fromlocation: this.fromlocation,
              tolocation: this.tolocation,
              ridetype: this.ridetype,
              drivername: this.drivername,
              image: this.image,
              cartype: this.carType,
              availableseats: this.availableseats,
              discount: this.discount,
              offeredseats: this.offeredseats,
              discription: this.discription,
              ridefare: this.ridefare,
              carName: this.carName,
              carManufactureYear: this.carManufactureYear,
              carRegNumber: this.carRegNumber,
              acceptance: (this.isAccepted != null) ? this.isAccepted : null,
            ),
          ),
        );
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            //SizedBox(height: getProportionateScreenHeight(20)),
            Container(
              decoration: BoxDecoration(
                //color: Colors.white54,
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
                    if (ridetype.toLowerCase() == "booked")
                      Text(
                        "Booked",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(20),
                        ),
                      )
                    else
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
                    if (this.discount != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Discount",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "$discount%",
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
                    if (viewMap)
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        color: kPrimaryColor,
                        onPressed: _openMapPage,
                        child: Text(
                          "Open Map",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (isAccepted != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "$isAccepted",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(15),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> _openMapPage() async {
    print('open');
  }
}
