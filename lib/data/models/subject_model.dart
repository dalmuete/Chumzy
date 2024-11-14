import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:flutter/material.dart';

class Subject with CustomDropdownListFilter {
  final Color lineColor;
  final String title;
  final int totalNoItems;
  final DateTime lastUpdated;
  final List<Topic>? topics;

  Subject({
    required this.lineColor,
    required this.title,
    required this.totalNoItems,
    required this.lastUpdated,
    this.topics,
  });


   @override
  String toString() {
    return title;
  }

  @override
  bool filter(String query) {
    return title.toLowerCase().contains(query.toLowerCase());
  }
}
