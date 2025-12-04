import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // static const String fontFamily = FontFamily.sFProDisplay;

  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  static TextStyle _style(
      double fontSize,
      double lineHeight,
      FontWeight fontWeight,
      ) {
    return TextStyle(
      // fontFamily: fontFamily,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: Colors.black,
    );
  }

  // Large Title
  static TextStyle get largeTitle => _style(34, 41, _regular);
  static TextStyle get largeTitleBold => _style(34, 41, _bold);

  // Title 1
  static TextStyle get title1 => _style(28, 34, _regular);
  static TextStyle get title1Bold => _style(28, 34, _bold);

  // Title 2
  static TextStyle get title2 => _style(22, 28, _regular);
  static TextStyle get title2Bold => _style(22, 28, _bold);

  // Title 3
  static TextStyle get title3 => _style(20, 25, _regular);
  static TextStyle get title3SemiBold => _style(20, 25, _semiBold);

  // Headline / Body
  static TextStyle get body => _style(17, 22, _regular);
  static TextStyle get bodySemiBold => _style(17, 22, _semiBold);

  // Callout
  static TextStyle get callout => _style(16, 21, _regular);
  static TextStyle get calloutSemiBold => _style(16, 21, _semiBold);

  // Subheadline
  static TextStyle get subheadline => _style(15, 20, _regular);
  static TextStyle get subheadlineSemiBold => _style(15, 20, _semiBold);

  // Footnote
  static TextStyle get footnote => _style(13, 18, _regular);
  static TextStyle get footnoteSemiBold => _style(13, 18, _semiBold);

  // Caption 1
  static TextStyle get caption1 => _style(12, 16, _regular);
  static TextStyle get caption1Medium => _style(12, 16, _medium);

  // Caption 2
  static TextStyle get caption2 => _style(11, 13, _regular);
  static TextStyle get caption2SemiBold => _style(11, 13, _semiBold);

  /// Maps tokens into Flutter's `TextTheme` for Material 3 compatibility.
  static TextTheme get textTheme => TextTheme(
    displayLarge: largeTitle,
    displayMedium: title1,
    displaySmall: title2,
    headlineLarge: title3,
    headlineMedium: body,
    headlineSmall: subheadline,
    titleLarge: title3SemiBold,
    titleMedium: calloutSemiBold,
    titleSmall: subheadlineSemiBold,
    bodyLarge: body,
    bodyMedium: callout,
    bodySmall: footnote,
    labelLarge: calloutSemiBold,
    labelMedium: footnoteSemiBold,
    labelSmall: caption2SemiBold,
  );
}