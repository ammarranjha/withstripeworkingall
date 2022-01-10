import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key key,
    this.icon,
    this.onText,
    this.radius,
    this.height,
    this.backgroundColor,
    this.hintText,
    this.textFormat,
    this.lable,
    this.hint,
  }) : super(key: key);

  final IconData icon;
  final Function onText;
  double radius;
  double height;
  Color backgroundColor;
  String lable;
  String hint;
  Widget hintText;
  List<TextInputFormatter> textFormat;

  @override
  Widget build(BuildContext context) {
    double screenHeight = (MediaQuery.of(context).size.height / 100);
    double screenWidth = (MediaQuery.of(context).size.width / 100);
    return Container(
        height: screenHeight * 7,
        width: screenWidth * 80,
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 2,
          horizontal: screenWidth * 10,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        ),
        child: TextFormField(
            inputFormatters: textFormat,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
                hintText: hint,
                labelText: lable,
                prefixIcon: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 10,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
                )),
            onChanged: (text) {
              onText(text);
            }));
  }
}
