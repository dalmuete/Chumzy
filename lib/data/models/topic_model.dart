import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String title;
  final int totalNoItems;
  final DateTime lastUpdated;
  final String? subjectDocId;
  final String? topicId;
  Topic({
    required this.title,
    required this.totalNoItems,
    required this.lastUpdated,
    this.subjectDocId,
    this.topicId,
  });

  factory Topic.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Topic(
      title: data['title'],
      totalNoItems: data['totalNoItems'],
      lastUpdated: (data['createdAt'] as Timestamp).toDate(),
      subjectDocId: data['subjectId'],
      topicId: doc.id,
    );
  }
}
