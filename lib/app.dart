import 'package:chumzy/core/themes/app_theme.dart';
import 'package:chumzy/features/auth/views/login_screen.dart';
import 'package:chumzy/features/auth/views/signup_screen.dart';
import 'package:chumzy/features/home/views/home_screen.dart';
import 'package:chumzy/features/splash/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChumzyApp extends StatelessWidget {
  ChumzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        title: 'Chumzy - Your study buddy, sharp and ready!',
        // home: ChumzySplashScreen(),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => ChumzySplashScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
