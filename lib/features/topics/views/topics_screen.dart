import 'package:chumzy/core/widgets/textfields/custom_graytextfield.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/subjects/controllers/subjects-topics_controller.dart';
import 'package:chumzy/core/widgets/cards/subject-topic_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
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
    final subjectProvider =
        Provider.of<SubjectProvider>(context, listen: false);

    final selectedSubject =
        subjectProvider.subjects[subjectProvider.selectedSubjectIndex];

    final topicList = selectedSubject.topics ?? [];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                width: MediaQuery.of(context).size.width,
                height: 260.h,
                decoration: BoxDecoration(
                  color: selectedSubject.lineColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r)),
                ),
                child: Column(
                  children: [
                    Gap(55.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.black.withOpacity(0.5),
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 16.r,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                              ),
                              Gap(5),
                              Text("Back",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                  ))
                            ],
                          ),
                        ),
                        PopupMenuButton<int>(
                          onSelected: (value) {
                            switch (value) {
                              case 0:
                                break;
                              case 1:
                                break;
                              case 2:
                                break;
                            }
                          },
                          icon: Icon(
                            Icons.more_vert,
                          ),
                          iconSize: 20.r,
                          padding: EdgeInsets.all(0),
                          position: PopupMenuPosition.under,
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Text('Select'),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Text('Edit'),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Text('Delete this subject'),
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: selectedSubject.title,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: '  topics',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomGrayTextField(
                            hintText: "Search topics",
                            controller: searchController,
                            icon: Icon(Icons.search, size: 20.sp),
                          ),
                        ),
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
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  preferBelow: false,
                                  message: "Sort by",
                                  child: Text(
                                      _controller.isSortByAlpha
                                          ? "Name"
                                          : "Date",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.grey)),
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
                  ],
                ),
              ),
              Expanded(
                child: topicList.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: 0, right: 30, left: 30),
                        itemCount: topicList.length,
                        itemBuilder: (BuildContext context, int i) {
                          final topic = topicList[i];
                          return SubjectTopicCard(
                            lineColor: selectedSubject.lineColor,
                            title: topic.title,
                            totalNoItems: topic.totalNoItems,
                            lastUpdated: topic.lastUpdated,
                            isSubject: false,
                            onTap: () {},
                          );
                        },
                      )
                    : Center(child: Text("No topics at the moment.")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
