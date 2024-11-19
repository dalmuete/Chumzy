import 'package:chumzy/features/auth/views/login_screen.dart';
import 'package:flutter/material.dart';

class SignInPrompt extends StatelessWidget {
  const SignInPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Have an account?",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        TextButton(
          style:
              ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          },
          child: Text(
            "Log in",
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
