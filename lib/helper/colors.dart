import 'package:flutter/material.dart';

abstract class AppColors {
  static Color get darkgray => const Color(0xFF4e5b60);

  static Color get lightgray => const Color(0xFFc8d6ef);

  static Color get darkblue => const Color(0xFF263a44);

  static Color get lightblue => const Color(0xFF48a1af);

  static Color get straw => const Color(0xFFe2a84b);

  static Color get red => const Color(0xFFee5253);

  static Color get green => const Color(0xFF3b7d02);

  static Color get facebook => const Color(0xFF3b5998);

  static Color get google => const Color(0xFF4285f4);
}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
  static List<Color> grey1 = [Color(0xFFA9A9A9), Color(0xFFDCDCDC)];
  static List<Color> bluegray = [Color(0xFFe2a84b), Color(0xFFDCDCDC)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
    GradientColors(GradientColors.grey1),
    GradientColors(GradientColors.bluegray),
  ];
}
