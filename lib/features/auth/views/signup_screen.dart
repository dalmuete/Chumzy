import 'package:chumzy/core/themes/text_theme.dart';
import 'package:chumzy/core/widgets/custom_btn.dart';
import 'package:chumzy/core/widgets/custom_graytextfield.dart';
import 'package:chumzy/core/widgets/icon_circle_btn.dart';
import 'package:chumzy/features/auth/widgets/password_field.dart';
import 'package:chumzy/features/auth/widgets/signin_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(40.h),
              SvgPicture.asset(
                'assets/chumzy_character/chumzy_head_dots.svg',
                height: 90.h,
              ),
              Gap(50.h),
              Text(
                "Get Started with Chumzy!",
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
                  hintText: 'Your name', controller: nameController),
              Gap(10.h),
              CustomGrayTextField(
                  hintText: 'Email', controller: emailController),
              Gap(10.h),
              PasswordField(
                  hintText: 'Password', controller: passwordController),
              Gap(10.h),
              PasswordField(
                  hintText: 'Confirm your password',
                  controller: passwordController),
              Gap(30.h),
              Row(
                children: [
                  Expanded(
                    child:
                        CustomButton(text: 'Create Account', onPressed: () {}),
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
              Gap(50.h),
              SignInPrompt(),
              Gap(20.h)
            ],
          ),
        ),
      ),
    );
  }
}
