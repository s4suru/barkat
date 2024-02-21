import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(msg)));

String getFormattedDate (DateTime dateTime, String pattern) {
  return DateFormat(pattern).format(dateTime);
}

 void navigateTo(BuildContext context,Widget widget) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => widget), (route) => false);
  }

