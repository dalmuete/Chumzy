import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chumzy/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MyNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final User user;

  const MyNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconList = [
      Icons.home,
      Icons.layers,
      Icons.chat_bubble,
      Icons.person
    ];

    return Scaffold(
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(user.displayName!),
                // Image.network(user.photoURL!),
                Text(
                  user != null
                      ? "Hello user: ${user!.uid}, ${user!.email}"
                      : "Hello Guest",
                  textAlign: TextAlign.center,
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: () {
                    authController.logout(context);
                  },
                  child: const Text("Logout"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // authController.logout(context);
                    // authController.testLaunch();
                    authController.openMailApp();
                  },
                  child: const Text("Open gmail app"),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Add button clicked");
        },
        backgroundColor: Colors.yellow[700],
        child: Icon(Icons.add, size: 35),
        shape: CircleBorder(),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconList[index],
                size: 24,
                color: isActive ? Colors.yellow[700] : Colors.grey,
              ),
              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          );
        },
        height: 70,
        activeIndex: selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 16,
        rightCornerRadius: 16,
        onTap: (index) => onItemSelected(index),
      ),
    );
  }
}
