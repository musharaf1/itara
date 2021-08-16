/// Itara Mobile Theme
/// @version: v.1.0.1+1
/// @author: Praise<praisegeek@gmail.com>
/// @license: MIT

import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Colors
  static const Color _lightPrimaryColor = Color(0xFFFFA100);
  static const Color _lightPrimaryVariantColor = Color(0xFFFF6E00);
  static const Color _lightSecondaryColor = Colors.black;
  static const Color _lightOnPrimaryColor = Colors.white;

  // Accents
  static final Map<String, Color> accents = {
    "surface": Color(0xFFF6F6F6),
    "grey": Color(0xFFD4D4D4),
    "muted": Color(0xFFD4D4D4).withOpacity(0.2),
    "light": Color(0xFFFFBD00),
    "orange": Color(0xFFFFA500),
    "white": Colors.white,
    "black": Colors.black,
    "icon": Colors.orangeAccent.shade200,
    "textMuted": Colors.black54,
  };

  // Icon
  static Color iconColor = Colors.orangeAccent.shade200;

  // shadows
  static final Map<String, BoxShadow> shadows = {
    "product": BoxShadow(
      offset: Offset(0, 2),
      color: Colors.black12,
      blurRadius: 3,
    ),
    "subtle": BoxShadow(
      offset: Offset(0, -2),
      color: Colors.black12,
      blurRadius: 6,
    ),
  };

  // Gradients
  static final Map<String, Gradient> gradients = {
    "dark": LinearGradient(
      colors: [
        Color(0xFF17181A),
        Color(0xFF343841),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.5, 1.0],
    ),
    "colored": LinearGradient(
      colors: [
        accents["light"]!,
        Color(0xFFFF8900),
      ],
      stops: [0.3, 1.0],
      transform: GradientRotation(math.pi / 4),
    ),
    "colored-inverse": LinearGradient(
      colors: [
        accents["light"]!,
        Color(0xFFFFbd00),
      ],
      // center: FractionalOffset.center,
      // startAngle: 0.0,
      // endAngle: math.pi * 2,
      stops: [0.3, 1.0],
      transform: GradientRotation(math.pi),
    ),
  };

  // Core
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFF6F6F6),
    fontFamily: "WorkSans",
    appBarTheme: AppBarTheme(
      // color: _lightPrimaryColor,
      elevation: 0,
      color: Colors.transparent,
      iconTheme: IconThemeData(
        color: _lightPrimaryVariantColor,
      ),
      centerTitle: true,
      textTheme: _lightTextTheme.copyWith(
        headline6: _lightTextTheme.headline6!.copyWith(
          color: Colors.black,
          // fontWeight: FontWeight.w400,
        ),
      ),
      brightness: Brightness.light,
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryVariant: _lightPrimaryVariantColor,
      secondary: _lightSecondaryColor,
      onPrimary: _lightOnPrimaryColor,
    ),
    iconTheme: IconThemeData(color: _lightPrimaryVariantColor),
    textTheme: _lightTextTheme,
    inputDecorationTheme: textInputTheme,
    indicatorColor: _lightPrimaryVariantColor,
    hintColor: Colors.black26,

    toggleButtonsTheme: ToggleButtonsThemeData(
      selectedColor: _lightPrimaryVariantColor,
      selectedBorderColor: _lightPrimaryColor,
      fillColor: _lightOnPrimaryColor,
    ),
    // general placeholder colors
  );

  // Typography
  static final TextTheme _lightTextTheme = TextTheme(
    headline5: _lightScreenHeadingTextStyle,
    subtitle1: _lightScreenSubHeadingTextStyle,
    headline6: _lightScreenTitleTextStyle,
    bodyText2: _lightScreenBody1TextStyle,
    bodyText1: _lightScreenBody2TextStyle,
  );

  static final TextStyle _lightScreenHeadingTextStyle = TextStyle(
    fontSize: 30.0,
    color: _lightOnPrimaryColor,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle _lightScreenSubHeadingTextStyle = TextStyle(
    fontSize: 26.0,
    color: _lightOnPrimaryColor,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle _lightScreenTitleTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle _lightScreenBody2TextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle _lightScreenBody1TextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
  );

  // Inputs
  static final InputDecorationTheme textInputTheme = InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    alignLabelWithHint: false,
    labelStyle: _lightTextTheme.bodyText1!.copyWith(
      color: Colors.black87,
    ),
    hintStyle: _lightTextTheme.bodyText1,

    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(30.0),
    //   borderSide: BorderSide(color: Colors.black),
    // ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 10,
    ),
  );

  // static final InputDecorationTheme searchInputTheme = InputDecorationTheme(
  //   fillColor: accents["muted"],
  //   filled: true,
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(30.0),
  //     borderSide: BorderSide.none,
  //   ),
  //   contentPadding: EdgeInsets.symmetric(
  //     horizontal: 30.0,
  //   ),
  // );
}
