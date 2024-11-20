import 'package:chumzy/core/widgets/loading_screen.dart';
import 'package:chumzy/core/widgets/snackbar.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TopicProvider with ChangeNotifier {
  final _firebaseFirestore = FirebaseFirestore.instance;
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

  //Get current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //Loading screen
  //show loading screen
  void loadingScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingScreen();
      },
    );
  }

  // Save Topics to Firebase
  void saveTopic(
    BuildContext context,
    List<TextEditingController> controllers,
    Subject subject,
    List<FocusNode> focusNode,
  ) async {
    try {
      int numberOfTopicToAdd = controllers.length;

      // Show loading screen
      loadingScreen(context);

      for (var i = 0; i < numberOfTopicToAdd; i++) {
        String controllerText = controllers[i].text;

        // Storing to Firestore db individually
        await _firebaseFirestore
            .collection("users")
            .doc(getCurrentUser()!.uid)
            .collection("subjects")
            .doc(subject.subjectDocId)
            .collection('topics')
            .add({
          'title': controllerText,
          'createdAt': DateTime.now(),
          'addedBy': getCurrentUser()!.uid,
          'updatedAt': DateTime.now(),
          'subjectId': subject.subjectDocId,
          'totalNoItems': 0,
        });

        // controllers[i].dispose();
        // focusNode[i].dispose();
      }

      controllers.clear();
      focusNode.clear();

      controllers.add(TextEditingController());
      focusNode.add(FocusNode());

      //Updating the value of total no items or topic in the subject
      final subjectDoc = _firebaseFirestore
          .collection("users")
          .doc(getCurrentUser()!.uid)
          .collection("subjects")
          .doc(subject.subjectDocId);

      await subjectDoc.update({
        'totalNoItems': FieldValue.increment(numberOfTopicToAdd),
        'createdAt': DateTime.now(),
      });

      Navigator.pop(context);
      Navigator.pop(context);
      showCustomToast(
        context: context,
        leading: Icon(Icons.check_circle, color: Colors.green),
        message: "${numberOfTopicToAdd} topic(s) added successfully!",
      );
    } catch (error) {
      Navigator.pop(context);
      showCustomToast(
        context: context,
        leading: Icon(Icons.error, color: Colors.red),
        message: 'Failed to save topics: $error',
      );
    }
  }

  void printingValues(
    Subject subject,
    List<TextEditingController> controllers,
  ) {
    print("--- SUBJECT HERE ---");
    print(subject.title);
    print(subject.subjectDocId);
    print("--- CONTROLLERS HERE ---");
    for (var controller in controllers) {
      print(controller.text);
    }
  }
}
