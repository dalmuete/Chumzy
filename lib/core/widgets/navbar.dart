import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  var avatar = AssetImage('assets/images/avatar01.png');
  @override
  Widget build(BuildContext context) {
    final iconList_active = [
      Icon(Icons.home_rounded,
          size: 25.r, color: Theme.of(context).colorScheme.secondary),
      Image.asset(
        'assets/icons/subjects_active_icon.png',
        width: 18.r,
      ),
      Image.asset(
        'assets/icons/chatbot_active_icon.png',
        width: 27.r,
      ),
      CircleAvatar(
        radius: 14.r,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: CircleAvatar(
          radius: 12.r,
          backgroundImage: avatar,
        ),
      ),
    ];
    final iconList_inactive = [
      Icon(Icons.home_rounded, size: 25.r, color: Colors.grey),
      Image.asset(
        'assets/icons/subjects_inactive_icon.png',
        width: 18.r,
      ),
      Image.asset(
        'assets/icons/chatbot_inactive_icon.png',
        width: 27.r,
      ),
      CircleAvatar(
        radius: 14.r,
        backgroundColor: Colors.grey,
        child: CircleAvatar(
          radius: 12.r,
          backgroundImage: avatar,
        ),
      ),
    ];
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList_active.length,
      tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isActive ? iconList_active[index] : iconList_inactive[index],
            if (isActive)
              Container(
                margin: EdgeInsets.only(top: 4.r),
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
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
      activeIndex: widget.selectedIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onTap: widget.onItemSelected,
    );
  }
}
