import 'package:chumzy/data/models/topic_model.dart';
import 'package:flutter/material.dart';

class Subject {
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
}
