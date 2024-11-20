import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final int? maxChar;
  final int? minLines;
  final int? maxLines;
  final TextInputType? textInputType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;

  const CustomBorderTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.maxChar,
    this.minLines,
    this.maxLines = 1,
    this.validator,
    this.textInputType,
    this.onChanged,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
  });

  @override
  State<CustomBorderTextField> createState() => _CustomBorderTextFieldState();
}

class _CustomBorderTextFieldState extends State<CustomBorderTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      keyboardType: widget.textInputType,
      maxLength: widget.maxChar,
      focusNode: widget.focusNode ?? FocusNode(),
      controller: widget.controller,
      cursorColor: const Color(0xFFfad24e),
      decoration: InputDecoration(
        counterStyle: TextStyle(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          fontSize: 10.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.grey, width: 0.7),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFffa01f), width: 0.7)),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        contentPadding:
            EdgeInsets.only(left: 12.r, right: 12.r, top: 16.r, bottom: 16.r),
      ),
      validator: widget.validator,
    );
  }
}
