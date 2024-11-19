import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Subject with CustomDropdownListFilter {
  final Color lineColor;
  final String title;
  final int totalNoItems;
  final DateTime lastUpdated;
  List<Topic>? topics;
  final String? subjectDocId;

  Subject({
    required this.lineColor,
    required this.title,
    required this.totalNoItems,
    required this.lastUpdated,
    this.topics,
    this.subjectDocId,
  });

  @override
  String toString() {
    return title;
  }

  @override
  bool filter(String query) {
    return title.toLowerCase().contains(query.toLowerCase());
  }

  // Convert Firestore data to a Subject object
  factory Subject.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subject(
      lineColor: Color(int.parse(data['lineColor'])),
      title: data['title'],
      totalNoItems: data['totalNoItems'],
      lastUpdated: (data['createdAt'] as Timestamp).toDate(),
      subjectDocId: doc.id,
    );
  }
}
