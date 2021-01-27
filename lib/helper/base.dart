import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:flutter/material.dart';

abstract class Base {

  static String get logo => 'assets/images/logo_fish.jpg';
  static String get placeholderImage => 'assets/images/placeholder.png';

  static String datenschutzStorageFilename = "files/privacy_policy.md";
  static String agbStorageFilename = "files/terms_and_conditions.md";
  static String impressumStorageFilename = "files/impressum.md";
  static const String appTitle = "Fisch aus dem Steinbachtal";
  static const double appbarHeight = 50.0;
  static const double bottomNavbarHeight = 100.0;

  static const String agbText =
      "Ich erkläre mich mit den\nNutzungsbedingungen einverstanden.\nBitte beachten Sie zudem unsere\nDatenschutzhinweise für die Nutzung\nder App \'$appTitle\'";
  static const String agbText2 =
      "Sie müssen die Nutzungsbedingungen akzeptieren";
 
  static buildArrow(bool expanded) {
    final _arrowHeight = 30.0;
    return Container(
      height: _arrowHeight,
      alignment: Alignment.center,
      child: Text(
        expanded ? "weniger" : "...mehr erfahren",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}

abstract class BaseStyles {
  static double get borderRadius => 25.0;

  static double get borderWidth => 2.0;

  static double get listFieldHorizontal => 25.0;

  static double get listFieldVertical => 8.0;

  static double get animationOffset => 2.0;

  static EdgeInsets get listPadding {
    return EdgeInsets.symmetric(
        horizontal: listFieldHorizontal, vertical: listFieldVertical);
  }

  static List<BoxShadow> get boxShadow {
    return [
      BoxShadow(
        color: AppColors.darkgray.withOpacity(.5),
        offset: Offset(1.0, 2.0),
        blurRadius: 2.0,
      )
    ];
  }

  static List<BoxShadow> get boxShadowPressed {
    return [
      BoxShadow(
        color: AppColors.darkgray.withOpacity(.5),
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
      )
    ];
  }

  static Widget iconPrefix(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(icon, size: 35.0, color: AppColors.lightblue),
    );
  }
}
