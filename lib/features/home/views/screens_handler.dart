import 'package:chumzy/core/widgets/navbar.dart';
import 'package:chumzy/features/chatbot/views/chatbot_screen.dart';
import 'package:chumzy/features/home/views/home_screen.dart';
import 'package:chumzy/features/profile/views/profile_screen.dart';
import 'package:chumzy/features/subjects/views/subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreensHandler extends StatefulWidget {
  @override
  _ScreensHandlerState createState() => _ScreensHandlerState();
}

class _ScreensHandlerState extends State<ScreensHandler> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SubjectsScreen(),
    ChatbotScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h, right: 30.w, left: 30.w),
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Add button clicked");
          },
          backgroundColor: Colors.yellow[700],
          child: Icon(Icons.add, size: 35),
          shape: CircleBorder(),
          elevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
