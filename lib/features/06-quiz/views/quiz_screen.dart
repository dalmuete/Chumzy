import 'dart:async';

import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:chumzy/features/06-quiz/views/done_quiz_screen.dart';
import 'package:chumzy/features/06-quiz/widgets/q_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuizScreen extends StatefulWidget {
  final List<Map<String, dynamic>> assignedItems;
  final int? timerDuration;
  const QuizScreen({
    super.key,
    required this.assignedItems,
    this.timerDuration,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String _remainingTime = "";
  int? _timeInSeconds;
  // ignore: unused_field
  Timer? _timer;

  int currentIndex = 0;
  late List<TextEditingController> controllers;

  void _updateUserAnswer(dynamic answer) {
    Future.microtask(() {
      setState(() {
        widget.assignedItems[currentIndex]['userAnswer'] = answer;
      });
    });
  }

  bool _isNavigating = false;

  void _nextQuestion() {
    if (_isNavigating) return;
    if (currentIndex >= widget.assignedItems.length - 1) {
      endQuiz();
      return;
    }

    _isNavigating = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentIndex++;
      });
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _isNavigating = false;
    });
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          currentIndex--;
        });
      });
    }
  }

  void endQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DoneQuizScreen(
          assignedItems: widget.assignedItems,
        ),
      ),
    );
  }

  Color _getRemainingTimeColor() {
    int remainingTimeInSeconds = _timeInSeconds!;

    if (remainingTimeInSeconds <= 10) {
      return Colors.red;
    } else if (remainingTimeInSeconds <= 30) {
      return Theme.of(context).colorScheme.tertiary;
    } else {
      return Colors.grey;
    }
  }

  void _startTimer() {
    if (_timeInSeconds != null && _timeInSeconds! > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_timeInSeconds == 0) {
          timer.cancel();
          endQuiz();
        } else {
          setState(() {
            _timeInSeconds = _timeInSeconds! - 1;
            int hours = _timeInSeconds! ~/ 3600;
            int minutes = (_timeInSeconds! % 3600) ~/ 60;
            int seconds = _timeInSeconds! % 60;
            if (hours > 0) {
              _remainingTime =
                  '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
            } else {
              _remainingTime =
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controllers = widget.assignedItems.map<TextEditingController>((item) {
      if (item['type'] == 'Identification') {
        return TextEditingController(text: item['userAnswer'] ?? "");
      }
      return TextEditingController();
    }).toList();
    _timeInSeconds = widget.timerDuration ?? 0;
    if (_timeInSeconds! > 0) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.assignedItems[currentIndex];
    final controller = currentItem['type'] == 'Identification'
        ? controllers[currentIndex]
        : null;
    var card = currentItem['card'] as FlashCard;
    var type = currentItem['type'] as String;
    var userAnswer = currentItem['userAnswer'];

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(right: 30.w, left: 30.w, bottom: 50.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Gap(67.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        splashColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 5.r, top: 5.r, bottom: 5.r),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 24.r,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Gap(20.w),
                      Image.asset(
                        'assets/icons/quiz_icon.png',
                        height: 22.h,
                      ),
                      Gap(10.w),
                      Flexible(
                        child: Text(
                          "Chapter 2: Science Basics",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.timerDuration != null)
                        Text(
                          _remainingTime,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: _getRemainingTimeColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Flexible(
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 300,
                          animateFromLastPercent: true,
                          barRadius: Radius.circular(20.r),
                          lineHeight: 10.h,
                          percent:
                              (currentIndex + 1) / widget.assignedItems.length,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                          progressColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "${(currentIndex + 1)} / ${widget.assignedItems.length}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Gap(30.h),
                  QWidget(
                    card: card,
                    type: type,
                    userAnswer: userAnswer,
                    onAnswerChanged: _updateUserAnswer,
                    controller: controller,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousQuestion,
                    icon: CircleAvatar(
                      backgroundColor: currentIndex > 0
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Theme.of(context).primaryColor.withOpacity(0.05),
                      radius: 35.r,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: currentIndex > 0
                            ? Theme.of(context).primaryColor.withOpacity(0.5)
                            : Theme.of(context).primaryColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _nextQuestion,
                    icon: CircleAvatar(
                      backgroundColor:
                          currentIndex < widget.assignedItems.length - 1
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).colorScheme.secondary,
                      radius: 35.r,
                      child: Icon(Icons.arrow_forward_ios_rounded,
                          color: currentIndex < widget.assignedItems.length - 1
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Color(0xFF1c1c1e)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
