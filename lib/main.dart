import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pool_your_car/constants.dart';
import 'package:pool_your_car/routes.dart';
import 'package:pool_your_car/screens/splash/splash_screen.dart';
import 'package:pool_your_car/theme.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TextEditingController txtController = TextEditingController();

  Stripe.publishableKey =
      'pk_test_51KFcb7EZksxdhUi2cePYZhBPDSo3maQqaOwbHHEK52TrrBibabNQ4p7v0e1SbDx5cn3uD15vEN7ZE0zaZqhvYTru00hJ0ygw1a';
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Socket socket;

  @override
  void initState() {
    super.initState();
    //connectToServer();
  }

  void connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = io('$myip', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to websocket
      socket.connect();

      // Handle socket events
      socket.on('connect', (_) => print('connect: ${socket.id}'));

      socket.on('typing', handleTyping);
      socket.on('message', handleMessage);
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
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
  void handleTyping(Map<String, dynamic> data) {
    print(data);
  }

// Send a Message to the server
  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

// Listen to all message events from connected users
  void handleMessage(Map<String, dynamic> data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pool Your Car',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
