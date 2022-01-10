import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/screens/Inbox/chat_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationList extends StatefulWidget {
  String conversationId;
  bool isMessageRead;
  dynamic conversationDetails;
  dynamic otherUserMap;
  List messageList;
  Function getConversations;
  ConversationList({
    @required this.conversationId,
    @required this.messageList,
    @required this.isMessageRead,
    @required this.conversationDetails,
    @required this.otherUserMap,
    @required this.getConversations,
  });
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  String myid = '';
  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    print("In Conversation list screen");
    print("User id in shared preference is " + json.decode(userid));
    print("user email in shared preference is " + json.decode(_email));
    setState(() {
      myid = json.decode(userid);
    });

    //GetUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.conversationId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatDetailPage(
                  conversationId: widget.conversationId,
                  seconduserMap: widget.otherUserMap,
                  conversationList: this.widget.messageList);
            },
          ),
        ).then((_) => {widget.getConversations()});
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: widget
                                  .otherUserMap['profile_image_url'] !=
                              null
                          ? NetworkImage(
                              "$myip/images/${widget.otherUserMap['profile_image_url']}")
                          : AssetImage("assets/images/Profile Image.png"),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.otherUserMap['firstname'] +
                                ' ' +
                                widget.otherUserMap['lastname'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "${widget.messageList[widget.messageList.length - 1]['text']}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   "widget.time",
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 12,
            //       fontWeight: widget.isMessageRead
            //           ? FontWeight.w700
            //           : FontWeight.normal),
            // ),
          ],
        ),
      ),
    );
  }
}
