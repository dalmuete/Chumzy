import 'package:chumzy/core/widgets/loading_screen.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubjectProvider with ChangeNotifier {
  //Firebase firestore
  final _firebaseFirestore = FirebaseFirestore.instance;

  List<Subject> _subjects = [];
  List<Subject> _searchedSubjects = [];
  List<Topic> _searchedTopics = [];

  List<Subject> get subjects => _subjects;
  List<Subject> get searchedSubjects => _searchedSubjects;
  List<Topic> get searchedTopics => _searchedTopics;

  // For subject
  bool _isSearched = false;
  bool get isSearched => _isSearched;

  //For Topic
  bool _isSearchedTopic = false;
  bool get isSearchedTopic => _isSearchedTopic;

  bool _isLoadingForSubject = false;
  bool get isLoadingForSubject => _isLoadingForSubject;

  bool _isAscending = false;
  bool get isAscending => _isAscending;

  bool _isAscendingTopic = false;
  bool get isAscendingTopic => _isAscendingTopic;

  bool _isSortByDate = true;
  bool get isSortByDate => _isSortByDate;

  bool _isSortByDateTopic = true;
  bool get isSortByDateTopic => _isSortByDateTopic;

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
          .orderBy('createdAt', descending: true)
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
      _isSearched = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching subjects with topics: $e");
    } finally {
      _isLoadingForSubject = false;
    }
  }

  void searchSubjects(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      _searchedSubjects = _subjects
          .where((subject) =>
              subject.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      _isSearched = true;
    } else {
      _searchedSubjects = [];
      _isSearched = false;
    }

    notifyListeners();
  }

  void sortDescSubject() {
    int compareByDate(a, b) {
      return _isAscending
          ? a.lastUpdated.compareTo(b.lastUpdated)
          : b.lastUpdated.compareTo(a.lastUpdated);
    }

    int compareByTitle(a, b) {
      String titleA = a.title?.trim().toLowerCase() ?? '';
      String titleB = b.title?.trim().toLowerCase() ?? '';
      return _isAscending ? titleA.compareTo(titleB) : titleB.compareTo(titleA);
    }

    if (_isSearched) {
      _searchedSubjects.sort((a, b) {
        return _isSortByDate ? compareByDate(a, b) : compareByTitle(a, b);
      });
    } else {
      _subjects.sort((a, b) {
        return _isSortByDate ? compareByDate(a, b) : compareByTitle(a, b);
      });
    }
  }

  //Get current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  //isSearch false Subject
  void isSearchToggle(TextEditingController controller) {
    controller.clear();
    _isSearched = false;
    notifyListeners();
  }

  //isSearch false Topic
  void isSearchToggleTopic(TextEditingController controller) {
    controller.clear();
    _isSearchedTopic = false;
    notifyListeners();
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

      fetchSubjects();
      notifyListeners();
    } catch (error) {
      // Close loading screen if an error occurs
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save subjects: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to sort subjects
  void toggleArrowForSortingSubject() {
    _isAscending = !_isAscending;
    notifyListeners();
  }

  // Function to sort by title or Date
  void toggleSortByDateOrTitle() {
    _isSortByDate = !_isSortByDate;
    notifyListeners();
  }

  // Search Topic
  void searchTopic(Subject subject, String query) {
    // Assuming topics have a 'name' property
    _isSearchedTopic = true;
    _searchedTopics = subject.topics!
        .where(
            (topic) => topic.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // _searchedTopics.sort((a, b) {
    //   if (!_isAscendingTopic) {
    //     return b.lastUpdated.compareTo(a.lastUpdated); // Descending order
    //   } else {
    //     return a.lastUpdated.compareTo(b.lastUpdated); // Ascending order
    //   }
    // });

    if (_searchedTopics.isEmpty) {
      print("No topics found for '$query'.");
    } else {
      print("Found topics:");
      for (var topic in _searchedTopics) {
        print(topic.title);
      }
    }
  }

  void toggleArrowForSortingTopic() {
    _isAscendingTopic = !_isAscendingTopic;
    debugPrint("Clicked");
    notifyListeners();
  }

  // Function to sort by title or Date
  void toggleSortByDateOrTitleTopic() {
    _isSortByDateTopic = !_isSortByDateTopic;
    notifyListeners();
  }

  clearSearchTopic() {
    _isSearchedTopic = false;
    _searchedTopics = [];
    notifyListeners();
  }

  // fetch subject stream for strea mbuilder -> real time
  // Stream<QuerySnapshot<Map<String, dynamic>>> getSubjectsStream() {
  //   return _firebaseFirestore
  //       .collection('users')
  //       .doc(getCurrentUser()!.uid)
  //       .collection('subjects')
  //       .snapshots();
  // }

  void getSearchedSubject(String value) {
    _subjects = _subjects
        .where((subject) =>
            subject.title.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
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
