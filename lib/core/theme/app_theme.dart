import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white, // Background color for scaffolds
    splashColor: Colors.transparent, // Color for splash effects
    highlightColor: Colors.transparent, // Color for highlight effects
    hoverColor: Colors.transparent, // Color for hover effects
    splashFactory: NoSplash.splashFactory, // Factory for splash effects
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white, // Background color for bottom sheets
      shape: RoundedRectangleBorder( // Shape for bottom sheets
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Border radius for top corners
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black, // Background color for scaffolds
    splashColor: Colors.transparent, // Color for splash effects
    highlightColor: Colors.transparent, // Color for highlight effects
    hoverColor: Colors.transparent, // Color for hover effects
    splashFactory: NoSplash.splashFactory, // Factory for splash effects
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.black, // Background color for bottom sheets
      shape: RoundedRectangleBorder( // Shape for bottom sheets
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Border radius for top corners
      ),
    ),
  );
}