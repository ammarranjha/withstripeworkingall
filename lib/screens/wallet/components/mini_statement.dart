import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/models/MiniStatementModel.dart';
import 'package:pool_your_car/screens/wallet/components/mini_statement_tile.dart';

class MiniStatement extends StatefulWidget {
  const MiniStatement({Key key, @required this.userId}) : super(key: key);
  final String userId;

  @override
  _MiniStatementState createState() => _MiniStatementState();
}

class _MiniStatementState extends State<MiniStatement> {
  List<MiniStatementModel> miniStatement = [];
  String message = '';

  Future<void> getMiniStatement() async {
    http.Response response =
        await http.post(Uri.parse('$myip/api/payment/getministatements'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'userId': widget.userId,
            }));

    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        miniStatement = (json.decode(response.body) as List<dynamic>)
            .map((data) => MiniStatementModel.fromMap(data))
            .toList();
      });
    } else {
      setState(() {
        message = 'No Payment History';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMiniStatement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: miniStatement.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                children: List.generate(miniStatement.length, (index) {
                  return MiniStatementTile(
                      userId: widget.userId,
                      miniStatementModel: miniStatement[index]);
                }),
              ))
            : Center(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }
}
