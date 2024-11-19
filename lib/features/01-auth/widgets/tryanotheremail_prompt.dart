import 'package:flutter/material.dart';

class TryAnotherEmailPrompt extends StatelessWidget {
  const TryAnotherEmailPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Did not receive email? Check your spam filter or",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize)),
        TextButton(
          style:
              ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
          onPressed: () => Navigator.pop(context),
          child: Text(
            "try another email address.",
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
