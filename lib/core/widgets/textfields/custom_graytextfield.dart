import 'package:flutter/material.dart';

class CustomGrayTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? icon;

  const CustomGrayTextField(
      {super.key, required this.hintText, required this.controller, this.icon});

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Container(
      decoration: BoxDecoration(
        color: isLightMode
            ? Color.fromARGB(255, 243, 243, 243)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Color(0xFFfad24e),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              )),
          suffixIcon: icon,
          suffixIconColor: Colors.grey,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 12, right: 0, top: 14, bottom: 14),
        ),
      ),
    );
  }
}
