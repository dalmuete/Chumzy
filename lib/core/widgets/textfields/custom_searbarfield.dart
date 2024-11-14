import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBarField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? icon;
  TapRegionCallback? onTapOutside;

   CustomSearchBarField(
      {super.key, required this.hintText, required this.controller, this.icon, this.onTapOutside});

  @override
  State<CustomSearchBarField> createState() => _CustomSearchBarFieldState();
}

class _CustomSearchBarFieldState extends State<CustomSearchBarField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    Icon icon =Icon(Icons.search, color: Colors.white.withOpacity(0.3), size: 24.r);
    VoidCallback? onTap = () {
      widget.controller.clear();
      setState(() {
        isFocused = false;
      });
    };

    if (widget.controller.text.isNotEmpty) {
      icon = Icon(Icons.clear, color: Colors.white, size: 24.r);
      onTap = () {
        widget.controller.clear();
        setState(() {
          isFocused = false;
        });
      };
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.white, fontSize: 16),
        controller: widget.controller,
        cursorColor: const Color(0xFFfad24e),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            ),
          ),
          suffixIcon: GestureDetector(
            child: icon,
            onTap: onTap,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Colors.white.withOpacity(0.5),
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
