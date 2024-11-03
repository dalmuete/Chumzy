import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MyNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
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
      body: Container(),
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
