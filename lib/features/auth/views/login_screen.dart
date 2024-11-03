import 'package:chumzy/core/widgets/custom_btn.dart';
import 'package:chumzy/core/widgets/custom_graytextfield.dart';
import 'package:chumzy/core/widgets/icon_circle_btn.dart';
import 'package:chumzy/features/auth/widgets/password_field.dart';
import 'package:chumzy/features/auth/widgets/signup_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

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
              SvgPicture.asset(
                'assets/chumzy_character/chumzy_head_dots.svg',
                height: 90.h,
              ),
              Gap(50.h),
              Text(
                "Welcome back to Chumzy!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Gap(5.h),
              Text(
                "Your study buddy, sharp and ready",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Gap(50.h),
              CustomGrayTextField(
                  hintText: 'Email', controller: emailController),
              Gap(20.h),
              PasswordField(
                  hintText: 'Password', controller: passwordController),
              Gap(5.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
              Gap(40.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(text: 'Log in', onPressed: () => Navigator.pushReplacementNamed(context, '/home')),
                  ),
                ],
              ),
              Gap(30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(10.w),
                  Expanded(
                    child: Divider(color: Colors.grey, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'or continue with',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey, thickness: 1),
                  ),
                  Gap(10.w),
                ],
              ),
              Gap(30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconCircleBtn(
                      iconAsset: 'assets/icons/google_logo.png',
                      onPressed: () {}),
                  Gap(40.w),
                  IconCircleBtn(
                      iconAsset: 'assets/icons/facebook_logo.png',
                      onPressed: () {})
                ],
              ),
              Gap(80.h),
              SignUpPrompt(),
              Gap(20.h)
            ],
          ),
        ),
      ),
    );
  }
}
