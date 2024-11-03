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
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
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
