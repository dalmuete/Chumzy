import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:flutter/material.dart';


class TopicProvider with ChangeNotifier {
  List<Topic>? _topics = [];

  List<Topic>? get topics => _topics;

  void loadTopicsForSubject(Subject subject) {
    _topics = subject.topics;
    notifyListeners();
  }

  void clearTopics() {
    _topics = [];
    notifyListeners();
  }
}
