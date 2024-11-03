import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'text_theme.dart';
import 'button_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: AppColorsLightTheme.primary,
      scaffoldBackgroundColor: Colors.white,
      textTheme: AppTextTheme.lightTextTheme,
      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColorsLightTheme.primary,
        secondary: AppColorsLightTheme.secondary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: AppColorsDarkTheme.primary,
      scaffoldBackgroundColor: AppColorsDarkTheme.background,
      textTheme: AppTextTheme.darkTextTheme,
      elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColorsDarkTheme.primary,
        secondary: AppColorsDarkTheme.secondary,
      ),
    );
  }
}
