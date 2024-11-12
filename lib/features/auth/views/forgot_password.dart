import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:chumzy/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var authController = Provider.of<AuthController>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomBorderTextField(
                controller: emailController,
                hintText: "Email",
              ),
              const Gap(10),
              CustomButton(
                  text: "Reset Password",
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      return;
                    }
                    authController.resetPassword(context, emailController.text);
                    print("CLICKKEEDD FORGOT PASSWORD");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
