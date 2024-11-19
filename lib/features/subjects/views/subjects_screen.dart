// ignore_for_file: prefer_const_constructors

import 'package:chumzy/core/widgets/textfields/custom_subjectsearchfield.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/subjects/controllers/subjects-topics_controller.dart';
import 'package:chumzy/core/widgets/cards/subject-topic_card.dart';
import 'package:chumzy/features/topics/views/topics_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});
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

  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);
    //Fetching the subjects
    subjectProvider.fetchSubjects();

    //
    if (subjectProvider.subjects.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      isEmpty = false;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onPanDown: (details) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Gap(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your Subjects",
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: _toggleSort,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      child: Tooltip(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
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
          CustomSubjectSearchBarField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            hintText: "Search subjects or locate topics",
            controller: searchController,
          ),
          Gap(20.h),
          // HERE is the LIst ----------------------
          isEmpty
              ? Center(
                  child: const Center(
                    child: Text('No subjects found.'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjectProvider.subjects.length,
                    itemBuilder: (BuildContext context, int i) {
                      final subject = subjectProvider.subjects[i];
                      return SubjectTopicCard(
                        lineColor: subject.lineColor,
                        title: subject.title,
                        totalNoItems: subject.totalNoItems,
                        lastUpdated: subject.lastUpdated,
                        onTap: () {
                          subjectProvider.getSelectedSubjectIndex(i);

                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => TopicsScreen()));
                        },
                      );
                    },
                  ),
                ),
          // Expanded(
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: subjectProvider.subjects.length,
          //     itemBuilder: (BuildContext context, int i) {
          //       final subject = subjectProvider.subjects[i];
          //       return SubjectTopicCard(
          //         lineColor: subject.lineColor,
          //         title: subject.title,
          //         totalNoItems: subject.totalNoItems,
          //         lastUpdated: subject.lastUpdated,
          //         onTap: () {
          //           subjectProvider.selectedSubjectIndex = i;

          //           Navigator.of(context).push(CupertinoPageRoute(
          //               builder: (context) => TopicsScreen()));
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}


// child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//               stream: subjectProvider.getSubjectsStream(),
//               builder: (context, snapshot) {
//                 // if (snapshot.connectionState == ConnectionState.waiting) {
//                 //   return const Center(child: CircularProgressIndicator());
//                 // }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No subjects found.'));
//                 }

//                 final subjects = snapshot.data!.docs.map((doc) {
//                   return {
//                     'id': doc.id,
//                     ...doc.data(),
//                   };
//                 }).toList();

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: subjects.length,
//                   itemBuilder: (BuildContext context, int i) {
//                     final subject = subjects[i];

//                     final Timestamp createdAt = subject['createdAt'];
//                     final DateTime dateTime = createdAt.toDate();

//                     // Fetch the preloaded totalTopics field directly
//                     final int totalNoItems = subject['totalNoItems'] ?? 0;

//                     return SubjectTopicCard(
//                       lineColor: Color(int.parse(subject['lineColor'])),
//                       title: subject['title'],
//                       totalNoItems: totalNoItems,
//                       lastUpdated: dateTime,
//                       onTap: () {
//                         subjectProvider.getSelectedSubjectIndex(i);

//                         if (subjectProvider.subjects.isEmpty) {
//                           print(
//                               "Subjects list is empty. Cannot navigate to TopicsScreen.");
//                           return;
//                         }

//                         Navigator.of(context).push(CupertinoPageRoute(
//                           builder: (context) => TopicsScreen(),
//                         ));
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
