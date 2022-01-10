// ignore_for_file: unused_field, non_constant_identifier_names

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:pool_your_car/screens/searched_ride_result/searched_ride_result_screen.dart';

import '../../../size_config.dart';
import 'autocomplete_textfield.dart';
import '../../../constants.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../searched_ride_result/searched_ride_result_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

TextEditingController pickupcontroller = TextEditingController();
TextEditingController dropcontroller = TextEditingController();

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  String pickuplocation;
  String droplocation;
  String email;
  String date, time;
  int maxpassengers = 1;
  String cartype = '';
  String pickup_Lat;
  String pickup_Lon;
  String drop_Lat;
  String drop_Lon;

  void _incrementPassengers() {
    if (maxpassengers < 4) {
      setState(() {
        maxpassengers += 1;
      });
    } else {
      maxpassengers = 4;
    }
  }

  void _decrementPassengers() {
    if (maxpassengers > 1) {
      setState(() {
        maxpassengers -= 1;
      });
    } else {
      maxpassengers = 1;
    }
  }

  final List<String> errors = [];
  final String kGoogleApiKey = "AIzaSyDkYPrBWAp4X2newWTdFEaKc4clrawnvgU";

  final dateformat = DateFormat(
      "yMMMMEEEEd"); //DateFormat("EEE, d/MMMM/y"); // before yyyy-MM-dd, after EEE, d LLLL y
  final timeformat = DateFormat("h:mm a");

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text(
                  "Ride Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                pickupplacesAutoCompleteTextField(),
                //buildEmailFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                dropupplacesAutoCompleteTextField(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                dateField(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                timeField(),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
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
                Text(
                  "No of Passengers",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        _decrementPassengers();
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
                      "$maxpassengers",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(25),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    RawMaterialButton(
                      onPressed: () {
                        _incrementPassengers();
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

                //FormError(errors: errors),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                DefaultButton(
                  text: "Search Ride",
                  press: () async {
                    //if (_formKey.currentState.validate()) {
                    //  _formKey.currentState.save();
                    //if all are valid then go to success screen

                    //  KeyboardUtil.hideKeyboard(context);
                    if (pickupcontroller.text.isEmpty ||
                        dropcontroller.text.isEmpty ||
                        date == null ||
                        time == null ||
                        cartype.isEmpty) {
                      print("object");
                      CherryToast.error(
                        toastDuration: Duration(seconds: 2),
                        title: "",
                        enableIconAnimation: true,
                        displayTitle: false,
                        description: "Enter all data",
                        toastPosition: POSITION.BOTTOM,
                        animationDuration: Duration(milliseconds: 500),
                        autoDismiss: true,
                      ).show(context);
                    } else {
                      print("Search Ride clicked");
                      print(pickupcontroller.text);
                      print(dropcontroller.text);
                      print("Pickup lat " + pickup_Lat);
                      print("Pickup lon " + pickup_Lon);
                      print(date);
                      print(time);
                      print(cartype);
                      Loader.show(context,
                          isAppbarOverlay: true,
                          isBottomBarOverlay: true,
                          progressIndicator: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                          themeData: Theme.of(context)
                              .copyWith(accentColor: Colors.green),
                          overlayColor: Color(0x99E8EAF6));
                      await Future.delayed(Duration(seconds: 5), () {
                        Loader.hide();
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchedRideResult(
                            pickuplocation: pickupcontroller.text,
                            pickuplocation_lat: this.pickup_Lat,
                            pickuplocation_lon: this.pickup_Lon,
                            droplocation: dropcontroller.text,
                            droplocation_lat: this.drop_Lat,
                            droplocation_lon: this.drop_Lon,
                            date: this.date,
                            time: time,
                            cartype: this.cartype,
                            noofpassengers: this.maxpassengers,
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: getProportionateScreenWidth(20)),
              ],
            ),
          ),
        ),
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
        googleAPIKey: "$kGoogleApiKey",
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
        //keyboardType: TextInputType.streetAddress,
        //onSaved: (newValue) => droplocation = newValue,
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
              //fontSize: 18,
              ),
          labelText: "Drop location",
          labelStyle: TextStyle(
              //fontSize: 18,
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

  ///

  ///

  dateField() {
    return Column(
      children: <Widget>[
        DateTimeField(
          //controller: datecontroller,
          cursorColor: Color(0xFFFF7643),
          keyboardType: TextInputType.datetime,
          // onSaved: (newValue) => {
          //    date = newValue,
          //   print("date on saved"),
          //   print(date),
          // },
          onChanged: (val) => {
            print("Formatted date: "),
            // date = DateFormat.yMMMMEEEEd().format(val),
            date = DateFormat('EEE, d LLLL y').format(val),
            print(date),
          },
          validator: (val) {
            date = DateFormat('EEE, d LLLL y').format(val);
            return date;
          },
          decoration: InputDecoration(
              hintText: 'Pick your Date',
              labelText: "Date (EEE, M/d/y)",
              labelStyle: TextStyle(
                  //color: kPrimaryColor,
                  )),
          format: dateformat,
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(
                    (DateTime.now().month <= 9)
                        ? DateTime.now().year
                        : DateTime.now().year + 1,
                    (DateTime.now().month <= 9)
                        ? DateTime.now().month + 3
                        : DateTime.now().month - 9));
          },
        ),
      ],
    );
  }

  timeField() {
    return Column(
      children: <Widget>[
        //Text('Basic time field (${format.pattern})'),
        DateTimeField(
          cursorColor: Color(0xFFFF7643),
          decoration: InputDecoration(
            labelText: "Time ( hh:mm:a )",
            labelStyle: TextStyle(
                //color: kPrimaryColor,
                ),
            hintText: "Time",
          ),
          onChanged: (val) => {
            time = DateFormat('h:mm a').format(val),
            print("formatted time: "),
            print(time),
          },
          format: timeformat,
          onShowPicker: (context, currentValue) async {
            final TimeOfDay time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return time == null ? null : DateTimeField.convert(time);
          },
        ),
      ],
    );
  }

  dropDownCarSelection() {
    return DropdownSearch<String>(
      validator: (v) => v == null ? "required field" : null,
      hint: "Select Car Type",
      mode: Mode.MENU,
      showSelectedItems: true,
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
        setState(() {
          cartype = value;
        });
        print("cartype is ");
        print(cartype);
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
}
