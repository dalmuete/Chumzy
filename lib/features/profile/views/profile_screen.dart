import 'package:chumzy/data/providers/theme_provider.dart';
import 'package:chumzy/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authController = Provider.of<AuthController>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Profile tab",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Gap(100.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dark Mode"),
              Transform.scale(
                scale: (0.9).r,
                child: CupertinoSwitch(
                  value: themeProvider.themeMode == ThemeMode.dark ||
                      (themeProvider.themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark),
                  onChanged: (value) {
                    if (value) {
                      themeProvider.toggleThemeMode(true);
                    } else {
                      themeProvider.toggleThemeMode(false);
                    }
                  },
                  applyTheme: true,
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Use system's theme mode"),
              TextButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                onPressed: () {
                  themeProvider.resetToSystemMode();
                },
                child: Text(
                  "APPLY",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Gap(100.h),
          TextButton(
            child: Text("LOG OUT"),
            onPressed: () {
              authController.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
