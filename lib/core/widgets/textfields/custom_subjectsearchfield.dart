import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSubjectSearchBarField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const CustomSubjectSearchBarField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.onTapOutside,
      this.onTap,
      this.focusNode});

  @override
  State<CustomSubjectSearchBarField> createState() =>
      _CustomSubjectSearchBarFieldState();
}

class _CustomSubjectSearchBarFieldState
    extends State<CustomSubjectSearchBarField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    Icon icon = Icon(Icons.search,
        color: Theme.of(context).primaryColor.withOpacity(0.3), size: 24.r);
    VoidCallback? onTap = () {
      widget.controller.clear();
      setState(() {
        isFocused = false;
      });
    };

    if (widget.controller.text.isNotEmpty) {
      icon = Icon(Icons.clear,
          color: Theme.of(context).primaryColor.withOpacity(0.8), size: 24.r);
      onTap = () {
        widget.controller.clear();
        setState(() {
          isFocused = false;
        });
      };
    }
    return Container(
      decoration: BoxDecoration(
        color: isLightMode
            ? const Color.fromARGB(255, 243, 243, 243)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        autofocus: false,
        focusNode: widget.focusNode,
        onTapOutside: widget.onTapOutside,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
        controller: widget.controller,
        cursorColor: const Color(0xFFfad24e),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: icon,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
            color: Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(left: 12, right: 0, top: 14, bottom: 14),
        ),
        onChanged: (value) {
          setState(() {
            isFocused = true;
          });
        },
      ),
    );
  }
}
