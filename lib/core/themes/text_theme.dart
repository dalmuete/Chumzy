import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1C1C1E),
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1C1C1E),
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1C1C1E),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1C1C1E),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: Color(0xFF1C1C1E),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Color(0xFF1C1C1E),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Color(0xFF1C1C1E),
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white54,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  );
}
