import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.3),
      content: Container(
        color: Colors.transparent,
        height: 80.h,
        width: 50.w,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Image.asset(
            'assets/chumzy_character/chumzy_loading.gif',
            height: 100,
          ),
        ),
      ),
    );
  }
}
