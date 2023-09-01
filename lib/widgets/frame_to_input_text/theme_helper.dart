import 'package:flutter/material.dart';

class ThemeHelper {
  InputDecoration textInputDecoration(
      [String lableText = "", String hintText = ""]) {
    return InputDecoration(
      labelText: lableText,
      labelStyle: TextStyle(color: Colors.grey),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }
}