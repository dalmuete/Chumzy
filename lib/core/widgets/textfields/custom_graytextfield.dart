import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGrayTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? icon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;

  const CustomGrayTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.icon,
      this.focusNode,
      this.onTap,
      this.onTapOutside,
      this.validator});

  @override
  State<CustomGrayTextField> createState() => _CustomGrayTextFieldState();
}

class _CustomGrayTextFieldState extends State<CustomGrayTextField> {
  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return TextFormField(
      onTapAlwaysCalled: true,
      onTapOutside: widget.onTapOutside,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      controller: widget.controller,
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
            focusedErrorBorder:OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            )),
        suffixIcon: widget.icon,
        suffixIconColor: Colors.grey,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 12.r, right: 12.r, top: 16.r, bottom: 16.r),
      ),
      validator: widget.validator,
    );
  }
}
