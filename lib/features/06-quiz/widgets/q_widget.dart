import 'package:chumzy/core/widgets/textfields/custom_bordertextfield.dart';
import 'package:chumzy/data/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QWidget extends StatefulWidget {
  final FlashCard card;
  final String type;
  final dynamic userAnswer;
  final Function(dynamic) onAnswerChanged;
  final TextEditingController? controller;

  QWidget({
    required this.card,
    required this.type,
    required this.userAnswer,
    required this.onAnswerChanged,
    this.controller,
  });

  @override
  State<QWidget> createState() => _QWidgetState();
}

class _QWidgetState extends State<QWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 'Identification':
        return _buildIdentificationQuestion();
      case 'Multiple Choice':
        return _buildMultipleChoiceQuestion();
      case 'True or False':
        return _buildTrueFalseQuestion();
      default:
        return SizedBox();
    }
  }

  Widget _buildIdentificationQuestion() {
    if (widget.controller == null) {
      return Center(child: Text("Error: No controller provided"));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.card.definitionOnlyWithoutTheAnswer,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        Gap(30.h),
        CustomBorderTextField(
          controller: widget.controller!,
          onChanged: (value) {
            widget.onAnswerChanged(value);
          },
          hintText: "Type your answer here",
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceQuestion() {
    int _selectedIndex =
        widget.card.multichoiceOptions.indexOf(widget.userAnswer ?? "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.card.definitionOnlyWithoutTheAnswer,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.card.multichoiceOptions.length,
          itemBuilder: (context, index) {
            final option = widget.card.multichoiceOptions[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onAnswerChanged(option);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedIndex == index
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: _selectedIndex == index
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrueFalseQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.card.trueOrFalseStatement,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        Gap(20.h),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => widget.onAnswerChanged(true),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: widget.userAnswer == true
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.userAnswer == true
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Center(
                  child: Text(
                    "True",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: widget.userAnswer == true
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: widget.userAnswer == true
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Gap(10.h),
            GestureDetector(
              onTap: () => widget.onAnswerChanged(false),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: widget.userAnswer == false
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.userAnswer == false
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Center(
                  child: Text(
                    "False",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: widget.userAnswer == false
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: widget.userAnswer == false
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
