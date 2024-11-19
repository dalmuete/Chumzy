import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/features/01-auth/widgets/tryanotheremail_prompt.dart';
import 'package:chumzy/features/02-home/views/screens_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({required this.email, super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // var emailController = TextEditingController();
  // var passwordController = TextEditingController();
  // String email = "allenjameseugenioalvaro@gmail.com";
  bool showTimer = true;
  int remainingTime = 120;
  Timer? timer;
  Timer? verificationCheckTimer;
  bool isEmailVerified = false;
  bool isNavigated = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    startVerificationCheck();
  }

  @override
  void dispose() {
    timer?.cancel();
    verificationCheckTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          showTimer = false;
          t.cancel();
        }
      });
    });
  }

  void resendVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("Verification email has been sent.");
    }
    setState(() {
      remainingTime = 120;
      showTimer = true;
      startTimer();
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void startVerificationCheck() {
    verificationCheckTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      await checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified && !isNavigated) {
      setState(() {
        isEmailVerified = true;
      });
      isNavigated = true; // Set to true to prevent repeated navigation
      verificationCheckTimer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ScreensHandler();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(100.h),
              Text(
                "Check your email",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Gap(30.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'A verification link has been sent to ',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    TextSpan(
                      text: '. Please verify your account now to continue.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Gap(50.h),
              Center(
                  child: Image.asset(
                'assets/images/verification_link.png',
                height: 250.h,
              )),
              Gap(50.h),
              showTimer
                  ? Column(
                      children: [
                        Text(
                          "Resend verification link in",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${formatTime(remainingTime)}",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(14.h),
                      ],
                    )
                  : CustomButton(
                      text: "Resend verification link",
                      onPressed: resendVerification,
                      padding: 10,
                      fontSize: 14,
                      fontweight: FontWeight.w600,
                    ),
              Gap(150.h),
              TryAnotherEmailPrompt(),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
