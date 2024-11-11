import 'package:chumzy/core/widgets/textfields/custom_graytextfield.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/subjects/controllers/subjects-topics_controller.dart';
import 'package:chumzy/core/widgets/cards/subject-topic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SubjectsScreen extends StatefulWidget {
  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  var searchController = TextEditingController();
  final SubjectsTopicsController _controller = SubjectsTopicsController();

 
  void _toggleArrow() {
    setState(() {
      _controller.toggleArrow();
    });
  }

  void _toggleSort() {
    setState(() {
      _controller.toggleSort();
    });
  }

  @override
  Widget build(BuildContext context) { 
     final subjectProvider = Provider.of<SubjectProvider>(context);
    return Column(
      children: [
        Gap(20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your Subjects",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary)),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: _toggleSort,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Tooltip(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      preferBelow: false,
                      message: "Sort by",
                      child: Text(_controller.isSortByAlpha ? "Name" : "Date",
                          style:
                              TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    ),
                  ),
                ),
                Gap(3.w),
                Container(
                  width: (0.5).w,
                  height: 20.h,
                  color: Colors.grey[400],
                ),
                Gap(3.w),
                InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: _toggleArrow,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Icon(
                        _controller.isAscending
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: Colors.grey,
                        size: 20.sp),
                  ),
                )
              ],
            )
          ],
        ),
        Gap(20.h),
        CustomGrayTextField(
          hintText: "Search subjects or locate topics",
          controller: searchController,
          icon: Icon(Icons.search, size: 20.sp),
        ),
        Gap(20.h),
        Expanded(
          child: ListView.builder(
            itemCount: subjectProvider.subjects.length,
            itemBuilder: (BuildContext context, int i) {
               final subject = subjectProvider.subjects[i];
              return SubjectTopicCard(
                  lineColor: subject.lineColor,
                  title: subject.title,
                  totalNoItems: subject.totalNoItems,
                  lastUpdated: subject.lastUpdated,
                  onTap: () {
          subjectProvider.selectedSubjectIndex = i;

          Navigator.pushNamed(context, '/topics');
        },);
            },
          ),
        ),
      ],
    );
  }
}
