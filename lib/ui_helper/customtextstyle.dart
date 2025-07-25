import 'package:flutter/material.dart';
TextStyle mTextStyle11({
  Color textColor = Colors.blue,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    fontSize: 11,
    fontWeight: fontWeight,   // use the parameter
    color: textColor,         // use the parameter
  );
}

TextStyle mTextStyle16() {
  return  TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
TextStyle mTextStyle20() {
  return  TextStyle(
    fontSize: 20,
  );
}
