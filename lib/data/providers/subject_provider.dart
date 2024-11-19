import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:flutter/material.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _subjects = [
    Subject(
        lineColor: Colors.pink.shade900,
        title: "MAD 101",
        totalNoItems: 10,
        lastUpdated: DateTime(2024, 11, 11, 4, 10),
        topics: [
          Topic(
            title:
                "Chapter 1: Introduction to Mobile Application Development with Dart and Flutter",
            totalNoItems: 10,
            lastUpdated: DateTime(2024, 11, 11, 4, 10),
          ),
          Topic(
            title:
                "Chapter 2: Setting Up Your Development Environment for Flutter Development",
            totalNoItems: 7,
            lastUpdated: DateTime(2024, 11, 10, 10, 0),
          ),
          Topic(
            title:
                "Chapter 3: Building Your First Mobile App with Flutter and Dart",
            totalNoItems: 12,
            lastUpdated: DateTime(2024, 11, 8, 8, 30),
          ),
          Topic(
            title:
                "Chapter 4: Understanding Widgets and the Widget Tree in Flutter",
            totalNoItems: 30,
            lastUpdated: DateTime(2024, 11, 1, 16, 0),
          ),
          Topic(
            title:
                "Chapter 5: Navigating Between Screens in Flutter: Push, Pop, and Routes",
            totalNoItems: 18,
            lastUpdated: DateTime.now(),
          ),
          Topic(
            title:
                "Chapter 6: Managing State in Flutter Applications: Provider and setState",
            totalNoItems: 15,
            lastUpdated: DateTime(2024, 11, 5, 13, 50),
          ),
          Topic(
            title:
                "Chapter 7: Understanding Flutter’s Hot Reload and Hot Restart Features",
            totalNoItems: 22,
            lastUpdated: DateTime(2024, 10, 25, 17, 20),
          ),
          Topic(
            title:
                "Chapter 8: Handling User Input in Flutter: TextFields, Buttons, and Forms",
            totalNoItems: 18,
            lastUpdated: DateTime(2024, 9, 15, 11, 30),
          ),
          Topic(
            title:
                "Chapter 9: Working with External Packages and APIs in Flutter",
            totalNoItems: 25,
            lastUpdated: DateTime(2024, 8, 5, 14, 45),
          ),
          Topic(
            title:
                "Chapter 10: Debugging and Performance Optimization for Flutter Apps",
            totalNoItems: 9,
            lastUpdated: DateTime(2024, 6, 22, 9, 10),
          ),
        ]),
    Subject(
      lineColor: Colors.green,
      title: "SAD 101",
      totalNoItems: 7,
      lastUpdated: DateTime(2024, 11, 10, 10, 0),
      topics: [
        Topic(
          title: "Chapter 1: Introduction to System Architecture",
          totalNoItems: 5,
          lastUpdated: DateTime(2024, 5, 10, 14, 0),
        ),
        Topic(
          title: "Chapter 2: Software Design Principles",
          totalNoItems: 8,
          lastUpdated: DateTime(2024, 5, 12, 16, 0),
        ),
        Topic(
          title: "Chapter 3: Modeling and Diagramming Techniques",
          totalNoItems: 6,
          lastUpdated: DateTime(2024, 5, 14, 18, 30),
        ),
        Topic(
          title: "Chapter 4: Component-Based Design",
          totalNoItems: 7,
          lastUpdated: DateTime(2024, 5, 16, 10, 20),
        ),
        Topic(
          title:
              "Chapter 5: Debugging and Performance Optimization for Systems",
          totalNoItems: 9,
          lastUpdated: DateTime(2024, 6, 22, 9, 10),
        ),
      ],
    ),
    Subject(
      lineColor: Colors.orange,
      title: "CC 105",
      totalNoItems: 12,
      lastUpdated: DateTime(2024, 11, 8, 8, 30),
      topics: [
        Topic(
          title: "Chapter 1: Introduction to Computing",
          totalNoItems: 10,
          lastUpdated: DateTime(2024, 5, 5, 9, 0),
        ),
        Topic(
          title: "Chapter 2: Basic Data Structures",
          totalNoItems: 8,
          lastUpdated: DateTime(2024, 5, 8, 10, 15),
        ),
        Topic(
          title: "Chapter 3: Algorithms and Problem Solving",
          totalNoItems: 7,
          lastUpdated: DateTime(2024, 5, 12, 12, 45),
        ),
        Topic(
          title: "Chapter 4: Introduction to Programming Concepts",
          totalNoItems: 9,
          lastUpdated: DateTime(2024, 5, 15, 13, 20),
        ),
        Topic(
          title: "Chapter 5: Operating Systems and File Management",
          totalNoItems: 6,
          lastUpdated: DateTime(2024, 5, 18, 14, 50),
        ),
      ],
    ),
    Subject(
      lineColor: Colors.purple,
      title: "CO 102",
      totalNoItems: 30,
      lastUpdated: DateTime(2024, 11, 1, 16, 0),
      topics: [
        Topic(
          title: "Chapter 1: Introduction to Computer Organization",
          totalNoItems: 10,
          lastUpdated: DateTime(2024, 10, 15, 8, 30),
        ),
        Topic(
          title: "Chapter 2: Digital Logic and Boolean Algebra",
          totalNoItems: 12,
          lastUpdated: DateTime(2024, 10, 18, 9, 0),
        ),
        Topic(
          title: "Chapter 3: CPU Architecture and Instruction Set",
          totalNoItems: 8,
          lastUpdated: DateTime(2024, 10, 22, 11, 45),
        ),
      ],
    ),
    Subject(
      lineColor: Colors.teal,
      title: "OOP 102",
      totalNoItems: 18,
      lastUpdated: DateTime.now(),
    ),
    Subject(
      lineColor: Colors.red,
      title: "WEB 101",
      totalNoItems: 15,
      lastUpdated: DateTime(2024, 11, 5, 13, 50),
    ),
    Subject(
      lineColor: Colors.cyan,
      title: "AI 101",
      totalNoItems: 22,
      lastUpdated: DateTime(2024, 10, 25, 17, 20),
    ),
    Subject(
      lineColor: Colors.amber,
      title: "ML 201",
      totalNoItems: 18,
      lastUpdated: DateTime(2024, 9, 15, 11, 30),
    ),
    Subject(
      lineColor: Colors.indigo,
      title: "DS 301",
      totalNoItems: 25,
      lastUpdated: DateTime(2024, 8, 5, 14, 45),
    ),
    Subject(
      lineColor: Colors.deepOrange,
      title: "UX 101",
      totalNoItems: 9,
      lastUpdated: DateTime(2024, 6, 22, 9, 10),
    ),
  ];
  List<Subject> get subjects => _subjects;

  int _selectedSubjectIndex = 0;
  Subject getSubjectByIndex(int index) {
    return _subjects[index];
  }

  int get selectedSubjectIndex => _selectedSubjectIndex;

  set selectedSubjectIndex(int index) {
    _selectedSubjectIndex = index;
    notifyListeners();
  }

  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
  }

  void updateSubject(int index, Subject updatedSubject) {
    if (index >= 0 && index < _subjects.length) {
      _subjects[index] = updatedSubject;
      notifyListeners();
    }
  }

  void removeSubject(int index) {
    if (index >= 0 && index < _subjects.length) {
      _subjects.removeAt(index);
      notifyListeners();
    }
  }

  void setSubjects(List<Subject> subjects) {
    _subjects = subjects;
    notifyListeners();
  }

  void clearSubjects() {
    _subjects.clear();
    notifyListeners();
  }
}
