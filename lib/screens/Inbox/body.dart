//import 'package:bla_bla_car_clone/ui/utils/colors.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/models/InboxChatsResponseModel.dart';
import 'package:pool_your_car/screens/Inbox/conversation_list.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../../size_config.dart';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUsers({
    @required this.name,
    @required this.messageText,
    @required this.imageURL,
    @required this.time,
  });
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Map<String, dynamic> convoMap;
  Map<String, dynamic> firstUserMap;
  Map<String, dynamic> secondUserMap;
  String myid = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List conversations = [];
  Future<InboxChatsResponseModel> getConversations() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    String userid = prefs.getString("user");
    userid = json.decode(userid);
    //print(userid);
    setState(() {
      this.myid = userid;
    });
    print('my id is' + myid);

    String url = '$myip/api/conversation/getusersallconversations/$userid';
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();
    //Loader.hide();
    _refreshController.refreshCompleted();
    if (response.statusCode == 200) {
      var _response = await http.Response.fromStream(response);
      // print(jsonDecode(_response.body));

      setState(() {
        this.convoMap = jsonDecode(_response.body);
      });
      print(jsonDecode(_response.body));
      if (this.convoMap['conversations'] != null) {
        setState(() {
          this.conversations = convoMap['conversations'];
        });
        //print(this.conversations);
      }
      if (this.convoMap['conversations'] == null) {
        print("conversation array is null");
      }

      // print(this.conversations[0]['firstUserId']['_id']);
      // print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    //super.initState();
    getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: getConversations,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ElevatedButton(
                //   onPressed: getConversations,
                //   child: Text("data"),
                // ),
                this.conversations.length > 0
                    ? ListView.builder(
                        itemCount: this.conversations.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 5),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ConversationList(
                            getConversations: this.getConversations,
                            conversationId: this.conversations[index]['_id'],
                            conversationDetails: this.conversations[index],
                            messageList: this.conversations[index]['message'],
                            otherUserMap: this.conversations[index]
                                        ['firstUserId']['_id'] ==
                                    myid
                                ? this.conversations[index]['secondUserId']
                                : this.conversations[index]['firstUserId'],
                            isMessageRead:
                                (index == 0 || index == 3 || index == 5)
                                    ? true
                                    : false,
                          );
                        },
                      )
                    : Container(
                        // child: Center(
                        //   child: Text(
                        //     "No Conversations",
                        //     style: TextStyle(
                        //       // color: Colors.black,
                        //       fontSize: getProportionateScreenWidth(28),
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
