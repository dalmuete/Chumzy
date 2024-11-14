import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CardItemCard extends StatefulWidget {
  final String term;
  final String definition;
  final VoidCallback onTap;

  const CardItemCard({
    super.key,
    required this.term,
    required this.definition,
    required this.onTap,
  });

  @override
  State<CardItemCard> createState() => _CardItemCardState();
}

class _CardItemCardState extends State<CardItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.h),
      color: Theme.of(context).colorScheme.surface,
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: Colors.grey, width: 0.5.w),
      ),
      child: InkWell(
        onTap: () {},
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 30.r),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.term,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              ),
              Gap(10.h),
              Text(
                widget.definition,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              )
            ])),
      ),
    );
    ;
  }
}
