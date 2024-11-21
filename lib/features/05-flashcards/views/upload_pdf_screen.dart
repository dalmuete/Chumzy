import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:camera/camera.dart';
import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/data/providers/topic_provider.dart';
import 'package:chumzy/features/04-topics/widgets/card_item_card.dart';
import 'package:chumzy/features/05-flashcards/widgets/remove_dialog.dart';
import 'package:chumzy/features/05-flashcards/widgets/term_definition_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io'; // Required to work with the `File` class

class UploadPdfScreen extends StatefulWidget {
  UploadPdfScreen({super.key, required this.subject, required this.topic});

  Topic topic;
  Subject subject;
  @override
  State<UploadPdfScreen> createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  List<FlashCard> tempCardsList = [
    FlashCard(
        definitionOnlyWithoutTheAnswer: "1definitionOnlyWithoutTheAnswer",
        shortTermOnlyWithoutDefinition: "1shortTermOnlyWithoutDefinition",
        multichoiceOptions: ["a", "b", "c", "d"],
        multichoiceAnswer: "1multichoiceAnswer",
        trueOrFalseStatement: "1trueOrFalseStatement",
        trueOrFalseAnswer: true),
    FlashCard(
        definitionOnlyWithoutTheAnswer: "2definitionOnlyWithoutTheAnswer",
        shortTermOnlyWithoutDefinition: "2shortTermOnlyWithoutDefinition",
        multichoiceOptions: ["a", "b", "c", "d"],
        multichoiceAnswer: "2multichoiceAnswer",
        trueOrFalseStatement: "2trueOrFalseStatement",
        trueOrFalseAnswer: true),
    FlashCard(
        definitionOnlyWithoutTheAnswer: "3definitionOnlyWithoutTheAnswer",
        shortTermOnlyWithoutDefinition: "3shortTermOnlyWithoutDefinition",
        multichoiceOptions: ["a", "b", "c", "d"],
        multichoiceAnswer: "3multichoiceAnswer",
        trueOrFalseStatement: "3trueOrFalseStatement",
        trueOrFalseAnswer: true)
  ];

  Future<bool?> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Unsaved Changes',
            style: TextStyle(fontSize: 20.sp),
          ),
          content: const Text(
            'If you go back now, all changes will be lost. Do you still want to exit?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
      print("File selection canceled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(right: 30.w, left: 30.w, bottom: 0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Gap(50.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PopScope(
                              canPop: false,
                              onPopInvokedWithResult:
                                  (bool didPop, Object? result) async {
                                if (tempCardsList.isEmpty) {
                                  Navigator.pop(context);
                                  return;
                                }
                                if (didPop) {
                                  return;
                                }
                                final bool shouldPop =
                                    await _showExitConfirmationDialog() ??
                                        false;
                                if (context.mounted && shouldPop) {
                                  Navigator.pop(context);
                                }
                              },
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10.r),
                                splashColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                                onTap: () async {
                                  if (tempCardsList.isEmpty) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  final bool shouldPop =
                                      await _showExitConfirmationDialog() ??
                                          false;
                                  if (context.mounted && shouldPop) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 5.r, top: 5.r, bottom: 5.r),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    size: 24.r,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Gap(20.w),
                            Image.asset(
                              'assets/icons/flashcard_icon.png',
                              height: 25.h,
                            ),
                            Gap(10.w),
                            Text(
                              "Upload PDF",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: tempCardsList.isNotEmpty ? () {} : null,
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                              color: tempCardsList.isNotEmpty
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(20.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: Text("Pick a File"),
                    ),
                    SizedBox(height: 20),
                    _selectedFile != null
                        ? Text("Selected File: ${_selectedFile!.path}")
                        : Text("No file selected."),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
