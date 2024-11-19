import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildCardContent extends StatefulWidget {
 final String content;
  final int fontSize;
  final FontWeight fontWeight;
  final Color borderColor;
  final Color shadowColor;
  final double borderWidth;

  const BuildCardContent({ required this.content,
    required this.fontSize,
    required this.fontWeight,
    required this.borderColor,
    required this.shadowColor,
    required this.borderWidth,super.key});

  @override
  State<BuildCardContent> createState() => _BuildCardContentState();
}

class _BuildCardContentState extends State<BuildCardContent> {
  @override
  Widget build(BuildContext context) {
     return Container(
      height: 400.h,
      width: 350.w,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 10,
        shadowColor: widget.shadowColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
          side: BorderSide(color: widget.borderColor, width: widget.borderWidth.w),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30.r),
            child: Text(
              widget.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize.sp,
                fontWeight: widget.fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}