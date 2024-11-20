import 'package:chumzy/core/widgets/loading_screen.dart';
import 'package:chumzy/core/widgets/snackbar.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubjectProvider with ChangeNotifier {
  //Firebase firestore
  final _firebaseFirestore = FirebaseFirestore.instance;

  List<Subject> _subjects = [];

  List<Subject> get subjects => _subjects;

  bool _isLoadingForSubject = false;

  bool get isLoadingForSubject => _isLoadingForSubject;

  int _selectedSubjectIndex = 0;

  Subject getSubjectByIndex(int index) {
    return _subjects[index];
  }

  int get selectedSubjectIndex => _selectedSubjectIndex;

  // set selectedSubjectIndex(int index) {
  //   _selectedSubjectIndex = index;
  //   notifyListeners();
  // }

  void getSelectedSubjectIndex(int index) {
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

  //fetch subjects function
  Future<void> fetchSubjects() async {
    try {
      final userId = getCurrentUser()!.uid;
      _isLoadingForSubject = true;

      // Fetch all subjects
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('subjects')
          .get();

      // Map each subject document to a Subject object and fetch its topics
      final subjectsList =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final subject = Subject.fromFirestore(doc);

        // Fetch topics for this subject
        final topicsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('subjects')
            .doc(subject.subjectDocId)
            .collection('topics')
            .get();

        final topics = topicsSnapshot.docs.map((topicDoc) {
          return Topic.fromFirestore(topicDoc);
        }).toList();

        // Attach topics to the subject
        subject.topics = topics;
        return subject;
      }).toList());

      _subjects = subjectsList;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching subjects with topics: $e");
    }
  }

  //Get current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //show loading screen
  void loadingScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingScreen();
      },
    );
  }

  // Storing to firestore
  void saveSubject(
    BuildContext context,
    List<TextEditingController> controllers,
    List<Color> subjectColors,
    List<FocusNode> focusNode,
  ) async {
    try {
      int numberOfSubjectToAdd = controllers.length;

      // Show loading screen
      loadingScreen(context);

      for (var i = 0; i < numberOfSubjectToAdd; i++) {
        String controllerText = controllers[i].text;
        String subjectColorTemp =
            "0x${subjectColors[i].value.toRadixString(16).toUpperCase()}";

        // Storing to Firestore db individually
        await _firebaseFirestore
            .collection("users")
            .doc(getCurrentUser()!.uid)
            .collection("subjects")
            .add({
          'title': controllerText,
          'lineColor': subjectColorTemp,
          'createdAt': DateTime.now(),
          'addedBy': getCurrentUser()!.uid,
          'updatedAt': DateTime.now(),
          'totalNoItems': 0,
        });

        debugPrint(
            "DISPOSING CONTROLLER AND FOCUS NODE HERE IN SAVE SUBJECT FUNCTION");
        controllers[i].clear();
        // controllers[i].dispose();
        // focusNode[i].dispose();
      }

      debugPrint("CLEARING THE CONTROLLER FOCUS AND SUBJECT COLOR");
      subjectColors.clear();
      controllers.clear();
      focusNode.clear();

      debugPrint("ADDING THE CONTROLLER FOCUS AND SUBJECT COLOR");

      controllers.add(TextEditingController());
      focusNode.add(FocusNode());
      subjectColors.add(Colors.white);

      Navigator.pop(context);
      Navigator.pop(context);
      showCustomToast(
        context: context,
        leading: Icon(Icons.check_circle, color: Colors.green),
        message: "${numberOfSubjectToAdd} subject(s) added successfully!",
      );

      notifyListeners();
    } catch (error) {
      // Close loading screen if an error occurs
      Navigator.pop(context);

      // Show error message
      showCustomToast(
        context: context,
        leading: Icon(Icons.error, color: Colors.red),
        message: 'Failed to save subjects: $error',
      );
    }
  }

  // fetch subject stream for strea mbuilder -> real time
  Stream<QuerySnapshot<Map<String, dynamic>>> getSubjectsStream() {
    return _firebaseFirestore
        .collection('users')
        .doc(getCurrentUser()!.uid)
        .collection('subjects')
        .snapshots();
  }

  // count how many topics inside the subject
  // Future<int> totalNoOfTopicsInSubject(String subjectDoc) async {
  //   final snapshot = await _firebaseFirestore
  //       .collection('users')
  //       .doc(getCurrentUser()!.uid)
  //       .collection('subjects')
  //       .doc(subjectDoc)
  //       .collection('topics')
  //       .get();

  //   return snapshot.docs.length;
  // }
}
