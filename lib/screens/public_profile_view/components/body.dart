import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/components/default_button.dart';
import 'package:pool_your_car/models/CreateConversationResponseModel.dart';
import 'package:pool_your_car/models/GetUserResponseModel.dart';
import 'package:pool_your_car/screens/Inbox/chat_detail_page.dart';
import 'package:pool_your_car/screens/public_profile_view/components/public_user_chat_detail_page.dart';
import 'package:pool_your_car/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final String userid;
  Body({
    Key key,
    @required this.userid,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String id = "";
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';

  bool email_verified = false;
  bool image_is_uploaded = false;
  String user_profile_image_url;
  String sharedprefenrenceid = '';
  bool createNewConversation = false;
  dynamic convoMap;
  Map<String, dynamic> userMap;

  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    // print("In home screen");
    // print("User id in shared preference is " + json.decode(userid));
    // print("user email in shared preference is " + json.decode(_email));
    setState(() {
      sharedprefenrenceid = json.decode(userid);
    });
  }

  Future<CreateConversationResponseModel> createConversation(
      String firstUserId, String secondUserId, String message) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('$myip/api/conversation/createconversation'));
    request.body = json.encode({
      "firstUserId": firstUserId,
      "secondUserId": secondUserId,
      "message": []
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //var res = await response.stream.bytesToString();
      var _response = await http.Response.fromStream(response);
      Map<String, dynamic> convo = jsonDecode(_response.body);
      setState(() {
        convoMap = convo['conversation'];
      });
      print('printing convo map in create convo funciton');
      print(convoMap);
      //print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future checkConversationExists() async {
    print('my id ' + this.sharedprefenrenceid);
    print('second user id ' + widget.userid);
    var res;
    String url =
        '$myip/api/conversation/searchconversationexists/${this.sharedprefenrenceid}/${widget.userid}';
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      res = await response.stream.bytesToString();

      // print(res);
      if (res == "\"Create New Conversation\"") {
        print("creating new convo");
        await createConversation(this.sharedprefenrenceid, widget.userid, '');
        // setState(() {
        //   this.createNewConversation = true;
        // });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PublicUserChatDetailPage(
                ///createNewConversation: this.createNewConversation,
                conversationMap: convoMap,
                userMap: this.userMap,
              ),
            ));
      } else {
        print("convo found");
        Map<String, dynamic> getconvoinres = jsonDecode(res);
        setState(() {
          convoMap = getconvoinres['conversation'];
        });

        print(convoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PublicUserChatDetailPage(
                // createNewConversation: this.createNewConversation,
                conversationMap: convoMap,
                userMap: this.userMap,
              ),
            ));
      }
    } else {
      print(response.statusCode);
    }
  }

  Future<GetUserResponseModel> GetUserDetails() async {
    print("object");
    print(widget.userid);
    final response =
        await http.get(Uri.parse("$myip/api/getsingleuser/${widget.userid}"));
    if (response.statusCode == 200) {
      // print("Now Getting user data in profile details screen");
      // print(jsonDecode(response.body));
      // print("//");
      setState(() {
        userMap = json.decode(response.body);
      });
      // ignore: unused_local_variable
      var _user = json.decode(response.body);
      //json.decode(response.body).cast<ObjectName>();
      var user = GetUserResponseModel.fromJson(jsonDecode(response.body));
      print("after storing to object ");
      setState(() {
        this.id = userMap['_id'];
        this.firstName = userMap['firstname'];
        this.lastName = userMap['lastname'];
        this.email = userMap['email'];
        this.phoneNumber = userMap['phonenumber'];
        //this.email_verified = userMap['emailverified'];
        if (userMap['emailverified'] == true) {
          this.email_verified = true;
        }

        if (userMap['profile_image_url'] != null) {
          this.user_profile_image_url = userMap['profile_image_url'];
          print("Printing image url");
          print(this.user_profile_image_url);
          setState(() {
            this.image_is_uploaded = true;
          });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUserDetails();
    gettingSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                backgroundImage: this.image_is_uploaded
                    ? NetworkImage(
                        "$myip/images/${this.user_profile_image_url}")
                    : AssetImage("assets/images/Profile Image.png"),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.06),
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
            Divider(thickness: 1.5, color: kPrimaryColor),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
            // Row(
            //   children: [
            //     Text(
            //       "Send Message",
            //       style: TextStyle(
            //         color: kPrimaryColor,
            //         //fontSize: getProportionateScreenWidth(10),
            //         fontWeight: FontWeight.w700,
            //       ),
            //     ),
            //   ],
            // ),
            DefaultButton(
              text: "Send Message",
              press: () {
                checkConversationExists();
                // print(convoMap['message']);
              },
            ),

            SizedBox(height: SizeConfig.screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
