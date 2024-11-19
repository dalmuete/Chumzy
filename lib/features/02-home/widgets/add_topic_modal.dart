import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:provider/provider.dart';

void addTopicModal({
  required BuildContext context,
  required List<TextEditingController> controllers,
  required List<FocusNode> focusNodes,
  required Function addTextField,
  required Function removeTextField,
  required Function resetTextFields,
  required int maxFields,
  required Function setState,
  required Subject? selectedSubject,
  required Function(Subject) setSelectedSubject,
  required Function resetSelectedSubject,
}) {
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

      Subject? initialSubject = selectedSubject;
      if (initialSubject != null &&
          !subjectProvider.subjects.contains(initialSubject)) {
        initialSubject = null;
      }

      return StatefulBuilder(
        builder: (BuildContext context, innerSetState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.r, bottom: 20.r, left: 24.r, right: 20.r),
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
                        Text("Add new topic",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    Gap(30.h),
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
                            setSelectedSubject(item);
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
                        setSelectedSubject(value!);
                        print('Changing value to: ${value!.title}');
                      },
                    ),
                    Gap(20.h),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          Column(
                            children: List.generate(
                              controllers.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomBorderTextField(
                                        maxChar: 30,
                                        hintText: "Topic name",
                                        controller: controllers[index],
                                        focusNode: focusNodes[index],
                                      ),
                                    ),
                                    if (controllers.length > 1)
                                      IconButton(
                                        onPressed: () {
                                          innerSetState(() {
                                            removeTextField(index, setState);
                                          });
                                        },
                                        icon: const Icon(Icons.remove_rounded),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: controllers.length < maxFields
                                  ? () {
                                      addTextField(innerSetState);
                                    }
                                  : null,
                              child: Text(
                                "+ Add another",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: controllers.length < maxFields
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Gap(50.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                    fontweight: FontWeight.w600,
                                    padding: 15.r,
                                    text: "Save",
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                          Gap(5.h),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              onPressed: () {
                                resetSelectedSubject();
                                resetTextFields(innerSetState);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Gap(10.h),
                        ],
                      ),
                    ),
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
