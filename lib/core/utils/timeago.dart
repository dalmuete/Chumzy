import 'package:intl/intl.dart';

class TimeAgo {
  static String convertToTimeAgo(DateTime dateTime) {
    final currentDate = DateTime.now();
    final difference = currentDate.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      if (difference.inMinutes == 1) {
        return "Just a min ago";
      } else {
        return "${difference.inMinutes} mins ago";
      }
    }

    if (difference.inHours < 24) {
      if (difference.inHours == 1) {
        return "1 hr ago";
      } else {
        return "${difference.inHours} hrs ago";
      }
    }

    if (difference.inDays < 7) {
      if (difference.inDays == 1) {
        return "1 day ago";
      } else {
        return "${difference.inDays} days ago";
      }
    }

    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      if (weeks == 1) {
        return "1 week ago";
      } else {
        return "${weeks} weeks ago";
      }
    }

    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
