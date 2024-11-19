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
    return Container(
      decoration: BoxDecoration(
        color: isLightMode
            ? const Color.fromARGB(255, 243, 243, 243)
            : Colors.white.withOpacity(0.1),

        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
        onTapOutside: widget.onTapOutside,
        controller: widget.controller,
        obscureText: !_isVisible,
        cursorColor: const Color(0xFFfad24e),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              )),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(left: 12, right: 0, top: 16, bottom: 16),
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
      ),
    );
  }
}
