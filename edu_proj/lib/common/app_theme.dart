// import 'package:flutter/cupertino.dart';
// import 'package:couver_app/theme/c_input_border.dart';
import 'package:edu_proj/common/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'dart:io';

import 'package:flutter/services.dart';

@immutable
class AppTheme {
  // static const colors = AppColors();

  // const AppTheme._();

  static ThemeData light() {
    bool isIOS = false;
    try {
      if (Platform.isIOS) {
        isIOS = true;
      }
    } catch (e) {}
    return ThemeData(
      splashFactory: isIOS ? NoSplash.splashFactory : null,

      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.palette,
        accentColor: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        elevation: 0,
        color: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
      ),
      scaffoldBackgroundColor: const Color(0XFFFBF9F9),
      cardTheme: const CardTheme(
        elevation: 10,
        shadowColor: Colors.black12,
      ),
      // inputDecorationTheme: const InputDecorationTheme(
      //   border: COutlineInputBorder(
      //     borderRadius: BorderRadius.all(
      //       Radius.circular(8),
      //     ),
      //   ),
      //   filled: true,
      //   fillColor: Colors.white,
      //   isCollapsed: true,
      // ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        // isCollapsed: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          splashFactory: InkSplash.splashFactory,
          elevation: MaterialStateProperty.all<double>(0),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.palette,
        accentColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.grey[900],
        titleTextStyle: const TextStyle(fontSize: 17),
        // color: Color(0xff050505),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      cardTheme: const CardTheme(
        elevation: 0,
        shadowColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
        ),
      ),
    );
  }
}
