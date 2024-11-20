// ignore_for_file: prefer_const_constructors

import 'package:chumzy/core/widgets/textfields/custom_subjectsearchfield.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/04-topics/views/topics_screen.dart';
import 'package:chumzy/features/03-subjects/controllers/subjects-topics_controller.dart';
import 'package:chumzy/core/widgets/cards/subject-topic_card.dart';
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
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);
    //Fetching the subjects
    // subjectProvider.fetchSubjects();

    //
    if (subjectProvider.subjects.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }

    if (subjectProvider.isSearched &&
        subjectProvider.searchedSubjects.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
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
                    onTap: () {
                      subjectProvider.toggleSortByDateOrTitle();
                      subjectProvider.sortDescSubject();
                    },
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
                        child: Text(
                            subjectProvider.isSortByDate ? "Date" : "Name",
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
                    onTap: () {
                      subjectProvider.toggleArrowForSortingSubject();
                      subjectProvider.sortDescSubject();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Icon(
                          subjectProvider.isAscending
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
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
              if (searchController.text.isEmpty) {
                subjectProvider.isSearchToggle(searchController);
              }
            },
            hintText: "Search subjects or locate topics",
            controller: searchController,
            sufixIcon: IconButton(
              onPressed: () {
                subjectProvider.isSearchToggle(searchController);
                setState(() {
                  isFocused = false;
                });
              },
              icon: subjectProvider.isSearched
                  ? Icon(Icons.clear,
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      size: 24.r)
                  : Icon(Icons.search,
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      size: 24.r),
            ),
            onchange: (value) {
              print("Value: $value");
              // subjectProvider.fetchSubjects(searchQuery: value!);
              subjectProvider.searchSubjects(value!);
              setState(() {
                isFocused = true;
              });
            },
          ),
          Gap(20.h),
          // HERE is the LIst ----------------------
          isEmpty
              ? Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: Theme.of(context).brightness == Brightness.dark
                          ? 0.5
                          : 1.0,
                      child: Image.asset(
                        'assets/images/sad_2.png',
                        width: 100.r,
                      ),
                    ),
                    Gap(20.h),
                    Text("No subjects yet.\nTap '+' to add your first one.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                        )),
                    Gap(50.h)
                  ],
                ))
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjectProvider.isSearched
                        ? subjectProvider.searchedSubjects.length
                        : subjectProvider.subjects.length,
                    itemBuilder: (BuildContext context, int i) {
                      final subject = subjectProvider.isSearched
                          ? subjectProvider.searchedSubjects[i]
                          : subjectProvider.subjects[i];
                      return SubjectTopicCard(
                        lineColor: subject.lineColor,
                        title: subject.title,
                        totalNoItems: subject.totalNoItems,
                        lastUpdated: subject.lastUpdated,
                        onTap: () {
                          subjectProvider.getSelectedSubjectIndex(i);
                          subjectProvider.clearSearchTopic();
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => TopicsScreen(
                                subject: subject,
                              ),
                            ),
                          );
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
