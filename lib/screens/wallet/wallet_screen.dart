

import 'package:flutter/material.dart';
import './components/body.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key key }) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Body();
  }
}