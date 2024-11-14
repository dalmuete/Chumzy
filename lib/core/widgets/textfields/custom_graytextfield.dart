import 'package:flutter/material.dart';

class CustomGrayTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? icon;
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
      this.onTapOutside});

  @override
  State<CustomGrayTextField> createState() => _CustomGrayTextFieldState();
}

class _CustomGrayTextFieldState extends State<CustomGrayTextField> {
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
        onTapAlwaysCalled: true,
        onTapOutside: widget.onTapOutside,
        onTap: widget.onTap,
        focusNode: widget.focusNode,
        controller: widget.controller,
        cursorColor: const Color(0xFFfad24e),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              )),
          suffixIcon: widget.icon,
          suffixIconColor: Colors.grey,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(left: 12, right: 0, top: 14, bottom: 14),
        ),
      ),
    );
  }
}
