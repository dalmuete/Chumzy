import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReviewOptionsCard extends StatefulWidget {
  final String iconPath;
  final double iconSize;
  final String title;
  final VoidCallback onTap;

  const ReviewOptionsCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    required this.iconSize,
  });

  @override
  State<ReviewOptionsCard> createState() => _ReviewOptionsCardState();
}

class _ReviewOptionsCardState extends State<ReviewOptionsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: Theme.of(context).colorScheme.surface,
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: Colors.grey.withOpacity(0.15), width: 0.5.w),
      ),
      child: InkWell(
        onTap: () {},
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 30.r),
            child: Center(
                child: Column(children: [
              Image.asset(
                widget.iconPath,
                height: widget.iconSize.r,
              ),
              Gap(10.h),
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              )
            ]))),
      ),
    );
    
  }
}
