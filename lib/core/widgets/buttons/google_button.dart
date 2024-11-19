import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleBtn extends StatefulWidget {
  final VoidCallback onPressed;

  const GoogleBtn({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<GoogleBtn> createState() => _GoogleBtnState();
}

class _GoogleBtnState extends State<GoogleBtn> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withOpacity(0.15),
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.grey.withOpacity(0.3),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/google_logo.png',
                height: 24.r,
                width: 24.r,
              ),
              Gap(10.h),
              Text(
                "Google",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
