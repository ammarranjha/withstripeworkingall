import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/helper/keyboard.dart';
import '../../../size_config.dart';

import 'autocomplete_textfield.dart';
import 'remaining_body_one.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  String pickuplocation;
  String droplocation;
  String email;
  String date, mytime;
  // ignore: non_constant_identifier_names
  String pickup_Lat, pickup_Lon, drop_Lat, drop_Lon;
  TextEditingController pickupcontroller = TextEditingController();
  TextEditingController dropcontroller = TextEditingController();
  //TextEditingController datecontroller = TextEditingController();

  final List<String> errors = [];
  final String kGoogleApiKey = "AIzaSyDkYPrBWAp4X2newWTdFEaKc4clrawnvgU";

  final dateformat = DateFormat(
      "yMMMMEEEEd"); //DateFormat("EEE, d/MMMM/y"); // before yyyy-MM-dd, after EEE, d LLLL y
  final timeformat = DateFormat("h:mm a");
  TimeOfDay _selectedTime;

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
    return Form(
      key: _formKey,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
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
                  FormError(errors: errors),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  DefaultButton(
                    text: "Next",
                    press: () {
                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();

                      //print("Moving to next offer ride details screen");
                      //KeyboardUtil.hideKeyboard(context);
                      if (dropcontroller.text.isEmpty ||
                          pickupcontroller.text.isEmpty ||
                          date == null ||
                          mytime == null) {
                        Fluttertoast.showToast(
                          msg: "Enter all data",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          fontSize: 20.0,
                        );
                      } else {
                        print("pickup details : " + this.pickupcontroller.text);
                        print("pickup lat: " +
                            pickup_Lat +
                            "  pickup long:  " +
                            pickup_Lon);
                        print("drop detail:  " + this.dropcontroller.text);
                        print("drop lat: " +
                            drop_Lat +
                            "  drop long:  " +
                            drop_Lon);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RemainingBodyOne(
                                    pickuplocation: pickupcontroller.text,
                                    pickup_Lat: this.pickup_Lat,
                                    pickup_Lon: this.pickup_Lon,
                                    droplocation: this.dropcontroller.text,
                                    drop_Lat: this.drop_Lat,
                                    drop_Lon: this.drop_Lon,
                                    date: this.date,
                                    time: this.mytime,
                                  )),
                        );
                      }
                      //}
                    },
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                ],
              ),
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
      //controller: datecontroller,
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
              )),
      format: dateformat,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),

            lastDate: DateTime(
              (DateTime.now().month <= 9) ? DateTime.now().year: DateTime.now().year + 1,
              (DateTime.now().month <= 9) ? DateTime.now().month + 3 : DateTime.now().month - 9
            )
        );

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
}
