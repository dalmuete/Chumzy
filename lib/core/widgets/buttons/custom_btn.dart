import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double padding;
  final double fontSize;
  final FontWeight fontweight;
  final Widget? prefixIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFffce48),
    this.textColor = Colors.black,
    this.borderColor,
    this.padding = 20,
    this.fontSize = 16,
    this.fontweight = FontWeight.bold,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(padding),
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1.0)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize.sp,
              fontWeight: fontweight,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
