import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TapRegionCallback? onTapOutside;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onTapOutside,
    this.validator,
  });

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return TextFormField(
      onTapOutside: widget.onTapOutside,
      controller: widget.controller,
      obscureText: !_isVisible,
      cursorColor: const Color(0xFFfad24e),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        filled: true,
        fillColor: isLightMode
            ? const Color.fromARGB(255, 243, 243, 243)
            : Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            )),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 12.r, right: 0, top: 16.r, bottom: 16.r),
        suffixIcon: IconButton(
          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey, size: 20.sp),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}
