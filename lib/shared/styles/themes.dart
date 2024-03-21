import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  // primarySwatch: defaultColor,
  colorScheme: const ColorScheme.light(primary: defaultColor),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: defaultColor,
    foregroundColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleSpacing: 20,
      elevation: 0,
      scrolledUnderElevation: 2, //elevation when scroll
      surfaceTintColor: Colors.white, // background color when scroll
      shadowColor: Colors.white, //elevation shadow color
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarColor: Colors.red, // الشريط اللي تحت
        // systemNavigationBarDividerColor: Colors.black,
      ),
      titleTextStyle: TextStyle(
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      )),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20,
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  fontFamily: 'LibreBaskerville',
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'LibreBaskerville',
  scaffoldBackgroundColor: HexColor('333739'),
  // primarySwatch: defaultColor,
  colorScheme: const ColorScheme.dark(primary: defaultColor),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepOrange,
    foregroundColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    titleSpacing: 20,
    elevation: 0,
    scrolledUnderElevation: 2, //elevation when scroll
    surfaceTintColor: Colors.white, // background color when scroll
    shadowColor: Colors.white, //elevation shadow color
    backgroundColor: HexColor('333739'),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
      statusBarIconBrightness: Brightness.light,
      // systemNavigationBarColor: Colors.red, // الشريط اللي تحت
      // systemNavigationBarDividerColor: Colors.black,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 25,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    elevation: 20,
    backgroundColor: HexColor('333739'),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
