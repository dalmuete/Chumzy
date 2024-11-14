import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderTextField extends StatefulWidget {
  String hintText;
  TextEditingController controller;
  final String? Function(String?)? validator;
  FocusNode? focusNode;
  int? maxChar;

  CustomBorderTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.maxChar,
    this.validator,
  });

  @override
  State<CustomBorderTextField> createState() => _CustomBorderTextFieldState();
}

class _CustomBorderTextFieldState extends State<CustomBorderTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxChar,
      focusNode: widget.focusNode,
      controller: widget.controller,
      cursorColor: Color(0xFFfad24e),
      decoration: InputDecoration(
        counterStyle: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          fontSize: 10.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey, width: 0.7),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFFffa01f), width: 0.7)),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        contentPadding:
            EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
      ),
      validator: widget.validator,
    );
  }
}
