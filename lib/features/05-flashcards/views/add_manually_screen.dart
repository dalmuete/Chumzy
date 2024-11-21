import 'package:animated_custom_dropdown/custom_dropdown.dart';
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

class AddManuallyScreen extends StatefulWidget {
  AddManuallyScreen({super.key, required this.subject, required this.topic});

  Topic topic;
  Subject subject;

  @override
  State<AddManuallyScreen> createState() => _AddManuallyScreenState();
}

class _AddManuallyScreenState extends State<AddManuallyScreen> {
  List<Map<String, String>> tempCardsList = [
    {"term": "sample term 1", "definition": "sample definition 1"},
    {"term": "sample term 2", "definition": "sample definition 2"}
  ];
 
  void _addOrEditFlashcard(String term, String definition, {int? index}) {
    setState(() {
      if (index != null) {
        tempCardsList[index] = {"term": term, "definition": definition};
      } else {
        tempCardsList.add({"term": term, "definition": definition});
      }
    });
  }

  Future<void> _showFlashcardDialog({int? index}) async {
    String initialTerm = "";
    String initialDefinition = "";

    if (index != null) {
      initialTerm = tempCardsList[index]["term"] ?? "";
      initialDefinition = tempCardsList[index]["definition"] ?? "";
    }

    await showFlashcardDialog(
      context,
      (term, definition) => _addOrEditFlashcard(term, definition, index: index),
      isEdit: index != null,
      initialTerm: initialTerm,
      initialDefinition: initialDefinition,
    );
  }

  void _handleDeleteConfirmed(int index) {
    setState(() {
      tempCardsList.removeAt(index);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    print(widget.topic.title);
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
                                  await _showExitConfirmationDialog() ?? false;
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
                            "Add Manually",
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
              Text(
                "ⓘ To edit the card, just swipe LEFT. To remove it, swipe RIGHT.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
              Gap(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${tempCardsList.length}",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600)),
                      tempCardsList.length > 1 ? Text(" cards") : Text(" card"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _showFlashcardDialog();
                    },
                    child: Text(
                      "+ Add card",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ],
              ),
              tempCardsList.isEmpty
                  ? Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity:
                              Theme.of(context).brightness == Brightness.dark
                                  ? 0.5
                                  : 1.0,
                          child: Image.asset(
                            'assets/images/sad_2.png',
                            width: 100.r,
                          ),
                        ),
                        Gap(20.h),
                        Text(
                            "No cards added yet.\nTap '+ Add card' to create\nyour first flashcard.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                            )),
                        Gap(50.h)
                      ],
                    ))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: tempCardsList.length,
                        itemBuilder: (context, index) {
                          final reverseIndex = tempCardsList.length - 1 - index;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.r),
                            child: Dismissible(
                              dismissThresholds: {
                                DismissDirection.startToEnd: 0.9,
                                DismissDirection.endToStart: 0.9,
                              },
                              key: UniqueKey(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  await _showFlashcardDialog(
                                      index: reverseIndex);
                                  return false;
                                } else if (direction ==
                                    DismissDirection.startToEnd) {
                                  bool? shouldDelete =
                                      await removeFlashcardDialog(
                                          context,
                                          tempCardsList[reverseIndex]["term"] ??
                                              "this card");

                                  if (shouldDelete == true) {
                                    _handleDeleteConfirmed(reverseIndex);
                                    return true;
                                  }
                                }
                                return false;
                              },
                              background: Container(
                                margin: EdgeInsets.all(5.r),
                                padding: EdgeInsets.all(20.r),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Icon(Icons.delete,
                                    color: Colors.white, size: 30.r),
                              ),
                              secondaryBackground: Container(
                                margin: EdgeInsets.all(5.r),
                                padding: EdgeInsets.all(20.r),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Icon(Icons.edit,
                                    color: Colors.white, size: 30.r),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: CardItemCard(
                                  term:
                                      tempCardsList[reverseIndex]["term"] ?? "",
                                  definition: tempCardsList[reverseIndex]
                                          ["definition"] ??
                                      "",
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
