import 'package:chumzy/data/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            radius: 25.r, // Adjust size
            backgroundColor: const Color(0xFFFFCE48),
            child: Image.asset("assets/chumzy_character/chumzy_icon.png"),
          ),
          SizedBox(width: 8.w),
        ],
        // Message bubble
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isOutgoing ? Colors.yellow[200] : Colors.grey[200],
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
                    color: Colors.black87,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTimestamp(message.createdAt),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Placeholder for the user; leave this empty
        if (isOutgoing) SizedBox(width: 28.w),
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
