import 'package:chumzy/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

class MessageBotProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isGeneratingReply = false;

  bool get isGeneratingReply => _isGeneratingReply;

  //fetch api key
  String? getApiKey() {
    return dotenv.env['GEMINI_API_KEY'];
  }

  // Send message function
  Future sendMessage(String promptText) async {
    try {
      _setGeneratingReply(true);

      final apiKey = getApiKey();
      final userId = getCurrentUserId();
      final sentMessageId = const Uuid().v4();

      // Save the user's message
      Message userMessage = Message(
        id: sentMessageId,
        message: promptText,
        createdAt: DateTime.now(),
        isMine: true,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .doc(sentMessageId)
          .set(userMessage.toMap());

      // Fetch and construct conversation history
      final previousMessages = await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      String conversationHistory = "";
      for (var doc in previousMessages.docs.reversed) {
        final messageData = doc.data();
        final isMine = messageData['isMine'] as bool;
        final messageText = messageData['message'] as String;

        conversationHistory +=
            isMine ? "You: $messageText\n" : "Bot: $messageText\n";
      }

      String finalPrompt =
          "$conversationHistory\nRespond as a concise, clear assistant without using bullets or special characters. DONT EVER EVER MENTION THE BOT THAT IS JUST FOR YOUR GUIDE.";

      debugPrint("Final Prompt: $finalPrompt");

      // Generate AI response
      final textModel =
          GenerativeModel(model: "gemini-1.5-flash-8b", apiKey: apiKey!);

      GenerateContentResponse response =
          await textModel.generateContent([Content.text(finalPrompt)]);
      final responseText = response.text;
      debugPrint("RESPONSE: $responseText");

      // Save response to Firebase
      final receivedMessageId = const Uuid().v4();
      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText!,
        createdAt: DateTime.now(),
        isMine: false,
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .doc(receivedMessageId)
          .set(responseMessage.toMap());
    } catch (e) {
      if (e.toString().contains("\"code\": 503") &&
          e.toString().contains("\"status\": \"UNAVAILABLE\"")) {
        debugPrint(
            "503 Error: The model is overloaded. Please try again later.");

        final fallbackMessageId = const Uuid().v4();
        final fallbackMessage = Message(
          id: fallbackMessageId,
          message: "The model is currently overloaded. Please try again later.",
          createdAt: DateTime.now(),
          isMine: false,
        );
        final userId = getCurrentUserId();

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('messages')
            .doc(fallbackMessageId)
            .set(fallbackMessage.toMap());
      } else {
        debugPrint("An unexpected error occurred: $e");
        rethrow;
      }
    } finally {
      _setGeneratingReply(false);
    }
  }

  void _setGeneratingReply(bool value) {
    _isGeneratingReply = value;
    notifyListeners();
  }

  // Get user id
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  Stream<List<Message>> getAllMessages() {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception("User is not authenticated");
    }

    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
      });
    } catch (e) {
      throw Exception("Failed to fetch messages: ${e.toString()}");
    }
  }

  Future clearChat() async {
    String userId = getCurrentUserId()!;

    try {
      // Get a reference to the user's messages collection
      var messagesCollection =
          _firestore.collection("users").doc(userId).collection("messages");

      // Get all messages in the collection
      var querySnapshot = await messagesCollection.get();

      // Iterate through each document and delete them
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Chat cleared successfully!");
    } catch (e) {
      print("Error clearing chat: $e");
    }
  }
}
