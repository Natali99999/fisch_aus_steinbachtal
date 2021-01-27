import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(IconData icons, String hinttext ) {
  return InputDecoration(
    labelText: hinttext,
    hintText: hinttext,
    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.green, width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: AppColors.lightblue,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: AppColors.lightblue,
        width: 1.5,
      ),
    ),
    
  );
}
