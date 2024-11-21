import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Future<bool?> showFlashcardDialog(
    BuildContext context, Function(String term, String definition) onAdd,
    {bool isEdit = false,
    String initialTerm = "",
    String initialDefinition = ""}) async {
  TextEditingController termController =
      TextEditingController(text: initialTerm);
  TextEditingController definitionController =
      TextEditingController(text: initialDefinition);

  bool isButtonEnabled = false;

  void updateButtonState() {
    final hasChanges = termController.text.trim() != initialTerm ||
        definitionController.text.trim() != initialDefinition;
    final hasInput = termController.text.trim().isNotEmpty &&
        definitionController.text.trim().isNotEmpty;

    isButtonEnabled = hasInput && (!isEdit || hasChanges);
  }

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              isEdit ? "Edit Flashcard" : "Add Flashcard",
              style: TextStyle(fontSize: 20.sp),
            ),
            contentPadding: EdgeInsets.only(
                left: 20.r, right: 20.r, top: 10.r, bottom: 5.r),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10.h),
                  CustomBorderTextField(
                    hintText: "Term",
                    maxChar: 50,
                    controller: termController,
                    onChanged: (_) {
                      setState(updateButtonState);
                    },
                  ),
                  Gap(20.h),
                  CustomBorderTextField(
                    minLines: 2,
                    maxLines: 5,
                    hintText: "Definition",
                    controller: definitionController,
                    onChanged: (_) {
                      setState(updateButtonState);
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: isButtonEnabled
                    ? () {
                        String term = termController.text.trim();
                        String definition = definitionController.text.trim();

                        onAdd(term, definition);
                        Navigator.pop(context, true);
                      }
                    : null,
                child: Text(
                  isEdit ? "Save Changes" : "Add",
                  style: TextStyle(
                      color: isButtonEnabled
                          ? Theme.of(context).colorScheme.tertiary
                          : Colors.grey),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

                                                    
                                                  
                                                