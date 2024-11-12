import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({required this.user, super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Home tab",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("UID: ${user.uid}"),
        ],
      ),
    );
  }
}
