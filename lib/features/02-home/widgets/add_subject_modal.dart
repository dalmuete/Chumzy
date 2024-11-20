import 'package:chumzy/core/widgets/buttons/custom_btn.dart';
import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

const List<Color> colorOptions = [
  Color(0xFF153465),
  Color(0xFF67160e),
  Color(0xFF135714),
  Color(0xFF341b4d),
  Color(0xFFb45c18),
  Color(0xFFcca529),
];

void showColorSelectorDialog({
  required BuildContext context,
  required Color initialColor,
  required Function(Color) onColorSelected,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Subject Color', style: TextStyle(fontSize: 16.sp)),
        content: SizedBox(
          width: 200.w,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: colorOptions.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final color = colorOptions[index];
              return GestureDetector(
                onTap: () {
                  onColorSelected(color);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: color == initialColor
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  ).then((_) {
    FocusScope.of(context).requestFocus(FocusNode());
  });
}

void addSubjectModal({
  required BuildContext context,
  required List<TextEditingController> controllers,
  required List<FocusNode> focusNodes,
  required Function addTextField,
  required Function removeTextField,
  required Function resetTextFields,
  required int maxFields,
  required Function setState,
  required List<Color> subjectColors,
  required Function(int, Color) setSubjectColor,
  required Function resetAllColors,
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
      // PROVIDER HERE -------
      var subjectProvider = Provider.of<SubjectProvider>(context);
      // PROVIDER HERE -------

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
                        margin: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    Gap(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Add new subject",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    Gap(30.h),
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
                                    Tooltip(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      preferBelow: false,
                                      message: "Subject color",
                                      child: IconButton(
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.circle,
                                            size: 40.r,
                                            color: subjectColors[index],
                                          ),
                                        ),
                                        onPressed: () {
                                          showColorSelectorDialog(
                                            context: context,
                                            initialColor: subjectColors[index],
                                            onColorSelected: (newColor) {
                                              innerSetState(() {
                                                subjectColors[index] = newColor;
                                              });
                                              setSubjectColor(index, newColor);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Gap(10.w),
                                    Expanded(
                                      child: CustomBorderTextField(
                                        maxChar: 30,
                                        hintText: "Subject name",
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
                                        icon: Icon(Icons.remove_rounded),
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
                                    onPressed: () {
                                      subjectProvider.saveSubject(
                                        context,
                                        controllers,
                                        subjectColors,
                                        focusNodes,
                                      );
                                    }),
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
