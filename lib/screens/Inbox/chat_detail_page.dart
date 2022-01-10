import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pool_your_car/models/CreateConversationResponseModel.dart';
import 'package:pool_your_car/models/GetSingleConversationResponseModel.dart';
import 'package:pool_your_car/models/SendMessageInConversationResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'body.dart';
import 'display_chat_message.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ChatDetailPage extends StatefulWidget {
  final String conversationId;
  final dynamic conversationList;
  final Map<String, dynamic> seconduserMap;
  ChatDetailPage({
    this.conversationList,
    @required this.conversationId,
    this.seconduserMap,
  });
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String myid = '';
  Map<String, dynamic> convoMap;
  List messageList = [];
  List<dynamic> reverseMessageList = [];
  String secondUserId = '';
  ScrollController scrollController;

  gettingSharedPreference() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    final SharedPreferences emailprefs = await preferences;
    String userid = prefs.getString("user");
    String _email = emailprefs.get("email");
    print("In chat detail screen");
    print("User id in shared preference is " + json.decode(userid));
    print("user email in shared preference is " + json.decode(_email));
    setState(() {
      myid = json.decode(userid);
    });
    connectToServer();
  }

  // Future<CreateConversationResponseModel> createConversation(
  //     String firstUserId, String secondUserId, String message) async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request(
  //       'POST', Uri.parse('$myip/api/conversation/createconversation'));
  //   request.body = json.encode({
  //     "firstUserId": firstUserId,
  //     "secondUserId": secondUserId,
  //     "message": [
  //       {
  //         "senderId": firstUserId,
  //         "text": message,
  //         "timestamp": DateTime.now().millisecondsSinceEpoch,
  //       }
  //     ]
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  Socket socket;

  void connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = io(
          '$myip',
          OptionBuilder()
              .setTransports(['websocket'])
              .enableForceNewConnection()
              .setQuery(<dynamic, dynamic>{
                'frontendconvoid': widget.conversationId,
                'myid': this.myid,
                'secondUserId': widget.seconduserMap['_id']
              })
              .build());

      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on(
          'connect',
          (_) => {
                print('connect: ${socket.id}'),
                // socket.emit('message', 'test'),
              });

      socket.on('typing', handleTyping);
      socket.on('message', handleMessage);
      socket.on('newmessage', handleNewMessage);
      socket.on('disconnect', (_) {
        print('disconnect');
      });
      socket.on('fromServer', (_) {
        print(_);
      });
    } catch (e) {
      print(e.toString());
    }
  }

// Send update of user's typing status
  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

// Listen to update of typing status from connected users
  dynamic handleTyping(dynamic data) {
    print(data);
  }

// Send a Message to the server
  sendMessage(String message) {
    print("in send message");
    socket.emit(
      "message",
      {
        "id": socket.id,
        "senderId": this.myid,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

// Listen to all message events from connected use rs
  dynamic handleMessage(dynamic data) {
    print(data);
  }

  dynamic handleNewMessage(dynamic data) {
    print(data['message']);
    setState(() {
      this.messageList = data['message'];
      // this.reverseMessageList = this.messageList.reversed;
    });
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  Future<GetSingleConversationResponseModel> getConversation() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$myip/api/conversation/getsingleconversation/${widget.conversationId}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      var _response = await http.Response.fromStream(response);
      setState(() {
        this.convoMap = jsonDecode(_response.body);
        this.secondUserId =
            this.convoMap['conversation']['secondUserId']['_id'];
        this.messageList = convoMap['conversation']['message'];
        // this.reverseMessageList = this.messageList.reversed;
      });
      // this.messageList.map((e) => print(e));
      print("convo id is");
      print(this.convoMap['conversation']['_id']);
      print(this.messageList[0]);
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 600), curve: Curves.ease);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<SendMessageInConversationResponseModel> sendMessageToExistingConvo(
      String message) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'PUT',
        Uri.parse(
            '$myip/api/conversation/appendmessageinconversation/${widget.conversationId}'));
    request.body = json.encode({
      "senderId": this.myid,
      "text": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var _response = await http.Response.fromStream((response));
      Map<String, dynamic> responseMap = jsonDecode(_response.body);
      setState(() {
        this.messageList = responseMap['conversation']['message'];
        //this.reverseMessageList = this.messageList.reversed;
      });
      // scrollController.jumpTo(scrollController.position.maxScrollExtent);
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 600), curve: Curves.ease);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  callsharedpreffunction() async {
    await gettingSharedPreference();
  }

  @override
  void initState() {
    super.initState();
    getConversation();
    callsharedpreffunction();
    scrollController = ScrollController();
    // connectToServer();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _messageController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircleAvatar(
                    backgroundImage: widget
                                .seconduserMap['profile_image_url'] !=
                            null
                        ? NetworkImage(
                            "$myip/images/${widget.seconduserMap['profile_image_url']}")
                        : AssetImage("assets/images/Profile Image.png"),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.seconduserMap['firstname'] +
                            ' ' +
                            widget.seconduserMap['lastname'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      // SizedBox(
                      //   height: 3,
                      // ),
                      // Text(
                      //   "Online",
                      //   style: TextStyle(
                      //       color: Colors.grey.shade600, fontSize: 13),
                      // ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //print(widget.conversationList);
                    //print(myid);
                    // print(this.convoMap['conversation']['secondUserId']
                    //     ['phonenumber']);
                    //List rev = this.messageList.reversed;
                    // print(this.messageList.reversed);
                    _makePhoneCall(this.convoMap['conversation']['secondUserId']
                        ['phonenumber']);
                  },
                  child: Icon(
                    Icons.phone,
                    //color: Colors.black54,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Icon(
                //   Icons.settings,
                //   //color: Colors.black54,
                //   color: kPrimaryColor,
                //   size: 30,
                // ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                this.messageList != null
                    ? ListView.builder(
                        itemCount: this.messageList.length,
                        controller: scrollController,
                        //reverse: true,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: (this.messageList[index]
                                              ['senderId'] ==
                                          widget.seconduserMap['_id']
                                      // widget.seconduserMap['_id']
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (this.messageList[index]
                                                  ['senderId'] ==
                                              widget.seconduserMap['_id']
                                          ? Colors.grey.shade200
                                          : Colors.orange),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      this.messageList[index]['text'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                //if(messages[index]==messages.length) ?SizedBox(height: 45):null,
                              ],
                            ),
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 100),
              ],
            ),
          ),
          //SizedBox(height: 45),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 100,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     height: 30,
                  //     width: 30,
                  //     decoration: BoxDecoration(
                  //       color: kPrimaryColor,
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Icon(
                  //       Icons.add,
                  //       color: Colors.white,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 15,
                  // ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _messageController,
                        // minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      print(_messageController.text);
                      // await createConversation(myid,
                      //     widget.seconduserMap['_id'], _messageController.text);
                      sendMessage(
                        _messageController.text,
                      );
                      // await sendMessageToExistingConvo(
                      //   _messageController.text,
                      // );
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.ease,
                      );
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: kPrimaryColor,
                    splashColor: Colors.white,
                    elevation: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
