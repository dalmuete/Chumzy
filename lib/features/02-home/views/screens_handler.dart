// ignore_for_file: avoid_print

import 'package:chumzy/core/widgets/navbar.dart';
import 'package:chumzy/data/models/subject_model.dart';
import 'package:chumzy/data/providers/subject_provider.dart';
import 'package:chumzy/features/02-home/controllers/subject_controller.dart';
import 'package:chumzy/features/02-home/controllers/topic_controller.dart';
import 'package:chumzy/features/02-home/views/home_screen.dart';
import 'package:chumzy/features/02-home/widgets/add_cards_modal.dart';
import 'package:chumzy/features/02-home/widgets/add_subject_modal.dart';
import 'package:chumzy/features/02-home/widgets/add_topic_modal.dart';
import 'package:chumzy/features/09-profile/views/profile_screen.dart';
import 'package:chumzy/features/03-subjects/views/subjects_screen.dart';
import 'package:chumzy/features/08-chatbot/views/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ScreensHandler extends StatefulWidget {
  const ScreensHandler({super.key});

  @override
  ScreensHandlerState createState() => ScreensHandlerState();
}

class ScreensHandlerState extends State<ScreensHandler>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    SubjectsScreen(),
    ChatbotScreen(),
    ProfileScreen(),
  ];

  bool isAddIcon = true;
  late final AnimationController _fabRotationController;
  late final Animation<double> _fabRotationAnimation;

  late final AnimationController _dialogAnimationController;
  late final Animation<Offset> _dialogAnimation;

  late SubjectController _subjectController;
  late TopicController _topicController;
  Subject? selectedSubject;

  @override
  void initState() {
    super.initState();
    //new
    Future.microtask(() {
      Provider.of<SubjectProvider>(context, listen: false).fetchSubjects();
    });
    //old
    _subjectController = SubjectController();
    _topicController = TopicController();
    _fabRotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _fabRotationController, curve: Curves.easeInOut),
    );

    _dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _dialogAnimation =
        Tween<Offset>(begin: const Offset(0, -5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _dialogAnimationController,
        curve: Curves.elasticIn,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.disposeControllers();
    _topicController.disposeControllers();
    _fabRotationController.dispose();
    _dialogAnimationController.dispose();
    super.dispose();
  }

  void resetAllColors() {
    setState(() {
      _subjectController.subjectColors = List<Color>.filled(
        _subjectController.controllers.length,
        Color(0xFFcca529),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleFAB() {
    setState(() {
      isAddIcon = !isAddIcon;
    });
    if (isAddIcon) {
      _fabRotationController.reverse();
    } else {
      _fabRotationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    //New Code
    final subjectProvider =
        Provider.of<SubjectProvider>(context, listen: false);
    // subjectProvider.fetchSubjects();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30.h, right: 30.w, left: 30.w),
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: _selectedIndex ==
              2 // 2 is the index for ChatbotScreen
          ? null // Hide FAB when on ChatbotScreen
          : AnimatedBuilder(
              animation: _fabRotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _fabRotationAnimation.value * 2 * 3.141592653589793,
                  child: child,
                );
              },
              child: FloatingActionButton(
                onPressed: () {
                  _showMenuDialog(context, isLightMode);
                  _toggleFAB();
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: const CircleBorder(),
                elevation: 0,
                child: isAddIcon
                    ? const Icon(Icons.add_rounded, size: 35)
                    : const Icon(Icons.close_rounded, size: 30),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showMenuDialog(BuildContext context, bool isLightMode) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext dialogContext) {
        _dialogAnimationController.forward();

        return AnimatedBuilder(
          animation: _dialogAnimationController,
          builder: (context, child) {
            return Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: _dialogAnimation.value,
                child: Dialog(
                  elevation: 5,
                  shadowColor: isLightMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.3),
                  insetAnimationCurve: Curves.easeInOut,
                  insetPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.25,
                    right: MediaQuery.of(context).size.width * 0.25,
                    top: MediaQuery.of(context).size.height * 0.45,
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: isLightMode
                            ? Colors.black.withOpacity(0.2)
                            : Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.r, horizontal: 10.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            print("Add Subject selected");
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(dialogContext).pop();

                            addSubjectModal(
                              resetAllColors: resetAllColors,
                              context: context,
                              controllers: _subjectController.controllers,
                              focusNodes: _subjectController.focusNodes,
                              addTextField: _subjectController.addTextField,
                              removeTextField:
                                  _subjectController.removeTextField,
                              resetTextFields:
                                  _subjectController.resetAllTextFields,
                              maxFields: 5,
                              setState: setState,
                              subjectColors: _subjectController.subjectColors,
                              setSubjectColor: (index, color) {
                                setState(() {
                                  _subjectController.subjectColors[index] =
                                      color;
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.r, vertical: 15.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Gap(3.w),
                                Image.asset(
                                  'assets/icons/subjects_active_icon.png',
                                  width: 24.r,
                                ),
                                Gap(12.w),
                                Expanded(
                                  child: Text("Add new subject",
                                      style: TextStyle(fontSize: 14.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(10.h),
                        InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            print("Add Topic selected");
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(dialogContext).pop();
                            addTopicModal(
                              context: context,
                              controllers: _topicController.controllers,
                              focusNodes: _topicController.focusNodes,
                              addTextField: _topicController.addTextField,
                              removeTextField: _topicController.removeTextField,
                              resetTextFields:
                                  _topicController.resetAllTextFields,
                              maxFields: 5,
                              setState: setState,
                              selectedSubject: selectedSubject,
                              setSelectedSubject: (subject) {
                                setState(() {
                                  selectedSubject = subject;
                                });
                              },
                              resetSelectedSubject: () {
                                setState(() {
                                  selectedSubject = null;
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.r, vertical: 15.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.topic_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                Gap(10.w),
                                Expanded(
                                  child: Text("Add new topic",
                                      style: TextStyle(fontSize: 14.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(10.h),
                        InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            print("Add Cards selected");
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(dialogContext).pop();
                            addCardsModal(
                                context: context,
                                controllers: _topicController.controllers,
                                focusNodes: _topicController.focusNodes,
                                addTextField: _topicController.addTextField,
                                removeTextField:
                                    _topicController.removeTextField,
                                resetTextFields:
                                    _topicController.resetAllTextFields,
                                maxFields: 5,
                                setState: setState,
                                selectedSubject: selectedSubject,
                                setSelectedSubject: (subject) {
                                  setState(() {
                                    selectedSubject = subject;
                                  });
                                },
                                resetSelectedSubject: () {
                                  setState(() {
                                    selectedSubject = null;
                                  });
                                });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.r, vertical: 15.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.style_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                Gap(10.w),
                                Expanded(
                                  child: Text("Generate cards",
                                      style: TextStyle(fontSize: 14.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _toggleFAB();
      _dialogAnimationController.reverse();
    });
  }
}
