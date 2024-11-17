import 'package:chumzy/core/themes/app_theme.dart';
import 'package:chumzy/data/providers/theme_provider.dart';
import 'package:chumzy/features/splash/views/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChumzyApp extends StatefulWidget {
  const ChumzyApp({super.key});

  @override
  State<ChumzyApp> createState() => _ChumzyAppState();
}

class _ChumzyAppState extends State<ChumzyApp> {
  ThemeMode? lastKnownThemeMode;
  bool emailVerificationSent = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final systemBrightness = MediaQuery.of(context).platformBrightness;
      final systemThemeMode = systemBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;

      if (themeProvider.themeMode != systemThemeMode) {
        themeProvider.updateSystemTheme(systemThemeMode);
      }
    });

    if (themeProvider.themeMode != lastKnownThemeMode) {
      print(themeProvider.themeMode);
      lastKnownThemeMode = themeProvider.themeMode;
    }

    return ScreenUtilInit(
      designSize: const Size(412, 915),
      builder: (context, child) {
        return AnimatedTheme(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          data: themeProvider.themeMode == ThemeMode.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            title: 'Chumzy - Your study buddy, sharp and ready!',
            // initialRoute: '/splash',
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  User? user = snapshot.data;
                  return ChumzySplashScreen(user: user);
                } else {
                  return const ChumzySplashScreen();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
