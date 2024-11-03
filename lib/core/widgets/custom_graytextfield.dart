import 'package:chumzy/core/themes/text_theme.dart';
import 'package:flutter/material.dart';

class CustomGrayTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomGrayTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 243, 243),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
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
