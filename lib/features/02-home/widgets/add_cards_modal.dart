import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/05-flashcards/views/add_manually_screen.dart';
import 'package:chumzy/features/05-flashcards/views/paste_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

void addCardsModal({
  required BuildContext context,
  required List<TextEditingController> controllers,
  required List<FocusNode> focusNodes,
  required Function addTextField,
  required Function removeTextField,
  required Function resetTextFields,
  required int maxFields,
  required Function setState,
  // required Subject? selectedSubject,
  // required Function(Subject) setSelectedSubject,
  // required Function resetSelectedSubject,
}) {
  Subject? selectedSubject;
  Topic? selectedTopic;
  bool isSubjectChanged = false;
  showModalBottomSheet(
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
    ),
    elevation: 1,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      final subjectProvider = Provider.of<SubjectProvider>(context);

      subjectProvider.fetchSubjects();

      Subject? initialSubject = null;
      if (initialSubject != null &&
          !subjectProvider.subjects.contains(initialSubject)) {
        initialSubject = null;
      }
      if (selectedSubject != null) {
        subjectProvider.fetchTopics(selectedSubject!);
      }
      Topic? initialTopic = null;
      if (initialTopic != null &&
          !subjectProvider.topicList.contains(initialTopic)) {
        initialTopic = null;
      }

      return StatefulBuilder(
        builder: (BuildContext context, innerSetState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.r,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 24.r,
                  right: 20.r),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    Gap(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Generate Cards",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    Gap(10.h),
                    CustomDropdown.search(
                      decoration: CustomDropdownDecoration(
                          expandedBorder: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)),
                          closedBorder: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)),
                          searchFieldDecoration: SearchFieldDecoration(
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)),
                          ),
                          closedFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          expandedFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          listItemDecoration: ListItemDecoration(
                              selectedIconBorder:
                                  const BorderSide(color: Colors.white),
                              selectedColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              highlightColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              splashColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1))),
                      hintText: 'Select a subject',
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        final title = item.title;
                        final lineColor = item.lineColor;
                        return GestureDetector(
                          onTap: () {
                            onItemSelect();
                            selectedSubject = item;

                            subjectProvider.fetchTopics(selectedSubject!);
                            selectedTopic = null;
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 20.w,
                                height: 20.h,
                                margin: EdgeInsets.only(right: 10.r),
                                decoration: BoxDecoration(
                                  color: lineColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      headerBuilder: (context, selectedItem, enabled) {
                        return Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              margin: EdgeInsets.only(right: 10.r),
                              decoration: BoxDecoration(
                                color: selectedItem?.lineColor ?? Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                selectedItem?.title ?? 'Select a subject',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      excludeSelected: true,
                      items: subjectProvider.subjects,
                      initialItem: initialSubject,
                      onChanged: (value) {
                        // selectedSubject = value;
                        // subjectProvider.fetchTopics(selectedSubject!);
                        // selectedTopic = null;
                        print('Changing value to: ${value!.title}');
                      },
                    ),
                    Gap(20.h),
                    CustomDropdown.search(
                      decoration: CustomDropdownDecoration(
                          expandedBorder: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)),
                          closedBorder: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1)),
                          searchFieldDecoration: SearchFieldDecoration(
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)),
                          ),
                          closedFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          expandedFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          listItemDecoration: ListItemDecoration(
                              selectedIconBorder:
                                  const BorderSide(color: Colors.white),
                              selectedColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              highlightColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              splashColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1))),
                      hintText: 'Select topic',
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        final title = item.title;
                        return GestureDetector(
                          onTap: () {
                            onItemSelect();
                            selectedTopic = item;
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      headerBuilder: (context, selectedItem, enabled) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedItem?.title ?? 'Select topic',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      excludeSelected: true,
                      items: subjectProvider.topicList,
                      initialItem: initialTopic,
                      onChanged: (value) {
                        // selectedSubject = value;
                        print('Changing value to: ${value!.title}');
                      },
                    ),
                    Gap(30.h),
                    Text(
                        "Select how you'd like to add your notes to create flashcards.",
                        style: TextStyle(
                            fontSize: 16.r,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.5))),
                    Gap(30.h),
                    CustomButton(
                        prefixIcon: const Icon(Icons.camera_alt_rounded),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        fontweight: FontWeight.w400,
                        padding: 17.r,
                        text: "Capture notes with camera",
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {}),
                    Gap(20.h),
                    CustomButton(
                        prefixIcon: const Icon(Icons.image_rounded),
                        backgroundColor: Colors.transparent,
                        borderColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                        fontweight: FontWeight.w400,
                        padding: 17.r,
                        text: "Upload an image",
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {}),
                    Gap(20.h),
                    CustomButton(
                        prefixIcon: const Icon(Icons.picture_as_pdf_rounded),
                        backgroundColor: Colors.transparent,
                        borderColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                        fontweight: FontWeight.w400,
                        padding: 17.r,
                        text: "Upload a PDF file",
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {}),
                    Gap(20.h),
                    CustomButton(
                        prefixIcon: const Icon(Icons.paste_rounded),
                        backgroundColor: Colors.transparent,
                        borderColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                        fontweight: FontWeight.w400,
                        padding: 17.r,
                        text: "Paste notes",
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PasteNotesScreen(),
                            ))),
                    Gap(10.h),
                    CustomButton(
                        backgroundColor: Colors.transparent,
                        fontweight: FontWeight.w400,
                        padding: 15.r,
                        text: "Add manually",
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddManuallyScreen(),
                            ))),
                    Gap(50.h),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
