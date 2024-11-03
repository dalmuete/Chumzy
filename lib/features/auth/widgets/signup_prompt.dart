
import 'package:flutter/material.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("New to Chumzy? "),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/signup'),
          child: Text(
            "Sign up",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
