import 'package:flutter/material.dart';

class Topic {
  final String title;
  final int totalNoItems;
  final DateTime lastUpdated;

  Topic({
    required this.title,
    required this.totalNoItems,
    required this.lastUpdated,
  });
}
