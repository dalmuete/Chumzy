// ignore_for_file: avoid_print

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);
    return Column(
      children: [
         Center(
          child: Text("Home tab",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        Gap(100.h),
        CustomDropdown.search(
          decoration: CustomDropdownDecoration(
              expandedBorder: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.1)),
              closedBorder: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.1)),
              searchFieldDecoration: SearchFieldDecoration(
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
              closedFillColor: Theme.of(context).scaffoldBackgroundColor,
              expandedFillColor: Theme.of(context).scaffoldBackgroundColor,
              listItemDecoration: ListItemDecoration(
                  selectedIconBorder: const BorderSide(color: Colors.white),
                  selectedColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  highlightColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  splashColor:
                      Theme.of(context).primaryColor.withOpacity(0.1))),
          hintText: 'Select a subject',
          listItemBuilder: (context, item, isSelected, onItemSelect) {
            final title = item.title;
            final lineColor = item.lineColor;
            return GestureDetector(
              onTap: onItemSelect,
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
                    color: selectedItem.lineColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    selectedItem.title,
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
          onChanged: (value) {
            print('changing value to: ${value!.title}');
          },
        ),
      ],
    );
  }
}
