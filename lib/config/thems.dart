import 'package:flutter/material.dart';
import 'package:wissal_app/config/colors.dart';

var lightThem = ThemeData();
var darktThem = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: dPrimaryColor,
    onPrimary: dBackgroundColor,
    background: dBackgroundColor,
    onBackground: dBackgroundColor,
    primaryContainer: dContainerColor,
    onPrimaryContainer: donContainerColor,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32,
        color: dPrimaryColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800),
    headlineMedium: TextStyle(
        fontSize: 30,
        color: donBackgroundColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(
        fontSize: 20,
        color: donBackgroundColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600),
    labelLarge: TextStyle(
        fontSize: 14,
        color: donContainerColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500),
    labelMedium: TextStyle(
        fontSize: 14,
        color: donContainerColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400),
    labelSmall: TextStyle(
        fontSize: 14,
        color: donContainerColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300),
  ),
);
