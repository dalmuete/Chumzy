import 'package:chumzy/core/themes/app_theme.dart';
import 'package:chumzy/features/auth/views/login_screen.dart';
import 'package:chumzy/features/auth/views/signup_screen.dart';
import 'package:chumzy/features/home/views/home_screen.dart';
import 'package:chumzy/features/splash/views/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChumzyApp extends StatelessWidget {
  const ChumzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        title: 'Chumzy - Your study buddy, sharp and ready!',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final User user = snapshot.data!;
              return HomeScreen(
                user: user,
              );
            } else {
              return ChumzySplashScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
        },
      ),
    );
  }
}
