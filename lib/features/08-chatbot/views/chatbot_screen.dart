import 'package:chumzy/core/widgets/textfields/custom_graytextfield.dart';
import 'package:chumzy/data/providers/message_bot_provider.dart';
import 'package:chumzy/features/08-chatbot/widgets/header_bot.dart';
import 'package:chumzy/features/08-chatbot/widgets/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotScreen extends StatelessWidget {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<MessageBotProvider>(
      builder: (context, botProvider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                // Header chat bot
                const HeaderChatBot(),
                const Gap(30),
                // Message List
                const Expanded(
                  child: MessagesList(),
                ),
                // TextField with keyboard adjustment
                Row(
                  children: [
                    // TextField for user input
                    Expanded(
                      child: CustomGrayTextField(
                        controller: messageController,
                        hintText: "Ask anything",
                      ),
                    ),
                    // Send button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (messageController.text.isEmpty) {
                              debugPrint("Message controller is empty.");
                              return;
                            }
                            await botProvider
                                .sendMessage(messageController.text);
                            messageController.clear();
                          },
                          icon: const Icon(Icons.send),
                        ),
                        // IconButton(
                        //   onPressed: () async {
                        //     await botProvider.clearChat();
                        //   },
                        //   icon: const Icon(Icons.clear_rounded),
                        // ),
                      ],
                    ),
                  ],
                ),
                Gap(20.r),
              ],
            ),
          ),
        );
      },
    );
  }
}
