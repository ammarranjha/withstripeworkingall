import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/models/GetSingleRideResponseModel.dart';
import 'package:pool_your_car/models/autocomplete_textfield.dart';
import 'package:pool_your_car/screens/home/components/remaining_edit_ride_screen.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

import '../../../size_config.dart';

class EditRideScreen extends StatefulWidget {
  //final String day; //=
  //DateFormat('EEE, M/d/y').format(DateT ime.now()); //EEE, M/d/y
  //final String time; //= DateFormat('hh:mm:a').format(DateTime.now()); //hh:mm:a
  final String rideid;
  EditRideScreen({Key key, @required this.rideid}) : super(key: key);

  @override
  State<EditRideScreen> createState() => _EditRideScreenState();
}

class _EditRideScreenState extends State<EditRideScreen> {
  Map<String, dynamic> rideDetails;
  final dateformat = DateFormat(
      "yMMMMEEEEd"); //DateFormat("EEE, d/MMMM/y"); // before yyyy-MM-dd, after EEE, d LLLL y
  final timeformat = DateFormat("h:mm a");
  String driverId;
  TimeOfDay _selectedTime;
  String pickuplocation;
  String droplocation;
  String email;
  String date, mytime;
  String ride_type = 'offered';

  String pickup_Lat, pickup_Lon, drop_Lat, drop_Lon;
  TextEditingController pickupcontroller = TextEditingController();
  TextEditingController dropcontroller = TextEditingController();

  int seats;
  String cartype;
  TextEditingController detailscontroller = new TextEditingController();
  TextEditingController veh_name_controller = new TextEditingController();
  TextEditingController veh_reg_number_controller = new TextEditingController();
  TextEditingController datecontroller = new TextEditingController();
  TextEditingController carnamecontroller = new TextEditingController();
  TextEditingController car_manufacture_year = new TextEditingController();
  TextEditingController optional_details = new TextEditingController();

  void _incrementPassenger() {
    if (seats < 4) {
      setState(() {
        seats++;
      });
    } else {
      setState(() {
        seats = 4;
      });
    }
  }

  void _decrementPassenger() {
    if (seats > 1) {
      setState(() {
        seats--;
      });
    }
  }

  Future<GetSingleRideResponseModel> getRideDetails() async {
    var request = http.Request('GET',
        Uri.parse('$myip/api/ride/getsingleofferedride/${widget.rideid}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var _response = await http.Response.fromStream(response);
      //print(await response.stream.bytesToString());
      setState(() {
        rideDetails = jsonDecode(_response.body);
      });
      print(rideDetails);
      print(rideDetails['offeredseats']);
      setState(() {
        driverId = rideDetails['driverId'];
        pickupcontroller.text = rideDetails['pickuplocation'];
        dropcontroller.text = rideDetails['droplocation'];
        pickup_Lat = rideDetails['pickuplocation_Lat'];
        pickup_Lon = rideDetails['pickuplocation_Lon'];
        drop_Lat = rideDetails['droplocation_Lat'];
        drop_Lon = rideDetails['droplocation_Lon'];
        date = rideDetails['date'];
        mytime = rideDetails['time'];
        seats = rideDetails['offeredseats'];
        cartype = rideDetails['cartype'];
        carnamecontroller.text = rideDetails['car_name'];
        veh_reg_number_controller.text = rideDetails['car_registration_number'];
        car_manufacture_year.text = rideDetails['car_manufacture_year'];
        optional_details.text = rideDetails['optional_details'];
      });
    } else {
      print(response.reasonPhrase);
      cherryToastError("Unable to load details", context);
    }
  }

  callfunction() async {
    await getRideDetails();
    setState(() {
      this.seats = rideDetails['offeredseats'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callfunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text("Edit Ride"),
      ),
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Text(
                      "Edit Ride Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    pickupplacesAutoCompleteTextField(),
                    //buildEmailFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    dropupplacesAutoCompleteTextField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    dateField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    timeField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "So how many passengers you can take?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            _decrementPassenger();
                          },
                          splashColor: Colors.white,
                          elevation: 2.0,
                          fillColor: kPrimaryColor,
                          child: Icon(
                            Icons.remove,
                            size: getProportionateScreenWidth(28),
                          ),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder(),
                        ),
                        Spacer(),
                        Text(
                          "$seats",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(25),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        RawMaterialButton(
                          onPressed: () {
                            _incrementPassenger();
                          },
                          splashColor: Colors.white,
                          elevation: 2.0,
                          fillColor: kPrimaryColor,
                          child: Icon(Icons.add,
                              size: getProportionateScreenWidth(28)),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder(),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Select Car Type",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    dropDownCarSelection(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Car Name",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    buildVehNameFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Car Registration Number",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    buildVehRegNumberFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Select Car Manufacture Year",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    dropDownCarManufactureYearSelection(),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Anything to add about your ride?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Optional***",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    TextFormField(
                      controller: detailscontroller,
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText:
                              "Flexible about where \nand when to meet? \nNot taking the " +
                                  "motorway?\nGot limited space in your \nboot?",
                          labelText: "Ride Restrictions",
                          labelStyle: TextStyle()),
                      keyboardType: TextInputType.multiline,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    DefaultButton(
                      text: "Next",
                      press: () {
                        print("object");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RemainingEditRideScreen()));
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  pickupplacesAutoCompleteTextField() {
    return Container(
      child: googlePlaceAutoCompleteTextField(
        //obscureText: true,
        // keyboardType: TextInputType.streetAddress,
        // onSaved: (newValue) => pickuplocation = newValue,
        // onChanged: (value) {
        //   if (value.isNotEmpty) {
        //     removeError(error: kPickupAddressNullError);
        //   }
        //   return null;
        // },
        // validator: (value) {
        //   if (value.isEmpty) {
        //     addError(error: kPickupAddressNullError);
        //     return "";
        //   }
        //   return null;
        // },

        textEditingController: pickupcontroller,
        googleAPIKey: "kGoogleApiKey",
        inputDecoration: InputDecoration(
          hintText: "Enter pick-up location",
          hintStyle: TextStyle(
              //fontSize: 18,
              ),
          labelText: "Pick-Up location",
          labelStyle: TextStyle(
            //color: kPrimaryColor,
            fontSize: 18,
            //fontWeight: FontWeight.w700,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.location_on_outlined),
        ),
        debounceTime: 800,
        countries: ["pk"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("Pick-up place details, lat: " +
              prediction.lat.toString() +
              " lng: " +
              prediction.lng.toString() +
              " desc: " +
              prediction.description);
          this.pickup_Lat = prediction.lat.toString();
          this.pickup_Lon = prediction.lng.toString();
        },
        itmClick: (Prediction prediction) {
          pickupcontroller.text = prediction.description;
          this.pickup_Lat = prediction.lat.toString();
          this.pickup_Lon = prediction.lng.toString();

          pickupcontroller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description.length));
        },
      ),
    );
  }

  dropupplacesAutoCompleteTextField() {
    return Container(
      child: googlePlaceAutoCompleteTextField(
        //obscureText: true,
        // keyboardType: TextInputType.streetAddress,
        // onSaved: (newValue) => droplocation = newValue,
        // onChanged: (value) {
        //   if (value.isNotEmpty) {
        //     removeError(error: kDropAddressNullError);
        //   }
        //   return null;
        // },
        // validator: (value) {
        //   if (value.isEmpty) {
        //     addError(error: kDropAddressNullError);
        //     return "";
        //   }
        //   return null;
        // },
        textEditingController: dropcontroller,
        googleAPIKey: "kGoogleApiKey",
        inputDecoration: InputDecoration(
          hintText: "Enter drop location",
          hintStyle: TextStyle(
            fontSize: 18,
          ),
          labelText: "Drop location",
          labelStyle: TextStyle(
            fontSize: 18,
            //color: kPrimaryColor,
            //fontWeight: FontWeight.w700,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.location_on_outlined),
        ),
        debounceTime: 800,
        countries: ["pk"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("Drop-up place details, lat: " +
              prediction.lat.toString() +
              "lng: " +
              prediction.lng.toString() +
              "desc: " +
              prediction.description);
          this.drop_Lat = prediction.lat.toString();
          this.drop_Lon = prediction.lng.toString();
        },
        itmClick: (Prediction prediction) {
          dropcontroller.text = prediction.description;
          this.drop_Lat = prediction.lat.toString();
          this.drop_Lon = prediction.lng.toString();
          dropcontroller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description.length));
        },
      ),
    );
  }

  dateField() {
    return DateTimeField(
      controller: datecontroller,
      cursorColor: Color(0xFFFF7643),
      keyboardType: TextInputType.datetime,
      onSaved: (newValue) => {
        // date = newValue,

        print(date),
      },
      onChanged: (val) => {
        print("Formatted date: "),
        // date = DateFormat.yMMMMEEEEd().format(val),
        date = DateFormat('EEE, d LLLL y').format(val),
        print(date),
      },
      validator: (val) {
        //date = DateFormat.yMMMMEEEEd().format(val);
        date = DateFormat('EEE, d LLLL y').format(val);
        return date;
      },
      decoration: InputDecoration(
        hintText: 'Pick your Date',
        labelText: "Date (EEE, M/d/y)",
        labelStyle: TextStyle(
            //color: kPrimaryColor,
            ),
      ),
      format: dateformat,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2022, 12));
      },
    );
  }

  timeField() {
    return DateTimeField(
      cursorColor: Color(0xFFFF7643),
      decoration: InputDecoration(
        labelText: "Time (hh:mm:a)",
        // labelStyle: TextStyle(
        //   color: kPrimaryColor,
        // ),
        hintText: "Time",
        // hintStyle: TextStyle(
        //   color: kPrimaryColor,
        // ),
      ),
      onChanged: (val) => {
        //mytime = DateFormat('kk:mm:a').format(val),
        mytime = DateFormat('h:mm a').format(val),
        print("formatted time: "),
        print(mytime),
      },
      format: timeformat,
      onShowPicker: (context, currentValue) async {
        final TimeOfDay time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return time == null ? null : DateTimeField.convert(time);
      },
    );
  }

  dropDownCarSelection() {
    return DropdownSearch<String>(
      validator: (v) => v == null ? "required field" : null,
      hint: "Select Car Type",
      mode: Mode.MENU,
      //showSelectedItem: true,

      //maxHeight: 70,
      //searchBoxDecoration: ,
      items: [
        "Mini Car",
        "Sedan Car",
        "Hatchback Car",
        "Premium Car",
      ],
      //label: "Menu mode *",
      showClearButton: true,
      onChanged: (value) {
        cartype = value;
        //print("si value is " + si);
      },
      //popupItemDisabled: (String s) => s.startsWith('I'),
      //selectedItem: ,
      // onBeforeChange: (a, b) {
      //   AlertDialog alert = AlertDialog(
      //     title: Text("Are you sure"),
      //     content: Text("...you want to clear the selection"),
      //     actions: [
      //       FlatButton(
      //         child: Text("OK"),
      //         onPressed: () {
      //           Navigator.of(context).pop(true);
      //         },
      //       ),
      //       FlatButton(
      //         child: Text("NOT OK"),
      //         onPressed: () {
      //           Navigator.of(context).pop(false);
      //         },
      //       ),
      //     ],
      //   );

      //   return showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return alert;
      //       });
      // },
    );
  }

  dropDownCarManufactureYearSelection() {
    return DropdownSearch<String>(
      validator: (v) => v == null ? "required field" : null,
      hint: "Select Car Manufacture Year",
      mode: Mode.DIALOG,
      //showSelectedItem: true,

      //maxHeight: 70,
      //searchBoxDecoration: ,
      items: [
        "2021",
        "2020",
        "2019",
        "2018",
        "2017",
        "2016",
        "2015",
        "2014",
        "2013",
        "2012",
        "2011",
        "2010",
        "2009",
        "2008",
        "2007",
        "2006",
        "2005",
      ],
      //label: "Menu mode *",
      showClearButton: true,
      onChanged: (value) {
        car_manufacture_year.text = value;
        //print("si value is " + si);
      },
      //popupItemDisabled: (String s) => s.startsWith('I'),
      //selectedItem: ,
      // onBeforeChange: (a, b) {
      //   AlertDialog alert = AlertDialog(
      //     title: Text("Are you sure"),
      //     content: Text("...you want to clear the selection"),
      //     actions: [
      //       FlatButton(
      //         child: Text("OK"),
      //         onPressed: () {
      //           Navigator.of(context).pop(true);
      //         },
      //       ),
      //       FlatButton(
      //         child: Text("NOT OK"),
      //         onPressed: () {
      //           Navigator.of(context).pop(false);
      //         },
      //       ),
      //     ],
      //   );

      //   return showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return alert;
      //       });
      // },
    );
  }

  TextFormField buildVehRegNumberFormField() {
    return TextFormField(
      controller: veh_reg_number_controller,
      //keyboardType: TextInputType.emailAddress,
      //onSaved: (newValue) => email = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: kEmailNullError);
      //   } else if (emailValidatorRegExp.hasMatch(value)) {
      //     removeError(error: kInvalidEmailError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Registration Number",
        labelStyle: TextStyle(
          fontSize: 18,
          //fontWeight: FontWeight.w700,
        ),
        hintText: "Enter Registration Number",
        hintStyle: TextStyle(
          fontSize: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //   suffixIcon: SvgPicture.asset(
        //   "assets/icons/license-plate.svg",
        //   height: getProportionateScreenWidth(10),
        // ),
      ),
    );
  }

  TextFormField buildVehNameFormField() {
    return TextFormField(
      controller: veh_name_controller,
      keyboardType: TextInputType.text,
      //onSaved: (newValue) => email = newValue,
      //onChanged: (value) {},
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Vehicle Name",
        labelStyle: TextStyle(
          fontSize: 18,
          //fontWeight: FontWeight.w700,
        ),
        hintText: "Enter Vehicle Name",
        hintStyle: TextStyle(
          fontSize: 18,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //   suffixIcon: SvgPicture.asset(
        //   "assets/icons/license-plate.svg",
        //   height: getProportionateScreenWidth(10),
        // ),
      ),
    );
  }
}
