import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constant {
  static const String appName = "My Call";
  static const String testMainBaseUrl = "";
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static void showLongToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showShortToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
