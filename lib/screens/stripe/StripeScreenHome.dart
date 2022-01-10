import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pool_your_car/screens/stripe/textf.dart';

class StripeScreenHome extends StatefulWidget {
  const StripeScreenHome({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StripeScreenHome> {
  Map<String, dynamic> paymentIntentData;
  String amount;
  @override
  Widget build(BuildContext context) {
    double screenHeight = (MediaQuery.of(context).size.height / 100);
    double screenWidth = (MediaQuery.of(context).size.width / 100);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7643),
        title: Text('Pay using Stripe'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 15,
            ),
            CustomTextField(
              hint: 'Enter Amount',
              lable: 'Amount',
              icon: Icons.payment,
              onText: (text) {
                amount = text;
              },
            ),
            InkWell(
              onTap: () async {
                await makePayment(amount);
              },
              child: Container(
                height: 50,
                width: 200,
                child: Center(
                    child: Text('Pay',
                        style: TextStyle(color: Colors.white, fontSize: 20))),
                decoration: BoxDecoration(
                  color: Color(0xFFFF7643),
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // child: Container(
              //   height: 50,
              //   width: 200,
              //   color: Colors.green,
              //   child: Center(
              //     child: Text(
              //       'Pay',
              //       style: TextStyle(color: Colors.white, fontSize: 20),
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(amount) async {
    try {
      paymentIntentData = await createPaymentIntent(
          '$amount', 'USD'); //json.decode(response.body);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          // Customer params
          customerId: paymentIntentData['customer'],
          // customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          // Extra params
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          testEnv: true,
          merchantCountryCode: 'DE',
        ),
      );

      print('initialised');
      await Stripe.instance.presentPaymentSheet();

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {} on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

//ammar repo
  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51KFcb7EZksxdhUi2iNA1uwK6ECpKYWnh6zRxu6uebIfJtwmLqowCJoMewJ3gu048vy11PSPeKt9o2Z8ldq3txRV400PYbdXjc1',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
