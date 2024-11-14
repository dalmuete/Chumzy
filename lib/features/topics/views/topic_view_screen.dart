import 'package:chumzy/core/widgets/textfields/custom_graytextfield.dart';
import 'package:chumzy/core/widgets/textfields/custom_searbarfield.dart';
import 'package:chumzy/core/widgets/textfields/custom_subjectsearchfield.dart';
import 'package:chumzy/data/models/topic_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/subjects/controllers/subjects-topics_controller.dart';
import 'package:chumzy/core/widgets/cards/subject-topic_card.dart';
import 'package:chumzy/features/topics/views/topic_view_screen.dart';
import 'package:chumzy/features/topics/widgets/card_item_card.dart';
import 'package:chumzy/features/topics/widgets/review_options_card.dart';
import 'package:chumzy/features/topics/widgets/small_review_option_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TopicViewScreen extends StatefulWidget {
  final Topic topic;
  const TopicViewScreen({super.key, required this.topic});

  @override
  State<TopicViewScreen> createState() => _TopicViewScreenState();
}

class _TopicViewScreenState extends State<TopicViewScreen> {
  FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  var searchController = TextEditingController();
  final SubjectsTopicsController _controller = SubjectsTopicsController();
  bool _showReviewOptions = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _adjustScrollOnFocus();
      setState(() {
        _showReviewOptions = false;
      });
    }
    //  else {
    //   Future.delayed(Duration(milliseconds: 500), () {
    //     setState(() {
    //       _showReviewOptions = true;
    //     });
    //   });
    // }
  }

  void _adjustScrollOnFocus() {
    if (_focusNode.hasFocus) {
      double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (keyboardHeight > 0) {
        _scrollController.animateTo(
          _scrollController.position.pixels + keyboardHeight,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _showReviewOptions = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showReviewOptions && _scrollController.offset <= 10) {
        setState(() {
          _showReviewOptions = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onPanDown: (details) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                        padding:
                            EdgeInsets.only(right: 5.r, top: 5.r, bottom: 5.r),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_rounded,
                              size: 24.r,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
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
                        Icons.menu_rounded,
                        size: 24.r,
                        color: Theme.of(context).primaryColor,
                      ),
                      iconSize: 30.r,
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
                          child: Text('Delete this topic'),
                        ),
                      ],
                    )
                  ],
                ),
                Gap(10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: selectedSubject.lineColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      width: 8.w,
                      height: 20.w,
                    ),
                    Gap(10.w),
                    Expanded(
                      child: Text(selectedSubject.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedSubject.lineColor,
                          )),
                    ),
                    Gap(20.w),
                  ],
                ),
                Gap(10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "38 Cards",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(10.h),
                AnimatedCrossFade(
                  firstChild: Column(
                    children: [
                      SizeTransition(
                        sizeFactor: _showReviewOptions
                            ? AlwaysStoppedAnimation(1.0)
                            : AlwaysStoppedAnimation(0.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.topic.title,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Theme.of(context).primaryColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: _showReviewOptions
                            ? AlwaysStoppedAnimation(1.0)
                            : AlwaysStoppedAnimation(0.0),
                        child: ReviewOptionsCard(
                          iconSize: 40,
                          iconPath: 'assets/icons/flashcard_icon.png',
                          title: "Flashcards",
                          onTap: () {},
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizeTransition(
                              sizeFactor: _showReviewOptions
                                  ? AlwaysStoppedAnimation(1.0)
                                  : AlwaysStoppedAnimation(0.0),
                              child: ReviewOptionsCard(
                                iconSize: 35,
                                iconPath: 'assets/icons/quiz_icon.png',
                                title: "Quiz",
                                onTap: () {},
                              ),
                            ),
                          ),
                          Gap(20.w),
                          Expanded(
                            child: SizeTransition(
                              sizeFactor: _showReviewOptions
                                  ? AlwaysStoppedAnimation(1.0)
                                  : AlwaysStoppedAnimation(0.0),
                              child: ReviewOptionsCard(
                                iconSize: 40,
                                iconPath: 'assets/icons/audio_icon.png',
                                title: "Audio",
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  secondChild: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.topic.title,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SmallReviewOptionsCard(
                                  iconSize: 25.r,
                                  iconPath: 'assets/icons/flashcard_icon.png',
                                  title: "F-cards",
                                  onTap: () {})),
                          Gap(10.w),
                          Expanded(
                              child: SmallReviewOptionsCard(
                                  iconSize: 20.r,
                                  iconPath: 'assets/icons/quiz_icon.png',
                                  title: "Quiz",
                                  onTap: () {})),
                          Gap(10.w),
                          Expanded(
                              child: SmallReviewOptionsCard(
                                  iconSize: 25.r,
                                  iconPath: 'assets/icons/audio_icon.png',
                                  title: "Audio",
                                  onTap: () {}))
                        ],
                      ),
                    ],
                  ),
                  crossFadeState: _showReviewOptions
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 300),
                ),
                Gap(20.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomSubjectSearchBarField(
                        onTap: () {
                          _adjustScrollOnFocus();
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        hintText: "Search terms or definitions",
                        controller: searchController,
                        focusNode: _focusNode,
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
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              preferBelow: false,
                              message: "Sort by",
                              child: Text(
                                  _controller.isSortByAlpha ? "Name" : "Date",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ),
                        ),
                        Gap(3.w),
                        Container(
                          width: (0.5).w,
                          height: 20.h,
                          color: Theme.of(context).primaryColor,
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
                                color: Theme.of(context).primaryColor,
                                size: 20.sp),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Gap(20.h),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: 10,
                    itemBuilder: (context, i) {
                      return CardItemCard(
                        term: "Term #${i + 1}",
                        definition: "Definition ${i + 1}",
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
