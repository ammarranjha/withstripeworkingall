// ignore_for_file: missing_return, non_constant_identifier_names, deprecated_member_use

import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pool_your_car/models/GetUserResponseModel.dart';
import 'package:pool_your_car/models/UserProfileImageResponseModel.dart';
import '../../../size_config.dart';
import '../../../constants.dart';
import '../../../components/default_button.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import './edit_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class Body extends StatefulWidget {
  final String sharedprefenrenceid;
  Body({
    Key key,
    @required this.sharedprefenrenceid,

    //this.image,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //String id = sharedprefenrenceid;
  String id = "";
  String firstName = ''; //= "Abdul";
  String lastName = ''; // = "Rehman";
  String email = ''; //= "abc@gmail.com";
  String phoneNumber = ''; // = "03211234567";
  String password = "abcdefghij";
  bool email_verified = false;
  bool image_is_uploaded = false;
  String user_profile_image_url;
  File image;
  final picker = ImagePicker();
  GetUserResponseModel user;
  @override
  void initState() {
    //this.gettingSharedPreference();
    this.GetUserDetails();
    super.initState();
  }

  Future getMyImage() async {
    String fileName = "";
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        this.image = File(pickedImage.path);
        setState(() {
          image_is_uploaded = true;
          fileName = pickedImage.path.split('/').first;
        });
      }

      // print(image.path);
      // print("FileName");
      // print(fileName);
      // print("Image path");
      // print(pickedImage.path);
    });
    Future<UserProfileImageResponseModel> postImage() async {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '$myip/api/upload_profile_image/${widget.sharedprefenrenceid}'));
      request.files
          .add(await http.MultipartFile.fromPath('image', pickedImage.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Printing response");
        //print(jsonDecode(response.stream.toString()));
        // Fluttertoast.showToast(
        //   msg: "Image Uploaded",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.SNACKBAR,
        //   backgroundColor: kPrimaryColor,
        //   textColor: Colors.white,
        //   fontSize: 20.0,
        // );
        CherryToast.success(
          toastDuration: Duration(seconds: 5),
          title: "",
          enableIconAnimation: false,
          displayTitle: false,
          description: "Image Uploaded",
          toastPosition: POSITION.BOTTOM,
          animationDuration: Duration(milliseconds: 1000),
          autoDismiss: true,
        ).show(context);

        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }

    if (pickedImage != null) await postImage();
  }

  Future<GetUserResponseModel> GetUserDetails() async {
    final response = await http.get(
        Uri.parse("$myip/api/getsingleuser/${widget.sharedprefenrenceid}"));
    if (response.statusCode == 200) {
      print("Now Getting user data in profile details screen");
      print(jsonDecode(response.body));
      print("//");
      Map<String, dynamic> responseJson = json.decode(response.body);
      // ignore: unused_local_variable
      var _user = json.decode(response.body);
      //json.decode(response.body).cast<ObjectName>();
      user = GetUserResponseModel.fromJson(jsonDecode(response.body));
      print("after storing to object ");
      setState(() {
        this.id = responseJson['_id'];
        this.firstName = responseJson['firstname'];
        this.lastName = responseJson['lastname'];
        this.email = responseJson['email'];
        this.phoneNumber = responseJson['phonenumber'];
        //this.email_verified = responseJson['emailverified'];
        if (responseJson['emailverified'] == true) {
          this.email_verified = true;
        }

        if (responseJson['profile_image_url'] != null) {
          this.image_is_uploaded = true;
          // this.user_profile_image_url =
          //     responseJson['profile_image_url'].split('public')[1];
          this.user_profile_image_url = responseJson['profile_image_url'];
          print("Printing image url");
          print(this.user_profile_image_url);
          // print(url[0]);
        }
      });

      //print(responseJson['email']);
      return GetUserResponseModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: [
                  CircleAvatar(
                    // backgroundImage: image == null
                    //     ? AssetImage("assets/images/Profile Image.png")
                    //     : FileImage(image),
                    // backgroundImage: !this.image_is_uploaded
                    backgroundImage: this.image_is_uploaded == true
                        ? NetworkImage(
                            "$myip/images/${this.user_profile_image_url}")
                        : image == null
                            ? AssetImage("assets/images/Profile Image.png")
                            : FileImage(image),
                  ),
                  Positioned(
                    right: -16,
                    bottom: 0,
                    child: SizedBox(
                      height: 46,
                      width: 46,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white),
                        ),
                        color: Color(0xFFF5F6F9),
                        onPressed: () {
                          getMyImage();
                        },
                        child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                      ),

                      // child: DropdownButton<String>(
                      //   //value: "Gallery",
                      //   //icon: const Icon(Icons.arrow_downward),
                      //   icon: SvgPicture.asset(
                      //     "assets/icons/Camera Icon.svg",
                      //     color: Colors.black,
                      //   ),
                      //   //iconSize: 24,
                      //   elevation: 16,
                      //   // style: const TextStyle(color: Colors.deepPurple),
                      //   underline: Container(
                      //     height: 2,
                      //     color: kPrimaryColor,
                      //   ),
                      //   onChanged: (String newValue) {

                      //     if (newValue=="Gallery"){
                      //       print("Gallery");
                      //     }
                      //     else{
                      //       print("Camera");
                      //     }
                      //   },
                      //   items: <String>['Gallery', 'Camera']
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.03),
            Row(
              children: [
                Text(
                  "First Name",
                  style: TextStyle(
                    //fontSize: getProportionateScreenWidth(10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "$firstName",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            //SizedBox(height: SizeConfig.screenHeight * 0.02),
            Divider(thickness: 1.5, color: kPrimaryColor),
            SizedBox(height: SizeConfig.screenHeight * 0.02),

            Row(
              children: [
                Text(
                  "Last Name",
                  style: TextStyle(
                    //fontSize: getProportionateScreenWidth(10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "$lastName",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            //SizedBox(height: SizeConfig.screenHeight * 0.02),
            Divider(thickness: 1.5, color: kPrimaryColor),
            SizedBox(height: SizeConfig.screenHeight * 0.02),

            Row(
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    //fontSize: getProportionateScreenWidth(10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '$email',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            //SizedBox(height: SizeConfig.screenHeight * 0.02),
            Divider(thickness: 1.5, color: kPrimaryColor),
            // this.email_verified
            //     ? Container()
            //     : GestureDetector(
            //         onTap: () {
            //           print("verify email address clicked");
            //         },
            //         child: Row(
            //           children: [
            //             Text(
            //               "verify email address",
            //               style: TextStyle(
            //                 color: kPrimaryColor,
            //                 fontSize: getProportionateScreenWidth(15),
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            SizedBox(height: SizeConfig.screenHeight * 0.02),

            Row(
              children: [
                Text(
                  "Phone Number",
                  style: TextStyle(
                    //fontSize: getProportionateScreenWidth(10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "$phoneNumber",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            //SizedBox(height: SizeConfig.screenHeight * 0.02),
            Divider(thickness: 1.5, color: kPrimaryColor),
            SizedBox(height: SizeConfig.screenHeight * 0.05),
            DefaultButton(
              text: "Edit Profile",
              press: () {
                print("Edit Profile");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      id: this.id,
                      firstName: this.firstName,
                      lastName: this.lastName,
                      email: this.email,
                      phoneNumber: this.phoneNumber,
                      password: this.password,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.05),
            // SizedBox(
            //   width: double.infinity,
            //   height: getProportionateScreenHeight(50),
            //   child: FlatButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20)),
            //     color: kPrimaryColor,
            //     onPressed: () async {
            //       if (await confirm(
            //         context,
            //         title: Text('Confirm'),
            //         content:
            //             Text('Are you sure you want to Delete your account?'),
            //         textOK: Text('Yes'),
            //         textCancel: Text('No'),
            //       )) {
            //         return {
            //           print('pressedOK'),
            //           print("Ok is pressed"),
            //         };
            //       }
            //       return print('pressedCancel');
            //     },
            //     child: Text(
            //       "Delete Account",
            //       style: TextStyle(
            //         fontSize: getProportionateScreenWidth(18),
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  dropDownSelection() {
    return DropdownSearch<String>(
      validator: (v) => v == null ? "required field" : null,
      //hint: "Select Car Type",
      mode: Mode.MENU,
      //showSelectedItems: true,
      //maxHeight: 70,
      //searchBoxDecoration: ,
      items: [
        "Open Gallery",
        "Open Camera",
      ],
      //label: "Menu mode *",
      //showClearButton: true,
      onChanged: (value) {
        setState(() {
          // cartype = value;
        });
        print("cartype is ");
        // print(cartype);
      },
    );
  }
}
