import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:chumzy/core/widgets/textfields/custom_searbarfield.dart';
import 'package:chumzy/core/widgets/textfields/custom_subjectsearchfield.dart';
import 'package:chumzy/core/widgets/textfields/custom_topic_search.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/data/providers/topic_provider.dart';
import 'package:chumzy/features/02-home/controllers/subject_controller.dart';
import 'package:chumzy/features/02-home/controllers/topic_controller.dart';
import 'package:chumzy/features/03-subjects/controllers/subjects-topics_controller.dart';
import 'package:chumzy/core/widgets/cards/subject-topic_card.dart';
import 'package:chumzy/features/04-topics/views/topic_view_screen.dart';
import 'package:chumzy/features/04-topics/widgets/add_topic_modal_topicScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TopicsScreen extends StatefulWidget {
  final Subject subject;
  const TopicsScreen({required this.subject, super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen>
    with TickerProviderStateMixin {
  var searchController = TextEditingController();
  final SubjectsTopicsController _controller = SubjectsTopicsController();

  late SubjectController _subjectController;
  late TopicController _topicController;
  late SubjectProvider _subjectProvider;
  var topicNameController = TextEditingController();
  bool isAscendingTopic = false;

  void _toggleArrow() {
    setState(() {
      isAscendingTopic = !isAscendingTopic;
    });
  }

  void _toggleSort() {
    setState(() {
      _controller.toggleSort();
    });
  }

  @override
  void initState() {
    super.initState();
    _subjectProvider = Provider.of<SubjectProvider>(context, listen: false);
    _subjectController = SubjectController();
    _topicController = TopicController();
  }

  @override
  void dispose() {
    _subjectController.disposeControllers();
    _topicController.disposeControllers();
    super.dispose();
  }

  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);
    final topicProvider = Provider.of<TopicProvider>(context);

    final selectedSubject = subjectProvider.isSearched
        ? subjectProvider.searchedSubjects[subjectProvider.selectedSubjectIndex]
        : subjectProvider.subjects[subjectProvider.selectedSubjectIndex];

    List<Topic> topicList = selectedSubject.topics ?? [];
    topicList.sort((a, b) {
      if (subjectProvider.isSortByDateTopic) {
        // Sort by date
        if (subjectProvider.isAscendingTopic) {
          return a.lastUpdated.compareTo(b.lastUpdated);
        } else {
          return b.lastUpdated.compareTo(a.lastUpdated);
        }
      } else {
        // Sort by name
        if (subjectProvider.isAscendingTopic) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        } else {
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        }
      }
    });

    int topicsLength = selectedSubject.topics!.length;

    if (subjectProvider.isSearchedTopic) {
      setState(() {
        topicList = subjectProvider.searchedTopics;
      });
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onPanDown: (details) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Tooltip(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          preferBelow: false,
          message: "Add new topic",
          child: FloatingActionButton(
              onPressed: () {
                addTopicModalTopicScreen(
                    context: context,
                    controllers: _topicController.controllers,
                    focusNodes: _topicController.focusNodes,
                    addTextField: _topicController.addTextField,
                    removeTextField: _topicController.removeTextField,
                    resetTextFields: _topicController.resetAllTextFields,
                    maxFields: 5,
                    setState: setState,
                    subject: widget.subject);
              },
              backgroundColor: selectedSubject.lineColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.r))),
              elevation: 0,
              child: Icon(Icons.add_rounded, size: 35.r)),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
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
                          borderRadius: BorderRadius.circular(10.r),
                          splashColor:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 5.r, top: 5.r, bottom: 5.r),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 24.r,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Tooltip(
                            showDuration: Duration(seconds: 3),
                            triggerMode: TooltipTriggerMode.tap,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            margin: EdgeInsets.all(20.r),
                            preferBelow: false,
                            message:
                                "To edit a topic, just swipe LEFT. To remove it, swipe RIGHT.",
                            child: Icon(Icons.info_rounded))
                        // PopupMenuButton<int>(
                        //   onSelected: (value) {
                        //     switch (value) {
                        //       case 0:
                        //         subjectProvider.deleteSubject(
                        //             context, widget.subject);
                        //         break;
                        //     }
                        //   },
                        //   icon: Icon(
                        //     Icons.menu_rounded,
                        //     size: 24.r,
                        //     color: Colors.white,
                        //   ),
                        //   iconSize: 30.r,
                        //   padding: const EdgeInsets.all(0),
                        //   position: PopupMenuPosition.under,
                        //   itemBuilder: (BuildContext context) => [
                        //     const PopupMenuItem<int>(
                        //       value: 0,
                        //       child: Text('Delete this subject'),
                        //     ),
                        //   ],
                        // )
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
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: '  topics',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTopicSearchBarField(
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                              if (searchController.text.isEmpty) {
                                subjectProvider
                                    .isSearchToggleTopic(searchController);
                              }
                            },
                            hintText: "Search topics",
                            controller: searchController,
                            sufixIcon: IconButton(
                              onPressed: () {
                                subjectProvider
                                    .isSearchToggleTopic(searchController);
                                setState(() {
                                  isFocused = false;
                                });
                              },
                              icon: subjectProvider.isSearchedTopic
                                  ? Icon(Icons.clear,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 24.r)
                                  : Icon(Icons.search,
                                      color: Colors.white.withOpacity(0.6),
                                      size: 24.r),
                            ),
                            onchange: (value) {
                              subjectProvider.searchTopic(
                                  selectedSubject, value!);
                              setState(() {
                                isFocused = true;
                              });
                            },
                          ),
                          // child: CustomSearchBarField(
                          //   onTapOutside: (event) {
                          //     FocusScope.of(context).unfocus();
                          //   },
                          //   hintText: "Search topics",
                          //   controller: searchController,
                          //   icon: Icon(Icons.search,
                          //       size: 20.sp,
                          //       color: Colors.white.withOpacity(0.5)),
                          // ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20.r),
                              onTap:
                                  subjectProvider.toggleSortByDateOrTitleTopic,
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
                                      subjectProvider.isSortByDateTopic
                                          ? "Date"
                                          : "Name",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                            Gap(3.w),
                            Container(
                              width: (0.5).w,
                              height: 20.h,
                              color: Colors.white,
                            ),
                            Gap(3.w),
                            InkWell(
                              borderRadius: BorderRadius.circular(20.r),
                              onTap: subjectProvider.toggleArrowForSortingTopic,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                child: Icon(
                                    subjectProvider.isAscendingTopic
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,
                                    color: Colors.white,
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
              // HERE AND LIST -------------------
              Expanded(
                  child:

                  topicsLength<1 ?
 Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 0.5
                                  : 1.0,
                              child: Image.asset(
                                'assets/images/sad_2.png',
                                width: 100.r,
                              ),
                            ),
                            Gap(20.h),
                            Text(
                                "No topics added here yet.\nTap '+' to create your first topic.",
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

                  :
                  
                   topicList.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 0, right: 30, left: 30),
                          itemCount: topicList.length,
                          itemBuilder: (BuildContext context, int i) {
                            final topic = topicList[i];
                            return Dismissible(
                              dismissThresholds: {
                                DismissDirection.startToEnd: 0.9,
                                DismissDirection.endToStart: 0.9,
                              },
                              key: UniqueKey(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  topicNameController.text = topic.title;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text(
                                              "Edit Topic",
                                              style: TextStyle(fontSize: 20.sp),
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                left: 20.r,
                                                right: 20.r,
                                                top: 10.r,
                                                bottom: 5.r),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Gap(10.h),
                                                CustomBorderTextField(
                                                  hintText: "Topic Name",
                                                  maxChar: 50,
                                                  controller:
                                                      topicNameController,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  //edit here
                                                  topicProvider.updateTopicName(
                                                      context,
                                                      selectedSubject,
                                                      topic,
                                                      topicNameController.text);
                                                  subjectProvider
                                                      .fetchSubjects();
                                                },
                                                child: Text(
                                                  "Save Changes",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                  return false;
                                } else if (direction ==
                                    DismissDirection.startToEnd) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            children: [
                                              TextSpan(text: "Remove "),
                                              TextSpan(
                                                text: "Topic",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              TextSpan(text: "?"),
                                            ],
                                          ),
                                        ),
                                        content: Text(
                                          "Are you sure you want to remove this topic?",
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              topicProvider.deleteTopic(context,
                                                  selectedSubject, topic);
                                              topicList.removeAt(i);
                                            },
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
                                child: SubjectTopicCard(
                                  lineColor: selectedSubject.lineColor,
                                  title: topic.title,
                                  totalNoItems: topic.totalNoItems,
                                  lastUpdated: topic.lastUpdated,
                                  isSubject: false,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                      builder: (context) =>
                                          TopicViewScreen(topic: topic),
                                    ));
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 0.5
                                  : 1.0,
                              child: Image.asset(
                                'assets/images/sad_2.png',
                                width: 100.r,
                              ),
                            ),
                            Gap(20.h),
                            Text(
                                "No results found.",
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
                        ))),
            ],
          ),
        ),
      ),
    );
  }
}
