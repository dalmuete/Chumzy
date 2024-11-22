import 'package:chumzy/data/providers/theme_provider.dart';
import 'package:chumzy/features/01-auth/controller/auth_controller.dart';
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
    var authController = Provider.of<AuthController>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<AuthController>(
      builder: (context, authProvider, child) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 115.r,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: CircleAvatar(
                        radius: 110.r,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 100.r,
                          backgroundImage:
                              AssetImage('assets/images/avatar01.png'),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 10.r,
                    //   right: 30.r,
                    //   child: CircleAvatar(
                    //     radius: 20.r,
                    //     backgroundColor:
                    //         Theme.of(context).colorScheme.secondary,
                    //     child: IconButton(
                    //       icon: Icon(
                    //         Icons.edit,
                    //         color: Colors.black,
                    //         size: 20.r,
                    //       ),
                    //       onPressed: () {
                    //         // Add logic to edit the avatar
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Gap(20.h),
                FutureBuilder<String?>(
                  future: authProvider.getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Text(
                      snapshot.data ?? 'No Name',
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.w600),
                    );
                  },
                ),
                FutureBuilder<String?>(
                  future: authProvider.getUserEmail(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Fetching you information ...");
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Text(
                      snapshot.data ?? 'No Email',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
                // TextButton(
                //   onPressed: () {
                //     // Add logic to edit the profile
                //   },
                //   child: Text(
                //     "Edit Profile",
                //     style: TextStyle(
                //       fontSize: 14.sp,
                //       color: Theme.of(context).colorScheme.tertiary,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                Gap(50.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Appearance",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Gap(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark Mode"),
                    Transform.scale(
                      scale: 0.9.r,
                      child: CupertinoSwitch(
                        value: themeProvider.themeMode == ThemeMode.dark ||
                            (themeProvider.themeMode == ThemeMode.system &&
                                MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark),
                        onChanged: (value) {
                          themeProvider.toggleThemeMode(value);
                        },
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
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                      ),
                      onPressed: themeProvider.resetToSystemMode,
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall?.fontSize,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(80.h),
                TextButton(
                  child: Text(
                    "LOG OUT",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color.fromARGB(255, 209, 86, 77),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    await authProvider.logout(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
