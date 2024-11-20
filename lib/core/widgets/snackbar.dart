import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delightful_toast/delight_toast.dart';

void showCustomToast({
  required BuildContext context,
  required Widget leading,
  required String message,
}) {
  DelightToastBar(
    autoDismiss: true,
    position: DelightSnackbarPosition.top,
    animationDuration: Duration(milliseconds: 500),
    snackbarDuration: Duration(seconds: 3),
    builder: (context) => ToastCard(
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.2),
      leading: leading,
      title: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    ),
  ).show(context);
}
