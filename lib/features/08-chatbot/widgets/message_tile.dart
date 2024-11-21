import 'package:chumzy/data/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool isOutgoing;

  const MessageTile({
    required this.message,
    required this.isOutgoing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isOutgoing) ...[
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            backgroundImage:
                AssetImage('assets/chumzy_character/chumzy_icon.png'),
            radius: 20.r,
          ),
          Gap(10.w),
        ],
        // Message bubble
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
                top: 12.h,
                bottom: 12.h,
                left: isOutgoing ? 50.w : 0,
                right: isOutgoing ? 0 : 10.w),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isOutgoing
                      ? Colors.transparent
                      : Theme.of(context).primaryColor.withOpacity(0.5)),
              color: isOutgoing
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: isOutgoing ? Radius.circular(16.0) : Radius.zero,
                bottomRight: isOutgoing ? Radius.zero : Radius.circular(16.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: isOutgoing
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTimestamp(message.createdAt),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    final minute =
        timestamp.minute < 10 ? '0${timestamp.minute}' : '${timestamp.minute}';
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
