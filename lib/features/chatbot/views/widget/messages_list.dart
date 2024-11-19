import 'package:chumzy/data/models/message.dart';
import 'package:chumzy/data/providers/message_bot_provider.dart';
import 'package:chumzy/features/chatbot/views/widget/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final ScrollController _scrollController = ScrollController();

  Future<String?> getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] as String?;
      } else {
        debugPrint("User document does not exist");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
      return null;
    }
  }

  Future<void> _addFirstMessage(
      BuildContext context, MessageBotProvider botProvider) async {
    final userName = await getUserName(botProvider.getCurrentUserId()!);
    final firstIdMessage = const Uuid().v4();
    final message =
        "Hi ${userName!}! Welcome to Chumzy! If you need help with anything from your lecture, just ask me. I’m here to make studying easier. I’m ChumzyAI, your study buddy, sharp and ready!";
    final firstMessage = Message(
      id: firstIdMessage,
      message: message,
      createdAt: DateTime.now(),
      isMine: false,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(botProvider.getCurrentUserId())
        .collection('messages')
        .doc(firstIdMessage)
        .set(firstMessage.toMap());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final botProvider = Provider.of<MessageBotProvider>(context);
    return StreamBuilder<List<Message>>(
      stream: botProvider.getAllMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _addFirstMessage(context, botProvider);
          });
          return const Center(child: Text('Setting up Chumzy...'));
        } else {
          final messages = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return MessageTile(
                message: message,
                isOutgoing: message.isMine,
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
