import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTopicSearchBarField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Function(String?)? onchange;
  final Widget? sufixIcon;
  final bool? isFocus;

  const CustomTopicSearchBarField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onTapOutside,
    this.onTap,
    this.focusNode,
    this.onchange,
    this.sufixIcon,
    this.isFocus,
  });

  @override
  State<CustomTopicSearchBarField> createState() =>
      _CustomTopicSearchBarFieldState();
}

class _CustomTopicSearchBarFieldState
    extends State<CustomTopicSearchBarField> {
  // bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    // Icon icon = Icon(Icons.search,
    //     color: Theme.of(context).primaryColor.withOpacity(0.3), size: 24.r);
    // VoidCallback? onTap = () {
    //   widget.controller.clear();
    //   setState(() {
    //     isFocused = false;
    //   });
    // };

    // if (widget.controller.text.isNotEmpty) {
    //   icon = Icon(Icons.clear,
    //       color: Theme.of(context).primaryColor.withOpacity(0.8), size: 24.r);
    //   onTap = () {
    //     widget.controller.clear();
    //     setState(() {
    //       isFocused = false;
    //     });
    //   };
    // }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
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
          suffixIcon: widget.sufixIcon,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(left: 12, right: 0, top: 14, bottom: 14),
        ),
        onChanged: widget.onchange,
        // onChanged: (value) {
        //   setState(() {
        //     isFocused = true;
        //   });
        // },
      ),
    );
  }
}
