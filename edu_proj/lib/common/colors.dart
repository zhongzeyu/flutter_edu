import 'package:flutter/material.dart';

// @immutable
class AppColors {
  static const MaterialColor palette = MaterialColor(
    // 0xff33b6d5,
    0xFF052F3F, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE1E6E8),
      100: Color(0xFFB4C1C5),
      200: Color(0xFF82979F),
      300: Color(0xFF506D79),
      400: Color(0xFF2B4E5C),
      500: Color(0xFF052F3F),
      600: Color(0xFF042A39),
      700: Color(0xFF042331),
      800: Color(0xFF031D29),
      900: Color(0xFF01121B),
    },
  );

  const AppColors();
}
