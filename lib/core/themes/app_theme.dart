import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_theme.dart';
import 'button_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      primaryColor: AppColorsLightTheme.primary,
      scaffoldBackgroundColor: Colors.white,
      textTheme: AppTextTheme.lightTextTheme,
      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      colorScheme: ColorScheme.light(
          primary: AppColorsLightTheme.primary,
          secondary: AppColorsLightTheme.secondary,
          surface: AppColorsLightTheme.background),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      primaryColor: AppColorsDarkTheme.primary,
      scaffoldBackgroundColor: AppColorsDarkTheme.background,
      textTheme: AppTextTheme.darkTextTheme,
      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      colorScheme: ColorScheme.dark(
          primary: AppColorsDarkTheme.primary,
          secondary: AppColorsDarkTheme.secondary,
          surface: AppColorsDarkTheme.background),
    );
  }
}
