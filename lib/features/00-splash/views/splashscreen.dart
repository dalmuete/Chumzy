import 'package:chumzy/features/01-auth/views/login_screen.dart';
import 'package:chumzy/features/01-auth/views/verification_screen.dart';
import 'package:chumzy/features/02-home/views/screens_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChumzySplashScreen extends StatefulWidget {
  final User? user;
  const ChumzySplashScreen({this.user, super.key});
  @override
  _ChumzySplashScreenState createState() => _ChumzySplashScreenState();
}

class _ChumzySplashScreenState extends State<ChumzySplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnUser();
  }

  Future<void> _navigateBasedOnUser() async {
    await Future.delayed(Duration(seconds: 3));

    if (mounted) {
      if (widget.user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else if (widget.user != null && !widget.user!.emailVerified) {
        await widget.user!.sendEmailVerification();

        print("Verification email has been sent.");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerificationScreen(
              email: widget.user!.email!,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ScreensHandler(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9AC),
      body: Center(
        child: SvgPicture.asset(
          'assets/chumzy_character/chumzy_avatar.svg',
          height: 100.h,
        ),
      ),
    );
  }
}
