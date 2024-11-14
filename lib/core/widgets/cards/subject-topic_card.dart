import 'package:chumzy/core/utils/timeago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SubjectTopicCard extends StatefulWidget {
  final Color lineColor;
  final String title;
  final int totalNoItems;
  final DateTime lastUpdated;
  final bool isSubject;
  final VoidCallback onTap;

  const SubjectTopicCard({
    super.key,
    required this.lineColor,
    required this.title,
    required this.totalNoItems,
    required this.lastUpdated,
    this.isSubject = true,
    required this.onTap,
  });

  @override
  State<SubjectTopicCard> createState() => _SubjectTopicCardState();
}

class _SubjectTopicCardState extends State<SubjectTopicCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 5),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();

    widget.onTap();

    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        color: Theme.of(context).colorScheme.surface,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.grey, width: 0.5.w),
        ),
        child: InkWell(
          onTap: _handleTap,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
          // highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
            child: Container(
              width: 10.w,
              height: 100.h,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.lineColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        width: widget.isSubject ? 10.w : 5.w,
                        height: widget.isSubject ? 100.h : 50.w,
                      ),
                      Gap(15.w),
                      Tooltip(
                        message: widget.title,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        margin: EdgeInsets.all(20.r),
                        preferBelow: false,
                        child: Text(
                          widget.title.length > 25
                              ? widget.title.substring(0, 25) + '...'
                              : widget.title,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: widget.isSubject ? 20.sp : 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border:
                              Border.all(width: (0.5).w, color: Colors.grey)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 5.r),
                        child: Text(
                          "${widget.totalNoItems} ${widget.isSubject ? 'topics' : 'cards'}",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      TimeAgo.convertToTimeAgo(widget.lastUpdated),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
