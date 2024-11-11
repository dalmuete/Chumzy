
import 'package:flutter/material.dart';

class CustomBorderTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomBorderTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color.fromARGB(255, 243, 243, 243),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Color(0xFFfad24e),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Color(0xFFffa01f),
              )),
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelSmall,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 12, right: 0, top: 16, bottom: 16),
        ),
      ),
    );
  }
}
