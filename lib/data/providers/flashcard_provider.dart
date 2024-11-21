import 'dart:convert';
import 'dart:typed_data';

import 'package:chumzy/core/widgets/loading_screen.dart';
import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class CardProvider with ChangeNotifier {
  List<FlashCard> _flashcards = [];

  List<FlashCard> get flashcards => _flashcards;

  String? getApiKey() {
    return dotenv.env['GEMINI_API_KEY'];
  }

  Future generateFlashcardsInManually(BuildContext context, Subject subject,
      Topic topic, List manuallyInputtedCard) async {
    loadingScreen(context);
    final apiKey = getApiKey();
    String manuallyCardToString = "Manually Inputted Card:\n";
    for (var card in manuallyInputtedCard) {
      manuallyCardToString +=
          "{shortTermOnlyWithoutDefinition : ${card['shortTermOnlyWithoutDefinition']}, definitionOnlyWithoutTheAnswer : ${card['definitionOnlyWithoutTheAnswer']}}\n";
    }

    // print(manuallyCardToString);

    String promptText = """
$manuallyCardToString

Based on the provided data, create ${manuallyInputtedCard.length} quiz cards using the following model. Each card should include: 

A quiz question or statement in definitionOnlyWithoutTheAnswer.
A concise, objective answer (a word or short phrase) in shortTermOnlyWithoutDefinition.
Four multiple-choice options in multichoiceOptions.
The correct multiple-choice answer in multichoiceAnswer.
A true or false statement that relates to the information in the card in trueOrFalseStatement.
The correct true or false answer (either true or false) in trueOrFalseAnswer.

The format for each card should follow this model:
class Card { 
  final String definitionOnlyWithoutTheAnswer; // Quiz question or statement (no answer in it)
  final String shortTermOnlyWithoutDefinition; // Objective answer, word/phrase 
  final List<String> multichoiceOptions;
  final String multichoiceAnswer; 
  final String trueOrFalseStatement; 
  final bool trueOrFalseAnswer; // No Quotations Mark MUST BE BOOLEAN

  Card({
    required this.definitionOnlyWithoutTheAnswer,
    required this.shortTermOnlyWithoutDefinition,
    required this.multichoiceOptions,
    required this.multichoiceAnswer,
    required this.trueOrFalseStatement,
    required this.trueOrFalseAnswer,
  });
}

Please send the result in ${manuallyInputtedCard.length} separate JSON formats (one per card), nothing else.
""";
    try {
      // print(prompt);
      final textModel =
          GenerativeModel(model: "gemini-1.5-flash-8b", apiKey: apiKey!);
      GenerateContentResponse response =
          await textModel.generateContent([Content.text(promptText)]);
      final responseText = response.text;
      debugPrint("RESPONSE: $responseText");

      // Split the response using the three backticks as a delimiter
      List<String> jsonParts = responseText!.split('```');

      // Filter out any empty strings or unwanted parts
      jsonParts = jsonParts
          .where((part) => part.trim().isNotEmpty) // Remove empty parts
          .map((part) =>
              part.replaceFirst('json', '').trim()) // Remove "json" prefix
          .toList();

      // Parse each JSON string into a Dart map
      List<Map<String, dynamic>> jsonData = [];
      for (String part in jsonParts) {
        try {
          jsonData.add(jsonDecode(part));
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      }

      List<FlashCard> cardToBeStoreInFirestore = [];

      for (var item in jsonData) {
        print('Definition: ${item['definitionOnlyWithoutTheAnswer']}');
        print('Short Term: ${item['shortTermOnlyWithoutDefinition']}');
        print('Multiple Choice Options: ${item['multichoiceOptions']}');
        print('Correct Answer: ${item['multichoiceAnswer']}');
        print('True or False Statement: ${item['trueOrFalseStatement']}');
        print('Answer: ${item['trueOrFalseAnswer']}');
        print('------------------');
        cardToBeStoreInFirestore.add(
          FlashCard(
            definitionOnlyWithoutTheAnswer:
                item['definitionOnlyWithoutTheAnswer'],
            shortTermOnlyWithoutDefinition:
                item['shortTermOnlyWithoutDefinition'],
            multichoiceOptions: item['multichoiceOptions'],
            multichoiceAnswer: item['multichoiceAnswer'],
            trueOrFalseStatement: item['trueOrFalseStatement'],
            trueOrFalseAnswer: item['trueOrFalseAnswer'],
          ),
        );
      }

      for (var card in cardToBeStoreInFirestore) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(getCurrentUser()!.uid)
            .collection("subjects")
            .doc(subject.subjectDocId)
            .collection('topics')
            .doc(topic.topicId)
            .collection('cards')
            .add({
          "definitionOnlyWithoutTheAnswer": card.definitionOnlyWithoutTheAnswer,
          "shortTermOnlyWithoutDefinition": card.shortTermOnlyWithoutDefinition,
          "multichoiceOptions": card.multichoiceOptions,
          "multichoiceAnswer": card.multichoiceAnswer,
          "trueOrFalseStatement": card.trueOrFalseStatement,
          "trueOrFalseAnswer": card.trueOrFalseAnswer,
          "subjectId": subject.subjectDocId,
          "topicId": topic.topicId,
          "updatedAt": DateTime.now(),
        });
        print("Added in: ${subject.subjectDocId} ${topic.topicId}");
      }

      //Updating the value of total no items or topic in the subject
      final topicDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(getCurrentUser()!.uid)
          .collection("subjects")
          .doc(subject.subjectDocId)
          .collection('topics')
          .doc(topic.topicId);

      await topicDoc.update({
        'totalNoItems': FieldValue.increment(cardToBeStoreInFirestore.length),
        'updatedAt': DateTime.now(),
      });
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print("Error ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Card generation failed. Try again later.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  //Paste Notes
  Future generateFlashcardsByPasteNote(
    BuildContext context,
    Subject subject,
    Topic topic,
    TextEditingController pasteNoteController,
  ) async {
    loadingScreen(context);
    final apiKey = getApiKey();
    final notes = pasteNoteController.text;

    String promptText = """
DATA : $notes

Based on the provided data, create 5 quiz cards using the following model. Each card should include: 

A quiz question or statement in definitionOnlyWithoutTheAnswer.
A concise, objective answer (a word or short phrase) in shortTermOnlyWithoutDefinition.
Four multiple-choice options in multichoiceOptions.
The correct multiple-choice answer in multichoiceAnswer.
A true or false statement that relates to the information in the card in trueOrFalseStatement.
The correct true or false answer (either true or false) in trueOrFalseAnswer.

The format for each card should follow this model:
class Card { 
  final String definitionOnlyWithoutTheAnswer; // Quiz question or statement (no answer in it)
  final String shortTermOnlyWithoutDefinition; // Objective answer, word/phrase 
  final List<String> multichoiceOptions;
  final String multichoiceAnswer; 
  final String trueOrFalseStatement; 
  final bool trueOrFalseAnswer; // No Quotations Mark MUST BE BOOLEAN

  Card({
    required this.definitionOnlyWithoutTheAnswer,
    required this.shortTermOnlyWithoutDefinition,
    required this.multichoiceOptions,
    required this.multichoiceAnswer,
    required this.trueOrFalseStatement,
    required this.trueOrFalseAnswer,
  });
}

Please send the result in 5 separate JSON formats (one per card), nothing else.
""";
    try {
      // print(prompt);
      final textModel =
          GenerativeModel(model: "gemini-1.5-flash-8b", apiKey: apiKey!);
      GenerateContentResponse response =
          await textModel.generateContent([Content.text(promptText)]);
      final responseText = response.text;
      debugPrint("RESPONSE: $responseText");

      // Split the response using the three backticks as a delimiter
      List<String> jsonParts = responseText!.split('```');

      // Filter out any empty strings or unwanted parts
      jsonParts = jsonParts
          .where((part) => part.trim().isNotEmpty) // Remove empty parts
          .map((part) =>
              part.replaceFirst('json', '').trim()) // Remove "json" prefix
          .toList();

      // Parse each JSON string into a Dart map
      List<Map<String, dynamic>> jsonData = [];
      for (String part in jsonParts) {
        try {
          jsonData.add(jsonDecode(part));
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      }

      List<FlashCard> cardToBeStoreInFirestore = [];

      for (var item in jsonData) {
        print('Definition: ${item['definitionOnlyWithoutTheAnswer']}');
        print('Short Term: ${item['shortTermOnlyWithoutDefinition']}');
        print('Multiple Choice Options: ${item['multichoiceOptions']}');
        print('Correct Answer: ${item['multichoiceAnswer']}');
        print('True or False Statement: ${item['trueOrFalseStatement']}');
        print('Answer: ${item['trueOrFalseAnswer']}');
        print('------------------');
        cardToBeStoreInFirestore.add(
          FlashCard(
            definitionOnlyWithoutTheAnswer:
                item['definitionOnlyWithoutTheAnswer'],
            shortTermOnlyWithoutDefinition:
                item['shortTermOnlyWithoutDefinition'],
            multichoiceOptions: item['multichoiceOptions'],
            multichoiceAnswer: item['multichoiceAnswer'],
            trueOrFalseStatement: item['trueOrFalseStatement'],
            trueOrFalseAnswer: item['trueOrFalseAnswer'],
          ),
        );
      }

      for (var card in cardToBeStoreInFirestore) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(getCurrentUser()!.uid)
            .collection("subjects")
            .doc(subject.subjectDocId)
            .collection('topics')
            .doc(topic.topicId)
            .collection('cards')
            .add({
          "definitionOnlyWithoutTheAnswer": card.definitionOnlyWithoutTheAnswer,
          "shortTermOnlyWithoutDefinition": card.shortTermOnlyWithoutDefinition,
          "multichoiceOptions": card.multichoiceOptions,
          "multichoiceAnswer": card.multichoiceAnswer,
          "trueOrFalseStatement": card.trueOrFalseStatement,
          "trueOrFalseAnswer": card.trueOrFalseAnswer,
          "subjectId": subject.subjectDocId,
          "topicId": topic.topicId,
          "updatedAt": DateTime.now(),
        });
        print("Added in: ${subject.subjectDocId} ${topic.topicId}");
      }

      //Updating the value of total no items or topic in the subject
      final topicDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(getCurrentUser()!.uid)
          .collection("subjects")
          .doc(subject.subjectDocId)
          .collection('topics')
          .doc(topic.topicId);

      await topicDoc.update({
        'totalNoItems': FieldValue.increment(cardToBeStoreInFirestore.length),
        'updatedAt': DateTime.now(),
      });
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print("Error ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Card generation failed. Try again later.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future generateFlashcardsByCaptureImage(
    BuildContext context,
    Subject subject,
    Topic topic,
    Uint8List? imageBytes,
  ) async {
    loadingScreen(context);
    final apiKey = getApiKey();
    // final notes = pasteNoteController.text;

    String promptText = """
Based on the image data, create 5 quiz cards using the following model. Each card should include: 

A quiz question or statement in definitionOnlyWithoutTheAnswer.
A concise, objective answer (a word or short phrase) in shortTermOnlyWithoutDefinition.
Four multiple-choice options in multichoiceOptions.
The correct multiple-choice answer in multichoiceAnswer.
A true or false statement that relates to the information in the card in trueOrFalseStatement.
The correct true or false answer (either true or false) in trueOrFalseAnswer.

The format for each card should follow this model:
class Card { 
  final String definitionOnlyWithoutTheAnswer; // Quiz question or statement (no answer in it)
  final String shortTermOnlyWithoutDefinition; // Objective answer, word/phrase 
  final List<String> multichoiceOptions;
  final String multichoiceAnswer; 
  final String trueOrFalseStatement; 
  final bool trueOrFalseAnswer; // No Quotations Mark MUST BE BOOLEAN

  Card({
    required this.definitionOnlyWithoutTheAnswer,
    required this.shortTermOnlyWithoutDefinition,
    required this.multichoiceOptions,
    required this.multichoiceAnswer,
    required this.trueOrFalseStatement,
    required this.trueOrFalseAnswer,
  });
}

Please send the result in 5 separate JSON formats (one per card), nothing else.
""";
    try {
      // print(prompt);
      final textModel =
          GenerativeModel(model: "gemini-1.5-flash-8b", apiKey: apiKey!);

      GenerateContentResponse response = await textModel.generateContent(
          [Content.text(promptText), Content.data("image/jpeg", imageBytes!)]);

      final responseText = response.text;
      debugPrint("RESPONSE: $responseText");

      // Split the response using the three backticks as a delimiter
      List<String> jsonParts = responseText!.split('```');

      // Filter out any empty strings or unwanted parts
      jsonParts = jsonParts
          .where((part) => part.trim().isNotEmpty) // Remove empty parts
          .map((part) =>
              part.replaceFirst('json', '').trim()) // Remove "json" prefix
          .toList();

      // Parse each JSON string into a Dart map
      List<Map<String, dynamic>> jsonData = [];
      for (String part in jsonParts) {
        try {
          jsonData.add(jsonDecode(part));
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      }

      List<FlashCard> cardToBeStoreInFirestore = [];

      for (var item in jsonData) {
        print('Definition: ${item['definitionOnlyWithoutTheAnswer']}');
        print('Short Term: ${item['shortTermOnlyWithoutDefinition']}');
        print('Multiple Choice Options: ${item['multichoiceOptions']}');
        print('Correct Answer: ${item['multichoiceAnswer']}');
        print('True or False Statement: ${item['trueOrFalseStatement']}');
        print('Answer: ${item['trueOrFalseAnswer']}');
        print('------------------');
        cardToBeStoreInFirestore.add(
          FlashCard(
            definitionOnlyWithoutTheAnswer:
                item['definitionOnlyWithoutTheAnswer'],
            shortTermOnlyWithoutDefinition:
                item['shortTermOnlyWithoutDefinition'],
            multichoiceOptions: item['multichoiceOptions'],
            multichoiceAnswer: item['multichoiceAnswer'],
            trueOrFalseStatement: item['trueOrFalseStatement'],
            trueOrFalseAnswer: item['trueOrFalseAnswer'],
          ),
        );
      }

      for (var card in cardToBeStoreInFirestore) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(getCurrentUser()!.uid)
            .collection("subjects")
            .doc(subject.subjectDocId)
            .collection('topics')
            .doc(topic.topicId)
            .collection('cards')
            .add({
          "definitionOnlyWithoutTheAnswer": card.definitionOnlyWithoutTheAnswer,
          "shortTermOnlyWithoutDefinition": card.shortTermOnlyWithoutDefinition,
          "multichoiceOptions": card.multichoiceOptions,
          "multichoiceAnswer": card.multichoiceAnswer,
          "trueOrFalseStatement": card.trueOrFalseStatement,
          "trueOrFalseAnswer": card.trueOrFalseAnswer,
          "subjectId": subject.subjectDocId,
          "topicId": topic.topicId,
          "updatedAt": DateTime.now(),
        });
        print("Added in: ${subject.subjectDocId} ${topic.topicId}");
      }

      //Updating the value of total no items or topic in the subject
      final topicDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(getCurrentUser()!.uid)
          .collection("subjects")
          .doc(subject.subjectDocId)
          .collection('topics')
          .doc(topic.topicId);

      await topicDoc.update({
        'totalNoItems': FieldValue.increment(cardToBeStoreInFirestore.length),
        'updatedAt': DateTime.now(),
      });
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      print("Error ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Card generation failed. Try again later.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
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

  Future<void> fetchCardsByTopic(Topic topic) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUser()!.uid)
          .collection('subjects')
          .doc(topic.subjectDocId)
          .collection('topics')
          .doc(topic.topicId)
          .collection('cards')
          .get();

      // Populate _flashcards by mapping querySnapshot.docs to Card objects.
      _flashcards = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return FlashCard(
            flashcardId: doc.id,
            definitionOnlyWithoutTheAnswer:
                data['definitionOnlyWithoutTheAnswer'],
            multichoiceAnswer: data["multichoiceAnswer"],
            multichoiceOptions: data["multichoiceOptions"],
            shortTermOnlyWithoutDefinition:
                data["shortTermOnlyWithoutDefinition"],
            trueOrFalseAnswer: data["trueOrFalseAnswer"],
            trueOrFalseStatement: data["trueOrFalseStatement"],
            topicId: topic.topicId,
            lastUpdatedAt: data['updateAt']);
      }).toList();

      print('Flashcards loaded: ${_flashcards.length}');
      notifyListeners();
    } catch (e) {
      print('Error fetching cards: $e');
    }
  }
}
// FlashCard(
//   definitionOnlyWithoutTheAnswer:
//       "The process by which plants convert sunlight into energy.",
//   shortTermOnlyWithoutDefinition: "Photosynthesis",
//   multichoiceOptions: [
//     "Respiration",
//     "Photosynthesis",
//     "Digestion",
//     "Evaporation"
//   ],
//   multichoiceAnswer: "Photosynthesis",
//   trueOrFalseStatement: "Photosynthesis occurs in animal cells.",
//   trueOrFalseAnswer: false,
// ),
// FlashCard(
//   definitionOnlyWithoutTheAnswer:
//       "A shape with four equal sides and four right angles.",
//   shortTermOnlyWithoutDefinition: "Square",
//   multichoiceOptions: ["Rectangle", "Square", "Circle", "Triangle"],
//   multichoiceAnswer: "Square",
//   trueOrFalseStatement: "A square has four equal sides.",
//   trueOrFalseAnswer: true,
// ),
// FlashCard(
//   definitionOnlyWithoutTheAnswer: "The chemical symbol for water.",
//   shortTermOnlyWithoutDefinition: "H2O",
//   multichoiceOptions: ["CO2", "H2O", "O2", "N2"],
//   multichoiceAnswer: "H2O",
//   trueOrFalseStatement: "H2O is the chemical formula for oxygen gas.",
//   trueOrFalseAnswer: false,
// ),
// FlashCard(
//   definitionOnlyWithoutTheAnswer: "The largest planet in our solar system.",
//   shortTermOnlyWithoutDefinition: "Jupiter",
//   multichoiceOptions: ["Earth", "Mars", "Jupiter", "Saturn"],
//   multichoiceAnswer: "Jupiter",
//   trueOrFalseStatement: "Jupiter is smaller than Earth.",
//   trueOrFalseAnswer: false,
// ),
// FlashCard(
//   definitionOnlyWithoutTheAnswer: "The number of continents on Earth.",
//   shortTermOnlyWithoutDefinition: "Seven",
//   multichoiceOptions: ["Five", "Six", "Seven", "Eight"],
//   multichoiceAnswer: "Seven",
//   trueOrFalseStatement: "There are seven continents on Earth.",
//   trueOrFalseAnswer: true,
// ),
