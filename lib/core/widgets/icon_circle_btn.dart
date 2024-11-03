import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class IconCircleBtn extends StatelessWidget {
  final String iconAsset;
  final VoidCallback onPressed;

  const IconCircleBtn({
    super.key,
    required this.iconAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
        child: IconButton(
          icon: Image.asset(
            iconAsset,
            height: 40.h,
          ),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
