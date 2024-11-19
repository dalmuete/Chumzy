import 'package:flutter/material.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New to Chumzy?",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        TextButton(
          style:
              ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          child: Text(
            "Sign up",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}