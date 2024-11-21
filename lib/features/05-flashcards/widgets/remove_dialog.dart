import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> removeFlashcardDialog(BuildContext context, String term) async {
  return showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
                fontSize: 20.sp,
                color: Theme.of(context).scaffoldBackgroundColor),
            children: [
              TextSpan(text: "Remove "),
              TextSpan(
                text: term,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: "?"),
            ],
          ),
        ),
        content: Text(
          "Are you sure you want to remove this flashcard?",
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              "Remove",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      );
    },
  );
}
