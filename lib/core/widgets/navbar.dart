import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavBar({
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
      Icons.person,
    ];

    return AnimatedBottomNavigationBar.builder(
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
      splashRadius: 0,
      shadow: Shadow(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          offset: Offset(5, 0),
          blurRadius: 10),
      height: 70.h,
      activeIndex: selectedIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      backgroundColor: Theme.of(context).colorScheme.surface,


      onTap: onItemSelected,
    );
  }
}
