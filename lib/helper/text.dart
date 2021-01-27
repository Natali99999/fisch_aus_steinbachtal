import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TextStyles {
  static TextStyle get title {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: AppColors.darkblue,
            fontWeight: FontWeight.bold,
            fontSize: 40.0));
  }

  static TextStyle get subtitle {
    return GoogleFonts.economica(
        textStyle: TextStyle(
            color: AppColors.lightblue,
            fontWeight: FontWeight.bold,
            fontSize: 30.0));
  }

  static TextStyle get listTitle {
    return GoogleFonts.economica(
        textStyle: TextStyle(
            color: AppColors.lightblue,
            fontWeight: FontWeight.bold,
            fontSize: 25.0));
  }

  static TextStyle get navTitle {
    return GoogleFonts.poppins(
        textStyle:
            TextStyle(color: AppColors.darkblue, fontWeight: FontWeight.bold));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }

  static TextStyle get body {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.darkgray, fontSize: 16.0));
  }

  static TextStyle get logoStyle {
    return GoogleFonts.mansalva(
        textStyle: TextStyle(color: Colors.blue, fontSize: 24.0));
  }

  static TextStyle get logoStyle2 {
    return GoogleFonts.mansalva(
        textStyle: TextStyle(
      color: Colors.blue,
      fontSize: 22.0, /*fontWeight: FontWeight.bold*/
    ));
  }

  static TextStyle get bodyLightBlue {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.lightblue, fontSize: 16.0));
  }

  static TextStyle get bodyRed {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.red, fontSize: 16.0));
  }

  static TextStyle get picker {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.darkgray, fontSize: 35.0));
  }

  static TextStyle get link {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: AppColors.straw,
            fontSize: 16.0,
            fontWeight: FontWeight.bold));
  }

  static TextStyle get suggestion {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.lightgray, fontSize: 14.0));
  }

  static TextStyle get error {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.red, fontSize: 12.0));
  }

  static TextStyle get buttonTextLight {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold));
  }

  static TextStyle get buttonTextDark {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: AppColors.darkgray,
            fontSize: 17.0,
            fontWeight: FontWeight.bold));
  }

  static TextStyle get navButtonsTitleStyle {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: Colors.black.withOpacity(0.9),
            fontSize: 14.0,
            fontWeight: FontWeight.w500));
  }

    static TextStyle get navButtonsSelectedTitleStyle {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15.0,
            fontWeight: FontWeight.w500));
  }

  static TextStyle get pageSubtitleStyle {
    
   /*  return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: const Color(0xff47455f),
            fontSize:  22,
            fontWeight: FontWeight.w400));*/
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: 25,
      color: const Color(0xff47455f),
      fontWeight: FontWeight.w300,
    );
  }

   static TextStyle get pageTitleStyle {
    /* return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: const Color(0xff47455f),
            fontSize:  25,
            fontWeight: FontWeight.w400));*/
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: 28,
      color: const Color(0xff47455f),
      fontWeight: FontWeight.w400,
    );
  }

   static TextStyle get pageNormalStyle {
  /*   return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: const Color(0xff47455f),
            fontSize:  20,
            fontWeight: FontWeight.w300));*/
    return TextStyle(
      fontFamily: 'Avenir',
      fontSize: 18.0,
    );
  }
}
