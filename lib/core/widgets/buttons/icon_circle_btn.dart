import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconCircleBtn extends StatefulWidget {
  final String iconAsset;
  final VoidCallback onPressed;

  const IconCircleBtn({
    super.key,
    required this.iconAsset,
    required this.onPressed,
  });

  @override
  State<IconCircleBtn> createState() => _IconCircleBtnState();
}

class _IconCircleBtnState extends State<IconCircleBtn> {
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        radius: 40.r,
        child: IconButton(
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
          splashRadius: 40.r,
          icon: Padding(
            padding: EdgeInsets.all(20.r),
            child: Image.asset(
              widget.iconAsset,
              height: 40.h,
            ),
          ),
          onPressed: widget.onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
