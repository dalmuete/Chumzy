import 'package:chumzy/features/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChumzySplashScreen extends StatefulWidget {
  @override
  _ChumzySplashScreenState createState() => _ChumzySplashScreenState();
}

class _ChumzySplashScreenState extends State<ChumzySplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE9AC),
      body: Center(
        child: SvgPicture.asset(
          'assets/chumzy_character/chumzy_avatar.svg',
          height: 100.h,
        ),
      ),
    );
  }
}
