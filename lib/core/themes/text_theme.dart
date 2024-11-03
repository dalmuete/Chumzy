import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white54,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey,
    ),
  );
}
